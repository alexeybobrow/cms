module Integration
  module FixtureHelpers
    FILE_PATH = File.join(Rails.root.parent, 'fixtures/files/')
    def fixture_file_path(*args)
      return FILE_PATH + args.first if args.size == 1
      return args.map{ |i| FILE_PATH + i } if args.size > 1
      ''
    end
  end
end
