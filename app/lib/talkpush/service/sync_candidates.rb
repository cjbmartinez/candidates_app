module Talkpush
  module Service
    class SyncCandidates
      class << self
        def call
          candidates = google_sheet_candidates
          return { message: "You're all synced up! No records to be synced to Talkpush API" } if candidates.count == Candidate.count

          candidates.each do |candidate|
            date_applied, first_name, last_name, email, phone = candidate
            args = { first_name: first_name, last_name: last_name, email: email, phone: phone }
            existing_candidate = Candidate.find_by(args)
            next if existing_candidate

            create_and_sync_to_talkpush(args: args)
          end

          { message: "Successfully synced new candidates to Talkpush API!" }
        end

        private

        attr_reader :person, :dossier

        def google_sheet_candidates
          GoogleApi::GoogleSheet.read
        end

        def create_and_sync_to_talkpush(args:)
          Candidate.create(args)
          Talkpush::Service::CreateCandidateRecord.new(args).call
        end
      end
    end
  end
end
