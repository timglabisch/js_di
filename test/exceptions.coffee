describe 'exceptions', ->

  it 'wrong type', ->
    d = new di
    d.configure
      factories:
        a:
          "foo"

    try
      d.getA()
    catch e
      expect(e.msg).toBe "service a doesnt exists."
      expect(e.serviceName).toBe "a"
      return

    expect(true).toBe false


  it 'missing factory', ->
    d = new di
    d.configure
      factories:
        a:
          shared: false

    try
      d.getA()
    catch e
      expect(e.msg).toBe "service a needs a factory configuration."
      expect(e.serviceName).toBe "a"
      return

    expect(true).toBe false


  it 'unknown service', ->
    d = new di

    try
      d.get('a')()
    catch e
      expect(e.msg).toBe "service a doesnt exists."
      expect(e.serviceName).toBe "a"
      return

    expect(true).toBe false



