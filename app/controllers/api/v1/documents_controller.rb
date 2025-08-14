# app/controllers/api/v1/documents_controller.rb
class Api::V1::DocumentsController < ApplicationController
  before_action :set_loan_application
  before_action :ensure_owner
  before_action :set_document, only: [:show, :destroy]
  
  # GET /api/v1/loan_applications/:loan_application_id/documents
  def index
    render json: {
      success: true,
      documents: @loan_application.documents.map { |doc| document_response(doc) }
    }
  end
  
  # GET /api/v1/loan_applications/:loan_application_id/documents/:id
  def show
    render json: {
      success: true,
      document: document_response(@document)
    }
  end
  
  # POST /api/v1/loan_applications/:loan_application_id/documents
  def create
    unless @loan_application.draft?
      return render json: {
        success: false,
        error: 'Cannot upload documents to submitted application'
      }, status: :unprocessable_entity
    end
    
    uploaded_file = params[:file]
    document_type = params[:document_type]
    
    unless uploaded_file && document_type
      return render json: {
        success: false,
        error: 'File and document_type are required'
      }, status: :bad_request
    end
    
    # Validate file type and size
    unless valid_file?(uploaded_file)
      return render json: {
        success: false,
        error: 'Invalid file type or size. Accepted: PDF, JPG, PNG. Max size: 10MB'
      }, status: :bad_request
    end
    
    begin
      # Upload to Cloudinary
      upload_result = Cloudinary::Uploader.upload(
        uploaded_file.tempfile,
        folder: "loan_documents/#{@loan_application.id}",
        resource_type: :auto,
        public_id: "#{document_type}_#{Time.current.to_i}",
        overwrite: false
      )
      
      # Create document record
      @document = @loan_application.documents.build(
        document_type: document_type,
        file_url: upload_result['secure_url'],
        original_filename: uploaded_file.original_filename,
        file_size: uploaded_file.size,
        uploaded_at: Time.current
      )
      
      if @document.save
        render json: {
          success: true,
          document: document_response(@document),
          message: 'Document uploaded successfully'
        }, status: :created
      else
        render json: {
          success: false,
          errors: @document.errors.full_messages
        }, status: :unprocessable_entity
      end
      
    rescue Cloudinary::Api::Error => e
      render json: {
        success: false,
        error: "Upload failed: #{e.message}"
      }, status: :internal_server_error
    end
  end
  
  # DELETE /api/v1/loan_applications/:loan_application_id/documents/:id
  def destroy
    unless @loan_application.draft?
      return render json: {
        success: false,
        error: 'Cannot delete documents from submitted application'
      }, status: :unprocessable_entity
    end
    
    begin
      # Delete from Cloudinary
      public_id = extract_public_id(@document.file_url)
      Cloudinary::Uploader.destroy(public_id) if public_id
      
      # Delete from database
      @document.destroy
      
      render json: {
        success: true,
        message: 'Document deleted successfully'
      }
    rescue => e
      render json: {
        success: false,
        error: "Delete failed: #{e.message}"
      }, status: :internal_server_error
    end
  end
  
  private
  
  def set_loan_application
    @loan_application = current_user.loan_applications.find(params[:loan_application_id])
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
        error: 'Not authorized'
      }, status: :forbidden
    end
  end
  
  def set_document
    @document = @loan_application.documents.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: {
      success: false,
      error: 'Document not found'
    }, status: :not_found
  end
  
  def valid_file?(file)
    return false unless file
    
    # Check file size (10MB max)
    return false if file.size > 10.megabytes
    
    # Check file type
    allowed_types = %w[application/pdf image/jpeg image/png]
    allowed_types.include?(file.content_type)
  end
  
  def extract_public_id(url)
    # Extract public_id from Cloudinary URL for deletion
    return nil unless url
    
    match = url.match(/\/v\d+\/(.+)\.\w+$/)
    match ? match[1] : nil
  end
  
  def document_response(document)
    {
      id: document.id,
      document_type: document.document_type,
      original_filename: document.original_filename,
      file_url: document.file_url,
      file_size: document.file_size,
      file_size_human: ActiveSupport::NumberHelper.number_to_human_size(document.file_size),
      uploaded_at: document.uploaded_at
    }
  end
end