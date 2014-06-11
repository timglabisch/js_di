# @license    New BSD License, feel free to minify this
# @copyright  Copyright (c) 2013 tim glabisch

class di
  constructor: ->
    @serviceFactories = {}
    @servicesByTags = {}
    @services = {}


  set: (servicename, instance) ->
    @services[servicename] = instance
    @['get' + @_ucfirst(servicename)] = => @get(servicename)()
    @


  get: (serviceName) ->
    return (=> @services[serviceName]) if typeof(@services[serviceName]) != "undefined"

    if typeof @serviceFactories[serviceName] == "function"
      return (=> @services[serviceName] = @serviceFactories[serviceName](@))

    if typeof @serviceFactories[serviceName] == "object"
      throw {msg: 'service ' + serviceName + ' needs a factory configuration.', serviceName: serviceName} if typeof @serviceFactories[serviceName]['factory'] != "function"
      return (=> @serviceFactories[serviceName]['factory'](@)) if !@serviceFactories[serviceName]['shared']
      return (=> @services[serviceName] = @serviceFactories[serviceName](@))

    throw {msg: 'service ' + serviceName + ' doesnt exists.', serviceName: serviceName}


  _ucfirst: (s) ->
    s.charAt(0).toUpperCase() + s.slice(1);


  getByTag: (tag) ->
    return [] if !@servicesByTags[tag]
    @get(t) for t of @servicesByTags[tag]


  auto: (whatever) ->
    throw msg: 'auto requires a function as argument', argument: whatever if typeof whatever != "function"
    argumentMap = whatever.toString().match(/^function\s*[^\(]*\(\s*([^\)]*)\)/)[1].replace(/\ /g, '').split(',')
    argumentMap = argumentMap.splice(0, argumentMap.length)
    argumentInstances = argumentMap.map (v) =>
      argumentCallback = null

      try
        argumentCallback = @get(v)
      catch
        argumentCallback = @get(v.replace('_', ''))

      if typeof argumentCallback != "function"
        throw msg: "cant resolve argument", toresolve: whatever, service: v
      return argumentCallback()

    if whatever.name == "_Class"
      construct = (constructor, args) ->
        f = -> constructor.apply(this, args)
        f.prototype = constructor.prototype;
        new f();
      foo = construct(whatever, argumentInstances);
      return foo

    return whatever.apply({}, argumentInstances)


  configure: (configuration) ->
    if(configuration['factories'])
      for factoryName of configuration['factories']
        @serviceFactories[factoryName] = configuration['factories'][factoryName]

        # support for tags.
        if configuration['factories'][factoryName]['tag']
          tags = configuration['factories'][factoryName]['tag']
          tags = [tags] if typeof tags == "string"
          for tag in tags
            @servicesByTags[tag] = {} if !@servicesByTags[tag]
            @servicesByTags[tag][factoryName] = factoryName

        # support for "nicer" getters.
        @['get' + ((f) => @_ucfirst(f))(factoryName)] = ((f) => => @get(f)())(factoryName)
    @

module.exports = di if typeof module != "undefined"