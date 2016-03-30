module Cms
  module Liquid
    class MultipleFileSystem
      attr_accessor :roots, :lookups

      def initialize(roots, pattern = "_%s.liquid".freeze)
        @roots = roots
        @lookups = self.roots.map { |r| ::Liquid::LocalFileSystem.new(r) }
        @pattern = pattern
      end

      def read_template_file(template_path, _)
        lookups.each do |lookup|
          full_path = lookup.full_path(template_path)
          return File.read(full_path) if File.exists?(full_path)
        end
        raise ::Liquid::FileSystemError, "No such template '#{template_path}'"
      end
    end
  end
end
