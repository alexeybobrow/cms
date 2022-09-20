# frozen_string_literal: true

require_relative './wait_for_requests'

module InspectRequests
  extend self
  include WaitForRequests

  def inspect_requests(inject_headers: {})
    Testing::RequestInspectorMiddleware.log_requests!(inject_headers)

    yield

    wait_for_all_requests
    Testing::RequestInspectorMiddleware.requests
  ensure
    Testing::RequestInspectorMiddleware.stop_logging!
  end
end
