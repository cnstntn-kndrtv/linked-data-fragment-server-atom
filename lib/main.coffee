{CompositeDisposable} = require 'atom'
ViewURI = 'atom://linked-data-fragments-atom'
LDFAView = null

module.exports = LinkedDataFragmentsAtom =
    config: require './config.coffee'
    subscriptions: null

    # LDFAViewDeserializer:
    #     name: 'LDFAView'
    #     deserializer: (state) -> createLDFAView(state)

    activate: (state) ->

        atom.workspace.addOpener (filePath) =>
            @createLDFAView(uri: ViewURI) if filePath is ViewURI

        # atom.deserializers.add(@LDFAViewDeserializer)

        # events subscribtion
        @subscriptions = new CompositeDisposable

        # register commands
        @subscriptions.add atom.commands.add 'atom-workspace', 'linked-data-fragments-atom:startServer': => @startServer()
        @subscriptions.add atom.commands.add 'atom-workspace', 'linked-data-fragments-atom:stopServer': => @stopServer()

    deactivate: ->
        console.log 'LDFA deactivated'
        # @subscriptions.dispose()
        # !!!!! destroy LDFAView !!!!!!

    # Returns an object that can be retrieved when package is activated
    serialize: ->
        #

    createLDFAView: (state) ->
        LDFAView ?= require './main-view'
        new LDFAView(state)

    startServer: ->
        atom.notifications.addSuccess('Linked Data Fragments Server was started')
        console.log 'LDFA start server'
        atom.workspace.open(ViewURI, split: atom.config.get('linked-data-fragments-atom.general.split'), searchAllPanes: true)

    stopServer: ->
        atom.notifications.addInfo('Linked Data Fragments Server was stopped')
        console.log 'LDFA stop server'
        @deactivate()

    checkForDependencies: ->
        atom.confirm
            message: 'How you feeling?'
            detailedMessage: 'Be honest.'
            buttons:
                Good: -> window.alert('good to hear')
                Bad: -> window.alert('bummer')

        PackageDependenciesWarning = require './package-dependencies-warn-view'
        {checkForPackageDependencies} = require './package-loader'
        @packageDependenciesWarningModal = null
        notLoadedPackageDependencies = checkForPackageDependencies(['language-rdf', 'language-sparql', 'language-sql', 'language-coffee-script', 'wtf'])
        if notLoadedPackageDependencies.length > 0
            @packageDependenciesWarningView = new PackageDependenciesWarning(notLoadedPackageDependencies)
            @packageDependenciesWarningModal = atom.workspace.addModalPanel(
                item: @packageDependenciesWarningView.getElement(),
                visible: false)
            @packageDependenciesWarningModal.show()

###

@packageDependenciesWarningView.destroy()
@packageDependenciesWarningModal.destroy()

commnds

  switch (data.cmd) {
    case 'start':
      self.postMessage('WORKER STARTED: ' + data.msg);
      break;
    case 'stop':
      self.postMessage('WORKER STOPPED: ' + data.msg + '. (buttons will no longer work)');
      self.close(); // Terminates the worker.
      break;
    default:
      self.postMessage('Unknown command: ' + data.msg);
  };
###
