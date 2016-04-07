module Tags::PersonInfo
  def person
    @employee ||= Employee.where(name: @markup).first
  end

  def person_image
    person && person.avatar.present? ? person.avatar.url : @attributes['src']
  end

  def person_name
    person ? person.name : @attributes['name']
  end

  def person_position
    person ? person.position : @attributes['position']
  end
end
