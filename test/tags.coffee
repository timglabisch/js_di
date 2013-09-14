describe 'tags', ->

  it 'basic', ->
    d = new di
    d.configure
      factories:
        a:
          tag: "Foo"
          factory: -> "a"
        b:
          tag: "Foo"
          factory: -> "b"

    tags = d.getByTag('Foo')
    expect(tags[0]()).toBe "a"
    expect(tags[1]()).toBe "b"


  it 'arrays', ->
    d = new di
    d.configure
      factories:
        a:
          tag: ["Foo", "Bar"]
          factory: -> "a"
        b:
          tag: "Foo"
          factory: -> "b"
        c:
          tag: ["Foo", "Bar"]
          factory: -> "c"

    tags = d.getByTag('Bar')
    expect(tags[0]()).toBe "a"
    expect(tags[1]()).toBe "c"
    expect(tags.length).toBe 2


  it 'unknown tag', ->
    d = new di

    tags = d.getByTag('Bar')
    expect(typeof tags).toBe "object"
    expect(tags.length).toBe 0


