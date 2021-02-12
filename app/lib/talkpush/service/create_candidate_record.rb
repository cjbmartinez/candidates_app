module Talkpush
  module Service
    class CreateCandidateRecord
      CAMPAIGN_ID = "4339".freeze
      API_KEY = "48530ba23eef6b45ffbc95d7c20a60b9".freeze
      API_SECRET = "e2f724ba060f82ddf58923af494578a7".freeze

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
          "api_key": API_KEY,
          "api_secret": API_SECRET,
          "campaign_invitation": {
            "first_name": first_name,
            "last_name": last_name,
            "email": email,
            "user_phone_number": phone
          }
        }
      end

      def post_candidate_path
        ["campaigns", CAMPAIGN_ID, "campaign_invitations"].join("/")
      end
    end
  end
end
