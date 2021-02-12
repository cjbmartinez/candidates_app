class CandidatesController < ApplicationController
  def index
    @candidates = GoogleApi::GoogleSheet.read
  end

  def sync_candidates
    handler = Talkpush::Service::SyncCandidates.call

    respond_to do |format|
      format.json do
        render json: { message: handler[:message] }
      end
    end

  rescue Talkpush::RequestError, Talkpush::MissingCandidateFieldError => e
    respond_to do |format|
      format.json do
        render json: { message: "Oops! An Error Occured : #{e.message}. Please try again."}
      end
    end
  end
end
