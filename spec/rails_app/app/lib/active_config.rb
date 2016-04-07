module ActiveConfig
  def settings_for(name)
    self.where(name: name).first || self.new(value: Settings[name].to_hash)
  end

  def [](name)
    self.settings_for(name).value
  end

  def []=(name, value)
    self.where(name: name).first_or_create.update_attribute(:value, value)
  end
end
