module.exports = {
    general:
        title: 'General'
        type: 'object'
        collapsed: false
        order: -1
        description: 'General options for package'
        properties:
            split:
                title: 'Split settings'
                description: 'Open in "left" or "right" pane'
                type: 'string'
                default: 'left'
                enum: ['left', 'right']
}
