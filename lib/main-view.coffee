{View} = require 'atom-space-pen-views'
{CompositeDisposable} = require 'atom'
EndpointsListView = require './endpoints/endpoins-view'
QueryView = require './query/query-view'
ResultsView = require './results/results-view'
ResultStore = require './results/result-store'
# Server = require './server/server.js'
{Store} = require './parseAndStore/store.js'

module.exports = class LDFAView extends View
    @content: ->
        @div class: 'ldfa panels base-background-color', tabindex: -1, =>
            @div class: 'flex-container-column height-full', =>
                @div class: 'flex-container-row height-half', =>
                    @div class: 'width-half', =>
                        @subview 'queryView', new QueryView()
                    @div class: 'width-half', =>
                        @subview 'endpointsListView', new EndpointsListView()
                @div class: 'width-full', =>
                    @div class:'flex-container-row width-full height-full', =>
                        @subview 'resultsView', new ResultsView()

    initialize: ({@uri}) ->
        # create result store
        rs = new ResultStore
        resultStore = rs.define('results')

        storeConfig = {
            dbName: "KloudOne",
            storeName: "resultStore",
            storeSchema: ['subject', 'predicate', 'object'],
            inMemoryLimit: 5,
        }

        store = new Store(storeConfig)

        # views settings
        # query view
        @queryView.querySparqlView.onSendButton () =>
            console.log 'click'

            new Promise((resolve, reject) => 
                for i in [0...20]
                    time = new Date()
                    time = "#{time.getHours()}:#{time.getMinutes()}:#{time.getSeconds()}"
                    store.put({subject: i, predicate: i, object: i})
                resolve('ok');
            )
                .then((msg) =>
                    console.log(msg);
                    store.count()
                )


            # results = @queryView.getQueryText()
            # resultStore.clearAll()
            #
            # for i in [0..100]
            #     resultStore.addTurtle(i)
            #     resultStore.addTriple({subject: i, predicate: i, object: i})
            #
            # console.log @endpointsListView.getEndpoints()

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
        @queryView.setSPARQLQueryText('later i will get it from state')
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
