class FakeModel < Struct.new(:title)
  def update_attribute(name, value)
    self[name] = value
  end
end
