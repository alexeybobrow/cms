$ ->
  incAttrIndex = (og_row) ->
    ['id', 'name'].forEach (attr) ->
      $('input', og_row).each (_, el) ->
        attr_value = $(el).attr(attr)
        if attr_value
          attr_value = attr_value.replace /\d/, (a) -> parseInt(a) + 1
          $(el).attr(attr, attr_value)


  $('.add-og-tag').on 'click', (e) ->
    e.preventDefault()
    og_fields = $('.open-graph-fields')
    og_row = $('tr:last', og_fields).clone()
    incAttrIndex(og_row)
    $('input', og_row).val('')
    og_fields.append(og_row)
