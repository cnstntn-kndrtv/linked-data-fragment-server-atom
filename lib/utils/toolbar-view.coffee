{View} = require 'atom-space-pen-views'

class ToolbarView extends View
    @content: (sections = []) ->
        @div class: 'flex-container-row', =>
            for section in sections
                switch section.align
                    when 'left' then align = 'align-left'
                    when "center" then align = 'align-center'
                    when "right" then align = 'align-right'
                    else align = ''
                @div class: "block flex-container-content #{align}", =>
                    for b in section.content
                        @button outlet: b.outlet, class: "btn #{b.style} inline-block", b.text

    setHandlers: (outlet, cb) ->
        @[outlet].click => cb


module.exports = {ToolbarView}
