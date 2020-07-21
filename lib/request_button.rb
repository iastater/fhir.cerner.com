# frozen_string_literal: true

require 'securerandom'

class RequestButton
  # The open and closed URLs for each API version
  URLS = {
    dstu2: 'https://fhir-open.sandboxcerner.com/dstu2/0b8a0111-e8e6-4c26-a91c-5069cbc6b1ca/',
    dstu2_closed: 'https://fhir-ehr.sandboxcerner.com/dstu2/0b8a0111-e8e6-4c26-a91c-5069cbc6b1ca/',
    r4: 'https://fhir-open.sandboxcerner.com/r4/0b8a0111-e8e6-4c26-a91c-5069cbc6b1ca/',
    r4_closed: 'https://fhir-ehr.sandboxcerner.com/r4/0b8a0111-e8e6-4c26-a91c-5069cbc6b1ca/'
  }.freeze

  # The accept header for each API version
  HEADERS = {
    dstu2: 'application/json+fhir',
    r4: 'application/fhir+json'
  }.freeze

  private_constant :URLS, :HEADERS

  # @api public
  # Public: Builds the HTML for the request button and the example response using the provided parameters.
  #
  # @param version [Symbol] the API version, open or closed
  # @param enpoint [String] the endpoint of the request in the example
  # @param example_status [Number] the status for the example response header
  # @param example_json [Symbol] the json for the example response body
  #
  # @return [String] the HTML for the request button and the example response
  def self.get(version, endpoint, example_status, example_json)
    if URLS.key?(version)
      request_url = URLS[version] + endpoint
      accept_header = version.to_s.start_with?('dstu2') ? HEADERS[:dstu2] : HEADERS[:r4]
      button_id = SecureRandom.uuid

      onclick_button = "makeRequest('#{request_url}', '#{accept_header}', this)"
      onclick_anchor = "toggleExampleResponse('#{button_id}')"

      "<div><button id=\"#{button_id}\" class=\"request-button\" type=\"button\" data-status=\"#{example_status}\" "\
      "onclick=\"#{onclick_button}\">Make Request</button>"\
      "<a class=\"example-response-toggle hide\" onclick=\"#{onclick_anchor}\">Show Example Response</a></div>\n"\
      "<div><h4>Example Response</h4>#{headers(status: example_status)}#{json(example_json)}#{disclaimer}</div>"
    end
  end
end
