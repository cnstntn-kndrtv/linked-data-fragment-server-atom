{$, View} = require 'atom-space-pen-views'
fs = require 'fs-plus'
path = require 'path'
requireUncache = require '../../utils/require-uncache'

{ToolbarView} = require '../../utils/toolbar-view'
toolbarConfig = require './global-endpoints-toolbar-config'

module.exports = class LocalEndpointsView extends View
    @content: ->
        @div =>
            @div =>
                @subview 'toolbar', new ToolbarView(toolbarConfig)
            @div class: 'srcollbale endpoints-list', outlet: 'endpointsListView'

    initialize: (state) ->
        @refresh()
        @toolbar.reload.click => @refresh()
        #TODO state
        @isShowLinks = false
        @toolbar.links.click => @toggleLinks(@isShowLinks)

    refresh: () ->
        @selectedEndpoints = {}
        @endpointsListView.empty()
        endpointsList = requireUncache "#{__dirname}/global-endpoints-list.json"
        @endpointsListView.append @createEndpointsList(endpointsList)

    createEndpointsList: (list) =>

        createList = (type, listObj) =>
            list[type].forEach (el) =>
                checkbox = $("<input class='input-checkbox' type='checkbox'>")
                    .attr('data-target', "#{el.link}")
                    .change (e) =>
                        @selectEndpoint e.target.dataset.target, type
                endpointTitle = $("<div class='endpoint-title'>#{el.title}</div>")
                endpointTitle.prepend checkbox
                endpointLink = $("<div class='endpoint-link'><a href='#{el.link}'>#{el.link}</a></div>")
                content = $('<span>')
                content
                    .append endpointTitle
                    .append endpointLink
                listObj.append(
                    $("<li class='list-item'>")
                        .attr 'id', "global-endpoint-#{el.link}"
                        .append content
                        .click (e) =>
                            if (e.target.localName != 'input')
                                $(e.currentTarget).find('input:checkbox').trigger('click')
                )

        createParentList = (title) =>
            template = $ "<li class='list-nested-item'>
                                <div class='list-item'>
                                    <span class='endpoint-dir icon icon-repo'>#{title}</span>
                                </div>
                            </li>"
            template.click (e) =>
                e.stopPropagation()
                if e.target.localName == 'li'
                    $(e.target).toggleClass 'collapsed'
                else if e.target.localName == 'div' and e.target.classList[0] == 'list-item'
                    $(e.target.parentNode).toggleClass 'collapsed'
                else if e.target.localName == 'span' and e.target.classList[0] == 'endpoint-dir'
                    $(e.target.parentNode.parentNode).toggleClass 'collapsed'

            template

        ldfList = $("<ul class='list-tree has-collapsable-children'>")
        ldfListContent = $(createParentList 'Linked Data Fragments')
        ldfEndpoints = $("<ul class='list-tree'>")
        createList('linked-data-fragments', ldfEndpoints)
        ldfListContent.append ldfEndpoints
        ldfList.append ldfListContent

        sparqlList = $("<ul class='list-tree has-collapsable-children'>")
        sparqlListContent = $(createParentList 'SPARQL Endpoints')
        sparqlEndpoints = $("<ul class='list-tree'>")
        createList('sparql', sparqlEndpoints)
        sparqlListContent.append sparqlEndpoints
        sparqlList.append sparqlListContent

        @endpointsListView
            .append ldfList
            .append sparqlList

        @isShowLinks = !@isShowLinks
        @toggleLinks(@isShowLinks)


    selectEndpoint: (id, type) ->
        if (!@selectedEndpoints[type])
            @selectedEndpoints[type] = []
        @selectedEndpoints[type].push id
        $(document.getElementById "global-endpoint-#{id}" ).toggleClass 'selected-endpoint'

    getEndpoints: () ->
        @selectedEndpoints

    toggleLinks: (isVisible) ->
        if (isVisible)
            @toolbar.links.addClass 'selected'
            @endpointsListView.find('.endpoint-link').show()
        else
            @toolbar.links.removeClass 'selected'
            @endpointsListView.find('.endpoint-link').hide()
        @isShowLinks = !@isShowLinks
        false
