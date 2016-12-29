{View, TextEditorView} = require 'atom-space-pen-views'
{ToolbarView} = require '../../utils/toolbar-view'
toolbarConfig = require './raw-toolbar-config'

module.exports = class QueryView extends View
    @content: ->
        @div =>
            @div =>
                @subview 'toolbar', new ToolbarView(toolbarConfig)
            @div class: 'padded results-raw', =>
                @subview 'queryEditor', new TextEditorView()

    initialize: ->
        @setGrammar()

    setText: (str) ->
        @queryEditor.setText(str)

    setGrammar: ->
        # TODO turtle grammar
        @gram = atom.grammars.grammarForScopeName('source.coffee')
        if !@gram
          @loadPackages('language-coffee-script')

        @queryEditor.model.setGrammar(@gram)
