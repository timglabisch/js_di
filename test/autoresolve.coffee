describe 'basic', ->

  it 'auto function', ->
    c = (a, b) -> a + ' and ' + b

    d = new di
    d.configure
      factories:
        a: -> "return value of a"
        b: -> "return value of b"
        c: -> d.auto(c)

    expect(d.get('c')()).toBe "return value of a and return value of b"


  it 'auto class', ->
    c = class
      constructor: (@a, @b) ->
      someFunction: -> @a + ' and ' + @b

    d = new di
    d.configure
      factories:
        a: -> "return value of a"
        b: -> "return value of b"
        c: -> d.auto(c)

    expect(d.get('c')().someFunction()).toBe "return value of a and return value of b"


