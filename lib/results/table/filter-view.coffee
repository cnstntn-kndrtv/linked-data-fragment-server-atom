{View} = require 'atom-space-pen-views'

class ToolbarView extends View
    @content: (sections = []) ->
        @div class: 'flex-container-row', =>
            for section in sections
                console.log 'sect', section
                @div class: "block", =>
                    for b in section.content
                        @button class: "btn #{b.type} icon #{b.icon} inline-block", b.text

module.exports = {ToolbarView}
