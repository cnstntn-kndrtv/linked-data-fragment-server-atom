{$, View} = require 'atom-space-pen-views'

module.exports = class GlobalEndpointsView extends View
    @content: ->
        @div class: 'tree-view-resizer tool-panel', =>
            @div 'global'

    initialize: ->
        # console.log @queryEditor
