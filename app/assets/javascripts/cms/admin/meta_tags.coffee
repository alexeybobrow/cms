$ ->
  updateIndex = (meta_row, index) ->
    ['id', 'name'].forEach (attr) ->
      $('input', meta_row).each (_, el) ->
        attr_value = $(el).attr(attr)
        if attr_value
          attr_value = attr_value.replace /\d/, (a) -> index
          $(el).attr(attr, attr_value)

  currentMaxIndex = ->
    Math.max.apply(Math, $('[data-meta-field-from]').map((i, el) -> parseInt(el.dataset.metaFieldIndex)))

  $('[data-meta-field-from]').on 'click', (e) ->
    e.preventDefault()
    meta_template = $('[data-meta-field-template=\''+this.dataset.metaFieldFrom+'\']').last()
    meta_row = meta_template.clone()
    updateIndex(meta_row, this.dataset.metaFieldIndex)
    $('input', meta_row).val('')
    $(this).attr('data-meta-field-index', currentMaxIndex()+1)
    meta_template.after(meta_row)
