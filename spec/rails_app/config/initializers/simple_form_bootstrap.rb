# Use this setup block to configure all options available in SimpleForm.
SimpleForm.setup do |config|
  config.wrappers :bootstrap, tag: 'div', class: 'form-group', error_class: 'has-error error' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly
    b.use :label, class: 'col-sm-2 control-label'

    b.wrapper tag: 'div', class: 'controls col-sm-5' do |ba|
      ba.use :input, class: 'form-control'
      ba.use :error, wrap_with: { tag: 'span', class: 'help-inline' }
      ba.use :hint,  wrap_with: { tag: 'span', class: 'help-inline' }
    end
  end

  config.wrappers :simple_bs, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.use :input, class: 'form-control'
  end

  config.wrappers :simple_bs_checkbox, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.use :input
  end

  # Wrappers for forms and inputs using the Twitter Bootstrap toolkit.
  # Check the Bootstrap docs (http://twitter.github.com/bootstrap)
  # to learn about the different styles for forms and inputs,
  # buttons and other elements.
  config.default_wrapper = :bootstrap
end
