{View, $} = require 'atom-space-pen-views'

class TabsView extends View
    @content: (tabs = []) ->
        @div =>
            @div outlet: 'tabBar', class: 'btn-group flex-container-row width-full', =>
                for b in tabs
                    if b.active then active = 'selected' else active = ''
                    if b.icon? and b.icon != '' then icon = "icon #{b.icon}" else icon = ""
                    @button class: "btn width-full #{icon} #{active}", 'data-target': b.target, b.text

    setHandler: (cb) ->
        tabBar = @tabBar
        tabBar.children().each ->
            $(@).click (data) =>
                tabBar.children().each( -> $(@).removeClass('selected'))
                $(@).addClass('selected')
                cb $(@).attr('data-target')

    getActive: (cb) ->
        @tabBar.children().each ->
            if $(@).hasClass('selected') then cb($(@).attr('data-target'))

module.exports = {TabsView}
