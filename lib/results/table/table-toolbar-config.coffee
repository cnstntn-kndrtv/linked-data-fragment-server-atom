module.exports = [
    {
        align: 'left'
        content: [
            {
                visible: true
                style: 'btn-sm btn-primary icon icon-code'
                text: 'links'
                outlet: 'links'
            },
            {
                visible: true
                style: 'btn-sm btn-primary icon icon-ellipsis'
                text: 'filter'
                outlet: 'filterResults'
            },

        ]
    },
    {
        align: 'center'
        content: [
            {
                visible: true
                style: 'btn-sm btn-primary icon icon-file-text'
                text: 'csv'
                outlet: 'csv'
            }
        ]
    },
    {
        align: 'right'
        content: [
            {
                visible: true
                style: 'btn-sm btn-primary icon icon-link-external'
                text: 'window'
                outlet: 'newWindow'
            }
        ]
    }
]
