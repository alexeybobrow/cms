# frozen_string_literal: true

module WaitForRequests
  extend self

  # This is inspired by http://www.salsify.com/blog/engineering/tearing-capybara-ajax-tests
  def block_and_wait_for_requests_complete
    block_requests { wait_for_all_requests }
  end

  # Block all requests inside block with 503 response
  def block_requests
    Testing::RequestBlockerMiddleware.block_requests!
    yield
  ensure
    Testing::RequestBlockerMiddleware.allow_requests!
  end

  # Slow down requests inside block by injecting `sleep 0.2` before each response
  def slow_requests
    Testing::RequestBlockerMiddleware.slow_requests!
    yield
  ensure
    Testing::RequestBlockerMiddleware.allow_requests!
  end

  # Wait for client-side AJAX requests
  def wait_for_requests
    wait_for('JS requests complete', max_wait_time: 2 * Capybara.default_max_wait_time) do
      finished_all_js_requests?
    end
  end

  # Wait for active Rack requests and client-side AJAX requests
  def wait_for_all_requests
    wait_for('pending requests complete') do
      finished_all_rack_requests? &&
        finished_all_js_requests?
    end
  end

  private

  # Waits until the passed block returns true
  def wait_for(condition_name, max_wait_time: Capybara.default_max_wait_time, polling_interval: 0.01, reload: false)
    wait_until = Time.now + max_wait_time.seconds
    loop do
      result = yield
      break if result

      page.refresh if reload

      if Time.now > wait_until
        raise "Condition not met: #{condition_name}"
      else
        sleep(polling_interval)
      end
    end
  end

  def javascript_test?
    Capybara.current_driver == Capybara.javascript_driver
  end

  def finished_all_rack_requests?
    Testing::RequestBlockerMiddleware.num_active_requests == 0
  end

  def finished_all_js_requests?
    return true unless javascript_test?

    finished_all_ajax_requests?
  end

  def finished_all_ajax_requests?
    Capybara.page.evaluate_script('window.pendingRequests || window.pendingApolloRequests || window.pendingRailsUJSRequests || 0').zero? # rubocop:disable Style/NumericPredicate
  end
end
