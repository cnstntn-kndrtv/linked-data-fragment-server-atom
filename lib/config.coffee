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
    results:
        title: 'Results view'
        type: 'object'
        collapsed: false
        order: -1
        description: 'Result view settings'
        properties:
            table:
                title: 'Result table'
                type: 'object'
                collapsed: false
                order: -1
                description: 'Results table settings'
                properties:
                    sortBy:
                        title: 'Sort by:'
                        type: 'string'
                        default: 'all'
                        enum: ['all', 'subject', 'predicate', 'object']
                    sortAsc:
                        title: 'Sort ascending'
                        description: 'descendic if not checked'
                        type: 'boolean'
                        default: true
}
