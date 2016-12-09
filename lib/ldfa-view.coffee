{View} = require 'atom-space-pen-views'
EndpointsListView = require './endpoins-list-view'
QuerySPARQLView = require './query-sparql-view'

module.exports = class LDFAView extends View
    @content: ->
        @div class: 'ldfa panels base-background-color', tabindex: -1, =>
            @div =>
                @div class: 'panels', =>
                    @subview 'endpointsListPanel', new EndpointsListView()
                @div class: 'panels', =>
                    @subview 'querySPARQLViewPanel', new QuerySPARQLView()

    initialize: ({@uri}) ->
        EventBasedDataObject = require './event-based-data-object'
        global.LDFAData = new EventBasedDataObject

    serialize: ->
        deserializer: @constructor.name
        uri: @getUri()

    getUri: -> @uri

    getTitle: -> 'LDFA'

    getIconName: -> 'puzzle'

    destroy: ->
        #
