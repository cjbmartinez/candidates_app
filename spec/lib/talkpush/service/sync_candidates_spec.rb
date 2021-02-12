require "rails_helper"  # this

RSpec.describe Talkpush::Service::SyncCandidates do
  describe '#call' do
    let(:mock_response) do
      [ ['10/12/2019 12:31:45', 'John', 'Lennon', 'jlenon@gmail.com', '09124569097'] ]
    end

    let(:mock_create_service) { instance_double(Talkpush::Service::CreateCandidateRecord) }

    let(:candidate_args) do
      { first_name: 'John', last_name: 'Lennon', email: 'jlenon@gmail.com', phone: '09124569097' }
    end

    before do
      expect(GoogleApi::GoogleSheet).to receive(:read).and_return(mock_response)
    end

    subject { described_class.call }

    context 'when candidates count from DB is same with Candidates count from Google Sheet' do
      before { Candidate.create(candidate_args) }

      it { expect(subject[:message]).to eq("You're all synced up! No records to be synced to Talkpush API") }
    end

    context 'when candidates count is not equal to Candidates count from Google Sheet' do
      context 'and candidate does not exist yet' do
        before do
          expect(Talkpush::Service::CreateCandidateRecord).to receive(:new).and_return(mock_create_service).with(candidate_args)
          expect(mock_create_service).to receive(:call).and_return(nil)
        end

        it 'creates new Candidate Record' do
          expect { subject }.to change{ Candidate.count }.by(1)
        end
        it { expect(subject[:message]).to eq("Successfully synced new candidates to Talkpush API!") }
      end
    end
  end
end
