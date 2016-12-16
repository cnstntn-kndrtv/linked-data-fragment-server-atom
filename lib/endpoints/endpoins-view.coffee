{View, $} = require 'atom-space-pen-views'
{TabsView} = require '../utils/tabs-view'
tabsConfig = require './endpoints-tabs-config'

module.exports = class EndpointsListView extends View
    @content: ->
        @div class: 'atom-panel padded', =>
            @div class: 'inset-panel', =>
                @div class: 'panel-heading', 'Endpoins list'
                @div class: 'panel-body padded', =>
                    @subview 'tabsView', new TabsView(tabsConfig)
                @div outlet:'tabsContent', class: 'padded', =>
                    @div 'hi'

    initialize: ->
        @tabsContent.children().each( -> $(@).hide())
        # TODO state. restore tabs config then swich tabs
        @tabsView.getActive(@switchTabs)

        @tabsView.setHandler(@switchTabs)

    switchTabs: (target) =>
        console.log target
        # if target != ''
        #     @tabsContent.children().each( -> $(@).hide())
        #     @[target].show()
