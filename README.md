````

     #    "
  mmm#  mmm
 #" "#    #
 #   #    #
 "#m##  mm#mm
````

- - - - -- - - - - - - - - - - - - - - - - - -

di is a simple and well tested javascript / coffeescript dependency injection container.
it supports shared / non shared services and tags.
it's written in a few lines of coffeescript, but feel free to copy the javascript source as well.

# install
just grab the di.coffee or .js.

# licence
New BSD License

# examples
## default configuration

````coffeescript
# some example classes
class a
  hello: -> "hello from a"

class b
  constructor: (@a) ->
  hello: -> "hello from b and " + @a().hello()

class demoSetterInjection
  setA: (@a) -> @
  hello: -> @a().hello()

i = 0

# create and configure the di
d = new di
d.configure
  factories:
    a: -> new a

    # constructor injection
    b: (di) -> new b di.getA

    # setter injection
    demoSetterInjection: (di) -> (new demoSetterInjection).setA di.getA

    notShared:
      shared: false
      factory: -> i++

    shared: -> i++

expect(d.getB().hello()).toBe "hello from b and hello from a"
expect(d.getDemoSetterInjection().hello()).toBe "hello from a"

# services are shared by default
expect(i).toBe(0)
d.getShared()
d.getShared()
d.getShared()
expect(i).toBe(1)

# there is also support for non-shared services
d.getNotShared()
d.getNotShared()
expect(i).toBe(3)


# HINTS
# getA returns a function that returns the service for laziness.
# getA is the same like get('a')
# getA() is the same like get('a')()
````

## tags
````coffeescript
d = new di
d.configure
  factories:
    pluginA:
      tag: "Plugin"
      factory: -> "a"
    pluginB:
      tag: ["Plugin", "you can have more than one tag :)"]
      factory: -> "b"
    somethingElse:
      -> "c"

# now get all "Plugins" :)
tags = d.getByTag('Plugin')
expect(tags[0]()).toBe "a"
expect(tags[1]()).toBe "b"
````