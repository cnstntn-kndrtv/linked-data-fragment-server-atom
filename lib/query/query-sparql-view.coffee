{View, TextEditorView} = require 'atom-space-pen-views'

module.exports = class QueryView extends View
    @content: ->
        @div class: 'atom-panel padded', =>
            @div class: 'inset-panel', =>
                @div class: 'panel-heading', 'Query'
                @div class: 'panel-body padded height-full query', =>
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
