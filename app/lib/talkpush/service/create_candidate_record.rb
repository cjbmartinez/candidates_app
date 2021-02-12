module Talkpush
  module Service
    class CreateCandidateRecord
      def initialize(first_name:, last_name:, email:, phone:)
        @first_name = first_name
        @last_name = last_name
        @email = email
        @phone = phone
      end

      def call
        raise Talkpush::MissingCandidateFieldError if missing_required_fields?

        Talkpush::Client.new.call(method: :post, path: post_candidate_path, json: post_candidate_json)
      end

      private

      attr_reader :first_name, :last_name, :email, :phone

      def missing_required_fields?
        [first_name, last_name, email, phone].any?(&:nil?)
      end

      def post_candidate_json
        {
          "api_key": ENV.fetch("TALKPUSH_API_KEY"),
          "api_secret": ENV.fetch("TALKPUSH_SECRET_KEY"),
          "campaign_invitation": {
            "first_name": first_name,
            "last_name": last_name,
            "email": email,
            "user_phone_number": phone
          }
        }
      end

      def post_candidate_path
        ["campaigns", ENV.fetch("TALKPUSH_CAMPAIGN_ID"), "campaign_invitations"].join("/")
      end
    end
  end
end
