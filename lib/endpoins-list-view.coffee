{View} = require 'atom-space-pen-views'

module.exports = class EndpointsListView extends View
    @content: ->
        @div class: 'atom-panel padded', =>
            @div class: 'inset-panel', =>
                @div class: 'panel-heading', 'Endpoins list'
                @div class: 'panel-body padded', =>
                    @span class: '', 'text'

    initialize: ->

        ###
https://www.npmjs.com/package/pathwatcher
###
