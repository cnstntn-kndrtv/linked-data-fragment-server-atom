{Emitter} = require 'atom'

module.exports = class EventBasedDataObject
    constructor: ->
        @emitter = new Emitter

    set: (data) ->
        @data = data
        @emitter.emit 'update'

    get: -> @data

    onUpdate: (callback) ->
        @emitter.on 'update', callback
