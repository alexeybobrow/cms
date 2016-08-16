module Cms
  module SidekiqMiddleware
    class UniqJobs
      def call(worker, job, queue)
        if already_enqueued?(job, queue)
          Sidekiq.logger.info "Already enqueued job with args #{job['args']}"
        else
          yield
        end
      end

      private

      def already_enqueued?(job, queue)
        enqueued = Sidekiq::Queue.new(queue)
        enqueued.any? { |j| j['args'] == job['args'] }
      end
    end
  end
end
