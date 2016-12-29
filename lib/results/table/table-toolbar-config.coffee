module.exports = [
    {
        align: 'left'
        content: [
            {
                style: 'btn-sm icon icon-code'
                text: 'links'
                outlet: 'links'
            },
            {
                style: 'btn-sm icon icon-ellipsis'
                text: 'filter'
                outlet: 'filterResults'
            },

        ]
    },
    {
        align: 'center'
        content: [
            {
                style: 'btn-sm icon icon-file-text'
                text: 'csv'
                outlet: 'csv'
            }
        ]
    },
    {
        align: 'right'
        content: [
            {
                style: 'btn-sm icon icon-link-external'
                text: 'window'
                outlet: 'newWindow'
            }
        ]
    }
]
