{View} = require 'atom-space-pen-views'

class TableHeaderView extends View
    @content: (cells = [], {sortBy, sortAsc}) ->
        @tr =>
            for item in cells
                @th item, =>
                    # sortBy & sort asc
                    if item is sortBy and sortAsc
                        @div class: 'sort-asc icon-triangle-down active'
                    else
                        @div class: 'sort-asc icon-triangle-down'
                    # sortBy & sort desc
                    if item is sortBy and not sortAsc
                        @div class: 'sort-desc icon-triangle-up active'
                    else
                        @div class: 'sort-desc icon-triangle-up'

class RowView extends View
    @content: (cells = []) ->
        @tr =>
            for item in cells
                @td =>
                    @a item

    initialize: (cells) ->
        @handleEvents()

    destroy: ->
        @detach()

    handleEvents: ->
        @on 'click', 'td', @openLink

    openLink: =>
        console.log 'click on table row'


class TableEmptyView extends View
    @content: (cells = []) ->
        @tr =>
            @td colspan: cells.length, =>
                @span 'No results yet'

module.exports = {TableHeaderView, RowView, TableEmptyView}
