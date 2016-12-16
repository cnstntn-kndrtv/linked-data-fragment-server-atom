{View, TextEditorView} = require 'atom-space-pen-views'
{ToolbarView} = require '../../utils/toolbar-view'
toolbarConfig = require './raw-toolbar-config'

module.exports = class QueryView extends View
    @content: ->
        @div =>
            @div =>
                @subview 'toolbar', new ToolbarView(toolbarConfig)
            @div class: 'padded', =>
                @subview 'queryEditor', new TextEditorView()

    initialize: ->
        # console.log @queryEditor
        @queryEditor.element.style.minHeight = '300px'
        @queryEditor.element.style.height = '100%'
        @queryEditor.element.style.width = '100%'
        @setGrammar()

    setText: (str) ->
        @queryEditor.setText(str)

    setGrammar: ->
        # TODO turtle grammar
        @gram = atom.grammars.grammarForScopeName('source.coffee')
        if !@gram
          @loadPackages('language-coffee-script')

        @queryEditor.model.setGrammar(@gram)
