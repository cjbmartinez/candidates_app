require "rails_helper"

RSpec.describe Talkpush::Client do
  describe '#call' do
    let(:method) { :post }
    let(:path) { 'path' }
    let(:params) { { auth: 'param' } }
    let(:json) { {} }
    let(:headers) { {} }
    let(:http_success) { true }
    let(:http_code) { 200 }

    let(:mock_http_with_header) { double('MockHttpWithHeader') }
    let(:mock_http) { double('MockHttp', headers: mock_http_with_header) }
    let(:mock_http_with_method) { double('MockHttpWithMethod') }
    let(:mock_status) { double("MockStatus", success?: http_success) }
    let(:mock_http_result) { double('MockHttpResult', status: mock_status, code: http_code ) }
    let(:expected_uri) { 'https://my.talkpush.com/api/talkpush_services/path' }
    let(:expected_options) { { params: params, json: json } }

    subject { described_class.new.call(method: method, path: path, json: json, params: params, headers: headers) }

    before do
      expect(HTTP).to receive(:timeout).and_return(mock_http)
      expect(mock_http_with_header).to receive(:method).with(method).and_return(mock_http_with_method)
    end

    context 'when success' do
      before do
        expect(mock_http_with_method).to receive(:call).with(expected_uri, expected_options)
                                                       .and_return(mock_http_result)

        expect(mock_http_result).to receive(:parse)
      end

      context 'GET request' do
        let(:json) { {} }

        it { is_expected.to be_nil }
      end

      context 'POST request' do
        let(:params) { {} }
        let(:method) { :post }

        it { is_expected.to be_nil }
      end

      context 'PUT request' do
        let(:params) { {} }
        let(:method) { :put }

        it { is_expected.to be_nil }
      end
    end

    context 'when 400 response code' do
      let(:http_success) { false }
      let(:http_code) { 400 }

      before do
        expect(mock_http_with_method).to receive(:call).with(expected_uri, expected_options)
                                                       .and_return(mock_http_result)

        expect(mock_http_result).to receive(:parse).and_return({ 'message' => 'Error 400'})
      end

      context 'GET request' do
        it { expect { subject }.to raise_error(Talkpush::RequestError) }
      end

      context 'POST request' do
        let(:method) { :post }

        it { expect { subject }.to raise_error(Talkpush::RequestError) }
      end

      context 'PUT request' do
        let(:method) { :put }

        it { expect { subject }.to raise_error(Talkpush::RequestError) }
      end
    end

    context 'when http request error raise' do
      [
        HTTP::ConnectionError,
        HTTP::RequestError,
        HTTP::ResponseError,
        HTTP::StateError,
        HTTP::TimeoutError,
        HTTP::HeaderError
      ].each do |http_error|
        context "when #{http_error}" do
          let(:http_error) { http_error }

          before do
            expect(mock_http_with_method).to receive(:call).with(expected_uri, expected_options).and_raise(http_error)
          end

          it { expect { subject }.to raise_error(Talkpush::RequestError) }
        end
      end
    end
  end
end
