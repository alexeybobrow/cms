$ ->
  $(document).on "click", ".image-attachment img", ->
    image_url = $(this).attr("data-url")
    fileNameIndex = image_url.lastIndexOf("/") + 1
    filename = image_url.substr(fileNameIndex)
    if $("#content_markup_language").val() is "markdown"
      $("[class*=content-body]").insertAtCaret "\n![" + filename + "](" + image_url + ")"
    else
      $("[class*=content-body]").insertAtCaret "\n<img src='" + image_url + "' alt='" + filename + "'>"
