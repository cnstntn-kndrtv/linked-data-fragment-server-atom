{View, $} = require 'atom-space-pen-views'
{TabsView} = require '../utils/tabs-view'
tabsConfig = require './endpoints-tabs-config'
LocalEndpointsView = require './local/local-endpoints-view'
GlobalEndpointsView = require './global/global-endpoints-view'

module.exports = class EndpointsListView extends View
    @content: ->
        @div class: 'atom-panel padded', =>
            @div class: 'inset-panel', =>
                @div class: 'panel-heading', 'Endpoins list'
                @div class: 'panel-body padded', =>
                    @subview 'tabsView', new TabsView(tabsConfig)
                @div outlet:'tabsContent', class: 'padded', =>
                    @subview 'localEndpointsView', new LocalEndpointsView()
                    @subview 'globalEndpointsView', new GlobalEndpointsView()

    initialize: ->
        @tabsContent.children().each( -> $(@).hide())
        # TODO state. restore tabs config then swich tabs
        @tabsView.getActive(@switchTabs)

        @tabsView.setHandler(@switchTabs)

    switchTabs: (target) =>
        if target != ''
            @tabsContent.children().each( -> $(@).hide())
            @[target].show()
