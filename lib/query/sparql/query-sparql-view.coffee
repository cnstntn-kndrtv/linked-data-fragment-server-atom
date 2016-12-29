{View, TextEditorView} = require 'atom-space-pen-views'
{ToolbarView} = require '../../utils/toolbar-view'
toolbarConfig = require './query-sparql-toolbar-config'

module.exports = class QuerySparqlView extends View
    @content: ->
        @div =>
            @div =>
                @subview 'toolbar', new ToolbarView(toolbarConfig)
            @div class: 'sparql-query', =>
                @subview 'queryEditor', new TextEditorView(placeHolderText: 'type your SPARQL query here')
                @div class:'block padded', =>
                    @button outlet: 'send', class:'btn btn-primary icon icon-playback-play', 'Execute'

    initialize: ->
        @setGrammar()
        @focusQueryEditor()

    setQueryText: (str) ->
        @queryEditor.setText(str)

    getQueryText: () ->
        @queryEditor.getText()

    onSendButton: (cb) ->
        @send.on 'click', cb

    setGrammar: ->
        # TODO sparql grammar
        @gram = atom.grammars.grammarForScopeName('source.coffee')
        if !@gram
          @loadPackages('language-coffee-script')

        @queryEditor.model.setGrammar(@gram)

    focusQueryEditor: ->
        @queryEditor.focus()
