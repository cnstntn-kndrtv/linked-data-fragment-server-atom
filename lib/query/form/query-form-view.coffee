{$, View} = require 'atom-space-pen-views'

{ToolbarView} = require '../../utils/toolbar-view'
toolbarConfig = require './query-form-toolbar-config'

module.exports = class QueryFormView extends View
    @content: ->
        @div =>
            @div =>
                @subview 'toolbar', new ToolbarView(toolbarConfig)
            @div class: 'srcollbale endpoints-list', =>
                @ul class: 'list-tree', outlet: 'queryView'
