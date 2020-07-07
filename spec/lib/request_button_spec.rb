# frozen_string_literal: true

require 'request_button'

describe RequestButton do
  # Used to test the request button based on a specific version, URL, and accept header.
  #
  # Example:
  # context 'when version is :version' do
  #   include_examples(
  #     'generates the button HTML based off of the provided parameters',
  #     :version,
  #     version_url,
  #     version_header
  #   )
  # end
  #
  shared_examples 'generates the button HTML based off of the provided parameters' do |version, url, header|
    subject(:get) { RequestButton.get(version, endpoint, example_status, example_json) }

    let(:expected_html) do
      "<div><button id=\"#{button_id}\" class=\"request-button\" type=\"button\" data-status=\"#{example_status}\" "\
      "onclick=\"#{onclick_button}\">Make Request</button>"\
      "<a class=\"example-response-toggle hide\" onclick=\"#{onclick_anchor}\">Show Example Response</a></div>\n"\
      "<div><h4>Example Response</h4>#{status}#{response}#{disclaimer}</div>"
    end
    let(:button_id) { SecureRandom.uuid }
    let(:onclick_button) do
      "makeRequest('#{url}#{endpoint}', '#{header}', this)"
    end
    let(:onclick_anchor) { "toggleExampleResponse('#{button_id}')" }
    let(:status) { '<pre class="headers">...</pre>' }
    let(:response) { '<pre class="body-response">...</pre>' }
    let(:disclaimer) { 'Disclaimer message' }

    before do
      allow(SecureRandom).to receive(:uuid).and_return(button_id)
      allow(RequestButton).to receive(:headers).with({status: example_status}).and_return(status)
      allow(RequestButton).to receive(:json).with(example_json).and_return(response)
      allow(RequestButton).to receive(:disclaimer).and_return(disclaimer)
    end

    context 'when the example response is generated' do
      after { subject }

      it 'calls #headers' do
        expect(RequestButton).to receive(:headers).with({status: example_status})
      end

      it 'calls #json' do
        expect(RequestButton).to receive(:json).with(example_json)
      end

      it 'calls #disclaimer' do
        expect(RequestButton).to receive(:disclaimer)
      end
    end

    it 'returns the request button HTML' do
      expect(subject).to eq(expected_html)
    end
  end

  describe '.get' do
    let(:endpoint) { 'metadata' }
    let(:example_status) { 200 }
    let(:example_json) { :dstu2_open_metadata }

    context 'when version is :dstu2' do
      include_examples(
        'generates the button HTML based off of the provided parameters',
        :dstu2,
        'https://fhir-open.sandboxcerner.com/dstu2/0b8a0111-e8e6-4c26-a91c-5069cbc6b1ca/',
        'application/json+fhir'
      )
    end

    context 'when version is :dstu2_closed' do
      include_examples(
        'generates the button HTML based off of the provided parameters',
        :dstu2_closed,
        'https://fhir-ehr.sandboxcerner.com/dstu2/0b8a0111-e8e6-4c26-a91c-5069cbc6b1ca/',
        'application/json+fhir'
      )
    end

    context 'when version is :r4' do
      include_examples(
        'generates the button HTML based off of the provided parameters',
        :r4,
        'https://fhir-open.sandboxcerner.com/r4/0b8a0111-e8e6-4c26-a91c-5069cbc6b1ca/',
        'application/fhir+json'
      )
    end

    context 'when version is :r4_closed' do
      include_examples(
        'generates the button HTML based off of the provided parameters',
        :r4_closed,
        'https://fhir-ehr.sandboxcerner.com/r4/0b8a0111-e8e6-4c26-a91c-5069cbc6b1ca/',
        'application/fhir+json'
      )
    end
  end
end
