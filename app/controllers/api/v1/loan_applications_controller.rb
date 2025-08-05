# app/controllers/api/v1/loan_applications_controller.rb
class Api::V1::LoanApplicationsController < ApplicationController
  before_action :set_loan_application, only: [:show, :update, :destroy, :submit]
  before_action :ensure_owner, only: [:show, :update, :destroy, :submit]
  
  # GET /api/v1/loan_applications
  def index
    @loan_applications = current_user.loan_applications.recent.includes(:documents)
    
    render json: {
      success: true,
      loan_applications: @loan_applications.map { |app| loan_application_response(app) },
      meta: {
        total: @loan_applications.count,
        pending: current_user.loan_applications.pending_review.count,
        approved: current_user.loan_applications.approved.count
      }
    }
  end
  
  # GET /api/v1/loan_applications/:id
  def show
    render json: {
      success: true,
      loan_application: detailed_loan_application_response(@loan_application)
    }
  end
  
  # POST /api/v1/loan_applications
  def create
    @loan_application = current_user.loan_applications.build(loan_application_params)
    
    if @loan_application.save
      render json: {
        success: true,
        loan_application: loan_application_response(@loan_application),
        message: 'Loan application created successfully'
      }, status: :created
    else
      render json: {
        success: false,
        errors: @loan_application.errors.full_messages
      }, status: :unprocessable_entity
    end
  end
  
  # PATCH/PUT /api/v1/loan_applications/:id
  def update
    if @loan_application.draft? && @loan_application.update(loan_application_params)
      render json: {
        success: true,
        loan_application: loan_application_response(@loan_application),
        message: 'Loan application updated successfully'
      }
    else
      error_message = @loan_application.draft? ? @loan_application.errors.full_messages : ['Cannot update submitted application']
      render json: {
        success: false,
        errors: error_message
      }, status: :unprocessable_entity
    end
  end
  
  # POST /api/v1/loan_applications/:id/submit
  def submit
    if @loan_application.can_be_submitted?
      @loan_application.update!(
        status: :submitted,
        applied_at: Time.current
      )
      
      # TODO: Trigger background job for processing
      ProcessLoanApplicationJob.perform_later(@loan_application.id)
      
      render json: {
        success: true,
        loan_application: loan_application_response(@loan_application),
        message: 'Loan application submitted successfully'
      }
    else
      render json: {
        success: false,
        error: 'Application cannot be submitted. Please ensure all required documents are uploaded.'
      }, status: :unprocessable_entity
    end
  end
  
  # DELETE /api/v1/loan_applications/:id
  def destroy
    if @loan_application.draft?
      @loan_application.destroy
      render json: {
        success: true,
        message: 'Loan application deleted successfully'
      }
    else
      render json: {
        success: false,
        error: 'Cannot delete submitted application'
      }, status: :unprocessable_entity
    end
  end
  
  private
  
  def set_loan_application
    @loan_application = LoanApplication.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: {
      success: false,
      error: 'Loan application not found'
    }, status: :not_found
  end
  
  def ensure_owner
    unless @loan_application.user == current_user
      render json: {
        success: false,
        error: 'Not authorized to access this application'
      }, status: :forbidden
    end
  end
  
  def loan_application_params
    params.require(:loan_application).permit(
      :loan_type, :amount, :purpose, :employment_status,
      :annual_income, :monthly_expenses, :existing_debts
    )
  end
  
  def loan_application_response(application)
    {
      id: application.id,
      loan_type: application.loan_type,
      amount: application.amount,
      status: application.status,
      risk_score: application.risk_score,
      applied_at: application.applied_at,
      decided_at: application.decided_at,
      created_at: application.created_at,
      updated_at: application.updated_at,
      documents_count: application.documents.count,
      can_be_submitted: application.can_be_submitted?
    }
  end
  
  def detailed_loan_application_response(application)
    loan_application_response(application).merge(
      purpose: application.purpose,
      employment_status: application.employment_status,
      annual_income: application.annual_income,
      monthly_expenses: application.monthly_expenses,
      existing_debts: application.existing_debts,
      decision_reason: application.decision_reason,
      documents: application.documents.map { |doc| document_response(doc) }
    )
  end
  
  def document_response(document)
    {
      id: document.id,
      document_type: document.document_type,
      original_filename: document.original_filename,
      file_url: document.file_url,
      file_size: document.file_size,
      uploaded_at: document.uploaded_at
    }
  end
end