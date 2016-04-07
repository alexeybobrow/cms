module Integration
  module AttachmentHelpers
    def delete_image(image_name)
      page.find(:xpath, "//div[@class='file-name']/a[contains(text(),'#{image_name}')]/../../div[@class='description']//*[@value='Delete' or contains(text(), 'Delete')]").click
    end

    def restore_image(image_name)
      page.find(:xpath, "//div[@class='file-name']/a[contains(text(),'#{image_name}')]/../../div[@class='description']/a[contains(text(),'Restore')]").click
    end

    def assert_image_deleted(image_name)
      page.find(:xpath, "//div[@class='file-name']/a[contains(text(),'#{image_name}')]/../../div[@class='description']/a[contains(text(),'Restore')]")
    end

    def assert_image_restored(image_name)
      page.find(:xpath, "//div[@class='file-name']/a[contains(text(),'#{image_name}')]/../../div[@class='description']/a[contains(text(),'Delete')]")
    end
  end
end
