{View, TextEditorView} = require 'atom-space-pen-views'

module.exports = class QueryView extends View
    @content: ->
        @div class: 'atom-panel padded', =>
            @div class: 'inset-panel', =>
                @div class: 'panel-heading', 'Query'
                @div class: 'panel-body padded', =>
                    @subview 'queryEditor', new TextEditorView(placeHolderText: 'type your SPARQL query here')
                    @div class:'block padded', =>
                        @button outlet: 'send', class:'btn btn-primary icon icon-playback-play', 'Execute'

    initialize: ->
        # console.log @queryEditor
        @queryEditor.element.style.height = '300px'
        @setGrammar()
        @focusQueryEditor()
        # @queryEditor.setText(global.myVar)

        @send.on 'click', => @sendQuery()

        global.LDFAData.onUpdate(@fn1)
        global.LDFAData.onUpdate(@fn2)
        console.log '2'
        global.LDFAData.set('q')

    fn1: () ->
        console.log 'Q - ', global.LDFAData.get()

    fn2: () ->
        console.log 'Q2 - ', global.LDFAData.get()

    getSubjectValue: -> @subject.context.value

    getPredicateValue: -> @predicate.context.value

    getObjectValue: -> @object.context.value

    createQueryString: ->
        'txt'

    sendQuery: ->
        console.log @createQueryString()
        console.log 'te text', @queryEditor.getText()

    setGrammar: ->
        @gram = atom.grammars.grammarForScopeName('source.coffee')
        if !@gram
          @loadPackages('language-coffee-script')

        @queryEditor.model.setGrammar(@gram)

    focusQueryEditor: ->
        @queryEditor.focus()

    # тестовое поле с подсветкой ситаксиса спаркл передать в клиент
