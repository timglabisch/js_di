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