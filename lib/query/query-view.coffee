{View, $} = require 'atom-space-pen-views'
{TabsView} = require '../utils/tabs-view'
tabsConfig = require './query-tabs-config'
QuerySparqlView = require './sparql/query-sparql-view'
QueryFormView = require './form/query-form-view'

module.exports = class QueryView extends View
    @content: ->
        @div class: 'atom-panel padded', =>
            @div class: 'inset-panel', =>
                @div class: 'panel-heading', 'Query'
                @div class: 'panel-body padded', =>
                    @subview 'tabsView', new TabsView(tabsConfig)
                @div outlet:'tabsContent', class: 'padded', =>
                    @subview 'querySparqlView', new QuerySparqlView()
                    @subview 'queryFormView', new QueryFormView()

    initialize: ->
        @tabsContent.children().each( -> $(@).hide())
        # TODO state. restore tabs config then swich tabs
        @tabsView.getActive(@switchTabs)
        @tabsView.setHandler(@switchTabs)

    switchTabs: (target) =>
        if target != ''
            @tabsContent.children().each( -> $(@).hide())
            @[target].show()

    setSPARQLQueryText: (str) =>
        @querySparqlView.setQueryText(str)

    onSendButton: (cb) =>
        @querySparqlView.onSendButton(cb)
