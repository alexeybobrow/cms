_.mixin(
  inGroupsOf: (array, number, fillWith) ->
    fillWith = fillWith || null
    index = -number
    slices = []

    return array if number < 1

    while ((index += number) < array.length)
      s = array.slice(index, index + number)
      while(s.length < number)
        s.push(fillWith)
      slices.push(s)

    slices
)
