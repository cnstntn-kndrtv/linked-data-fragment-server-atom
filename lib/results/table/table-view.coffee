{CompositeDisposable} = require 'atom'
{View, $} = require 'atom-space-pen-views'
{ToolbarView} = require '../../utils/toolbar-view'
toolbarConfig = require './table-toolbar-config'
{TableHeaderView, RowView, TableEmptyView} = require './table-item-view'

module.exports = class TableView extends View
    @content: ->
        @div =>
            @div =>
                @subview 'toolbar', new ToolbarView(toolbarConfig)
            @div class: 'results-table', =>
                @table outlet: 'table', =>
                    @thead outlet: 'tableHead'
                    @tbody outlet: 'tableBody', class: 'scrollable'

    initialize: () ->
        @subscriptions = new CompositeDisposable
        @handleEvents()
        @toolbarEvents()
        @sortBy = 'all'
        @sortAsc = true


    destroy: ->
        @subscriptions.dispose()
        @empty()

    handleEvents: ->
        #@subscriptions.add on sort
        #@subscriptions.add on filter
        @on 'click', 'th', @tableHeaderClicked

    setTableHeader: (columns) ->
        @tableHead.append new TableHeaderView(columns, {@sortBy, @sortAsc})

    tableHeaderClicked: (e) =>
        item = e.target.innerText
        sortAsc = if @sortBy is item then !@sortAsc else true
        @sortBy = item
        @sortAsc = sortAsc
        @sort(@sortBy, @sortAsc)

    addRow: (cells) ->
        @tableBody.append new RowView(cells)

    setNoResults: (columns) =>
        @tableBody.empty()
        @tableBody.append new TableEmptyView(columns)

    clearTable: =>
        @tableBody.empty()

    createTable: (columns) =>
        @tableHeader = columns
        @setTableHeader(@tableHeader)
        @setNoResults(@tableHeader)

    sort: (sortBy, sortAsc) ->
        console.log 'sort:', sortBy, sortAsc
        # @collection.sortTodos(sortBy: sortBy, sortAsc: sortAsc)

    toolbarEvents: ->
        @toolbar.links.click => @showLinks()
        @toolbar.filterResults.click => @showFilter()
        @toolbar.csv.click => @csvExport()
        @toolbar.newWindow.click => @changeWindow()

    showLinks: () ->
        @toolbar.links.toggleClass('selected')
        console.log 'links'

    showFilter: () ->
         console.log 'filter'

    csvExport: () ->
        console.log 'csv'

    changeWindow: () ->
        console.log 'window'
