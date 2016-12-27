{View, $} = require 'atom-space-pen-views'
{TabsView} = require '../utils/tabs-view'
tabsConfig = require './results-tabs-config'
TableView = require './table/table-view'
RawView = require './raw/raw-view'

module.exports = class QueryView extends View
    @content: ->
        @div class: 'atom-panel padded', =>
            @div class: 'inset-panel', =>
                @div class: 'panel-heading', 'Results'
                @div class: 'panel-body padded', =>
                    @subview 'tabsView', new TabsView(tabsConfig)
                    @div outlet:'tabsContent', class: 'padded', =>
                        @subview 'tableView', new TableView()
                        @subview 'rawView', new RawView()

    initialize: ->
        @tabsContent.children().each( -> $(@).hide())
        # TODO state. restore tabs config then swich tabs
        @tabsView.getActive(@switchTabs)

        @tabsView.setHandler(@switchTabs)
        @tableView.createTable(['subject', 'predicate', 'object'])

    addTriple: (triple) ->
        @tableView.addRow([triple.subject, triple.predicate, triple.object])

    setTriples: (triples) ->
        rows = []
        triples.forEach((row) => rows.push([row.subject, row.predicate, row.object]))
        @tableView.setRows(rows)

    clearTriples: () ->
        @tableView.clearTable()

    defineStorage: (link) ->
        @resultStore = link
        # events
        @resultStore.onSetTriples (triples) => @setTriples(triples)
        @resultStore.onAddTriple (triple) => @addTriple(triple)
        @resultStore.onClearTriples () => @clearTriples()

        # @resultStore.onSetTurtles (turtles) => @setTurtles(turtles)
        # @resultStore.onAddTurtle (turtle) => @addTurtle(turtle)
        # @resultStore.onClearTurtles () => @clearTurtles()

    switchTabs: (target) =>
        if target != ''
            @tabsContent.children().each( -> $(@).hide())
            @[target].show()
