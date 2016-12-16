{Emitter} = require 'atom'

module.exports = class EventBasedData
    constructor: ->
        @emitter = new Emitter

    destroy: ->
        @emitter.dispose

    define: (name) ->
        @[name] = {
            triples: []
            turtles: []

            # Triples
            clearTriples: =>
                @[name].triples = []
                @emitter.emit "clear triples #{name}"

            setTriples: (val) =>
                @[name].triples = []
                @[name].triples.push(val)
                @emitter.emit "set triples #{name}", val

            getTriples: () =>
                @[name].triples

            addTriple: (val) =>
                @[name].triples.push(val)
                @emitter.emit "add triple #{name}", val

            onClearTriples: (cb) =>
                @emitter.on "clear triples #{name}", cb

            onSetTriples: (cb) =>
                @emitter.on "set triples #{name}", cb

            onAddTriple: (cb) =>
                @emitter.on "add triple #{name}", cb

            # Turtles
            clearTurtles: =>
                @[name].turtles = []
                @emitter.emit "clear turtles #{name}"

            setTurtles: (val) =>
                @[name].turtles = []
                @[name].turtles.push(val)
                @emitter.emit "set turtles #{name}", val

            getTurtles: () =>
                @[name].turtles

            addTurtle: (val) =>
                @[name].turtles.push(val)
                @emitter.emit "add turtle #{name}", val

            onClearTurtles: (cb) =>
                @emitter.on "clear turtles #{name}", cb

            onSetTurtles: (cb) =>
                @emitter.on "set turtles #{name}", cb

            onAddTurtle: (cb) =>
                @emitter.on "add turtle #{name}", cb

            # other
            clearAll: ->
                @clearTriples()
                @clearTurtles()
        }
