{CompositeDisposable} = require 'atom'
{View, $} = require 'atom-space-pen-views'
dt = require ('datatables.net')
dt(window, $)

{ToolbarView} = require '../../utils/toolbar-view'
toolbarConfig = require './table-toolbar-config'

module.exports = class TableView extends View
    @content: ->
        @div =>
            @div =>
                @subview 'toolbar', new ToolbarView(toolbarConfig)
            @div class: 'results-table native-key-bindings', =>
                @table outlet: 'tableContainer'

    initialize: () ->
        @toolbarEvents()

    destroy: ->
        @empty()

    addRow: (row) ->
        @table.row.add(row).draw(false)

    setRows: (rows) ->
        @table.rows.add(rows).draw(false)

    clearTable: =>
        @table.clear().draw()

    createTable: (col) =>
        columns = []
        col.forEach((c) => columns.push({title: c}))
        @table = @tableContainer.DataTable(({
            "deferRenderer": true,
            columns: columns
            }))



    toolbarEvents: ->
        @toolbar.links.click => @showLinks()
        @toolbar.filterResults.click => @showFilter()
        @toolbar.csv.click => @csvExport()
        @toolbar.newWindow.click => @changeWindow()

    showLinks: () ->
        @toolbar.links.toggleClass 'selected'
        console.log 'links'

    showFilter: () ->
        console.log 'filter'

    csvExport: () ->
        console.log 'csv'

    changeWindow: () ->
        console.log 'window'
