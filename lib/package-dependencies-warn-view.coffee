module.exports = class PackageDependenciesWarning
    constructor: (packagesList) ->
        # Create root element
        @packagesList = packagesList
        @element = document.createElement('div')

        # Create message element
        message = document.createElement('div')
        message.textContent = @packagesList
        message.classList.add('message')
        @element.appendChild(message)

    # Returns an object that can be retrieved when package is activated
    serialize: ->

    # Tear down any state and detach
    destroy: ->
        @element.remove()

    getElement: ->
        @element

    setPackages: (packages) ->
        @packagesList = packages
