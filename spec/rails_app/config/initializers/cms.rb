Cms.setup do |config|
  config.host = "lvh.me:3000"
  config.failure_app = Cms::Public::PagesController.action(:show)
end
