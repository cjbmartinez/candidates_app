require "rails_helper"

RSpec.describe Talkpush::Service::CreateCandidateRecord do
  describe '#call' do
    let(:first_name) { 'John' }
    let(:last_name) { 'Lennon' }
    let(:email) { 'test@test.com' }
    let(:phone) { '123' }

    let(:candidate_args) do
      { first_name: first_name, last_name: last_name, email: email, phone: phone }
    end

    subject { described_class.new(candidate_args).call }

    %i[first_name last_name email phone].each do |candidate_field|
      context "when ##{candidate_field} is null" do
        let(candidate_field.to_sym) { nil }

        it { expect{ subject }.to raise_error(Talkpush::MissingCandidateFieldError) }
      end
    end

    context 'when valid parameters' do
      let(:mock_client) { instance_double(Talkpush::Client) }
      let(:path) { "campaigns/12345/campaign_invitations"}
      let(:mock_response) { { message: 'Succesfully created candidate'} }

      let(:mock_json) do
        {
          "api_key": '123',
          "api_secret": '1234',
          "campaign_invitation": {
            "first_name": first_name,
            "last_name": last_name,
            "email": email,
            "user_phone_number": phone
          }
        }
      end

      before do
        expect(Talkpush::Client).to receive(:new).and_return(mock_client)
        expect(mock_client).to receive(:call).with(method: :post, path: path, json: mock_json).and_return(mock_response)
      end

      it 'persists' do
        expect(subject).to eq(mock_response)
      end
    end
  end
end
