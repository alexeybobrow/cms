class UniquenessValidator < ActiveRecord::Validations::UniquenessValidator
  def initialize(params)
    super
    @klass = params[:class].model_class
  end

  def validate_each(record, attribute, value)
    record_org, attribute_org = record, attribute

    attribute = options[:attribute].to_sym if options[:attribute]
    record = record_org.model
    record.assign_attributes(attribute => value)

    super

    if record.errors.any?
      record_org.errors.add(attribute_org, :taken,
        options.except(:case_sensitive, :scope).merge(value: value))
    end
  end
end
