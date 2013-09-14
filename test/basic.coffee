describe 'basic', ->

  it 'configuration', ->
    d = new di
    d.configure
      factories:
        a:
          -> "return value of a"
        b:
          -> "return value of b"

    expect(d.get('a')()).toBe "return value of a"
    expect(d.get('b')()).toBe "return value of b"


  it 'shared', ->
    d = new di
    i = 0;
    d.configure
      factories:
        a:
          -> ++i

    expect(d.get('a')()).toBe 1
    expect(d.get('a')()).toBe 1
    expect(d.getA()).toBe 1
    expect(d.getA()).toBe 1


  it 'shared = false', ->
    d = new di
    i = 0;
    d.configure
      factories:
        a:
          shared: false
          factory: -> ++i

    expect(d.get('a')()).toBe 1
    expect(d.get('a')()).toBe 2


  it 'lazy', ->
    d = new di
    i = 0;
    d.configure
      factories:
        a:
          -> ++i

    expect(i).toBe 0
    d.get('a')()
    expect(i).toBe 1


  it 'function syntax', ->
    d = new di
    i = 0;
    d.configure
      factories:
        a:
          factory: -> ++i

    expect(d.getA()).toBe 1
    expect(d.getA()).toBe 2

  it 'function syntax lazy', ->
    d = new di
    i = 0;
    d.configure
      factories:
        a:
          -> ++i

    f = d.getA
    expect(i).toBe 0
    f()
    expect(i).toBe 1


  it 'reconfiuration', ->
    d = new di
    d.configure
      factories:
        a:
          -> "a"

    d.configure
      factories:
        a:
          -> "b"

    expect(d.getA()).toBe "b"


  it 'avoid reconfiuration if it has an instance', ->
    d = new di
    d.configure
      factories:
        a:
          -> "a"

    expect(d.getA()).toBe "a"

    d.configure
      factories:
        a:
          -> "b"

    expect(d.getA()).toBe "a"

  it 'test Set', ->
    d = new di
    d.set 'a', 'b'

    expect(d.getA()).toBe "b"
    expect(d.get('a')()).toBe "b"

  it 'test fluent', ->
    d = new di
    expect(d.set('a', 'b')).toBe d
    expect(d.configure({})).toBe d
