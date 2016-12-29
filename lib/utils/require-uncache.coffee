module.exports = (module) ->
    if (require.resolve module)
        delete require.cache[require.resolve module ]
    require module
