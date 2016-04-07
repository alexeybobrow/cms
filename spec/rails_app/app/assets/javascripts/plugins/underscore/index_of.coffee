indexOfValue = _.indexOf

_.mixin({
  indexOf: (array, test) ->
    return indexOfValue(array, test) if !_.isFunction(test)

    for x in [0...array.length]
      return x if test(array[x])

    -1
})
