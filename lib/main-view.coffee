{View} = require 'atom-space-pen-views'
{CompositeDisposable} = require 'atom'
EndpointsListView = require './endpoints/endpoins-view'
QuerySPARQLView = require './query/query-sparql-view'
ResultsView = require './results/results-view'
ResultStore = require './results/result-store'
# Server = require './server/server.js'

module.exports = class LDFAView extends View
    @content: ->
        @div class: 'ldfa panels base-background-color', tabindex: -1, =>
            @div class: 'flex-container-column height-full', =>
                @div class: 'flex-container-row height-half', =>
                    @div class: 'width-half', =>
                        @subview 'querySPARQLView', new QuerySPARQLView()
                    @div class: 'width-half', =>
                        @subview 'endpointsListView', new EndpointsListView()
                @div class: 'height-half width-full', =>
                    @div class:'flex-container-row width-full height-full', =>
                        @subview 'resultsView', new ResultsView()

    initialize: ({@uri}) ->
        # create result store
        rs = new ResultStore
        resultStore = rs.define('results')

        # views settings
        # query view
        @querySPARQLView.onSendButton () =>
            console.log 'click'
            results = @querySPARQLView.getQueryText()
            resultStore.clearAll()

            for i in [0..100]
                resultStore.addTurtle(i)
                resultStore.addTriple({subject: i, predicate: i, object: i})

            console.log @endpointsListView.getEndpoints()

        # results view
        @resultsView.defineStorage(resultStore)

        # restore state
        # TODO STATE!
        state = {
            triples: [
                {subject: 'state1', predicate: 'state', object: 'state'}
                {subject: 'state2', predicate: 'state', object: 'state'}
                {subject: 'state3', predicate: 'state', object: 'state'}
            ]
            turtles: [
                'state111',
                'state222',
                'state333'
            ]
        }
        @querySPARQLView.setQueryText('later i will get it from state')
        resultStore.setTriples(state.triples)
        resultStore.setTurtles(state.turtles)






    serialize: ->
        deserializer: @constructor.name
        uri: @getUri()

    getUri: -> @uri

    getTitle: -> 'LDFA'

    getIconName: -> 'puzzle'

    destroy: ->
        # @subscriptions.dispose()

        # https://www.npmjs.com/package/event-kit
