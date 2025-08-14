# app/jobs/process_loan_application_job.rb
class ProcessLoanApplicationJob < ApplicationJob
  queue_as :default
  
  def perform(loan_application_id)
    loan_application = LoanApplication.find(loan_application_id)
    
    # Update status to under review
    loan_application.update!(status: :under_review)
    
    # Basic risk scoring (we'll enhance this in Week 3 with AI)
    risk_score = calculate_basic_risk_score(loan_application)
    
    # Make basic decision
    decision = risk_score > 700 ? :approved : :rejected
    decision_reason = generate_basic_decision_reason(loan_application, risk_score)
    
    # Update application
    loan_application.update!(
      status: decision,
      risk_score: risk_score,
      decision_reason: decision_reason,
      decided_at: Time.current
    )
    
    # TODO: Send notification email (Day 3 or 4)
    # NotificationMailer.loan_decision(loan_application).deliver_now
    
  rescue StandardError => e
    Rails.logger.error "Failed to process loan application #{loan_application_id}: #{e.message}"
    
    loan_application&.update!(
      status: :rejected,
      decision_reason: "Processing error occurred. Please contact support.",
      decided_at: Time.current
    )
  end
  
  private
  
  def calculate_basic_risk_score(application)
    score = 500  # Base score
    
    # Income factor
    if application.annual_income > 100_000
      score += 150
    elsif application.annual_income > 50_000
      score += 100
    elsif application.annual_income > 30_000
      score += 50
    end
    
    # Debt-to-income ratio
    debt_ratio = application.debt_to_income_ratio
    if debt_ratio < 20
      score += 100
    elsif debt_ratio < 40
      score += 50
    else
      score -= 100
    end
    
    # Employment status
    case application.employment_status
    when 'employed'
      score += 100
    when 'self_employed'
      score += 50
    when 'unemployed'
      score -= 200
    end
    
    # Loan amount vs income
    loan_to_income = (application.amount / application.annual_income) * 100
    if loan_to_income < 10
      score += 50
    elsif loan_to_income > 50
      score -= 100
    end
    
    # Ensure score is within bounds
    [200, [score, 850].min].max
  end
  
  def generate_basic_decision_reason(application, score)
    if score > 700
      "Approved based on strong financial profile: stable income of $#{application.annual_income.to_i}, low debt-to-income ratio of #{application.debt_to_income_ratio}%, and #{application.employment_status} status."
    else
      reasons = []
      
      if application.annual_income < 30_000
        reasons << "low annual income"
      end
      
      if application.debt_to_income_ratio > 40
        reasons << "high debt-to-income ratio (#{application.debt_to_income_ratio}%)"
      end
      
      if application.employment_status == 'unemployed'
        reasons << "unemployed status"
      end
      
      loan_to_income = (application.amount / application.annual_income) * 100
      if loan_to_income > 50
        reasons << "high loan-to-income ratio"
      end
      
      "Declined due to: #{reasons.join(', ')}. Risk score: #{score}/850."
    end
  end
end