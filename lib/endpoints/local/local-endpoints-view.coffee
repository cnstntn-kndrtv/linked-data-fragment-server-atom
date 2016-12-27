path = require 'path'
{shell} = require 'electron'

_ = require 'underscore-plus'
{BufferedProcess, CompositeDisposable} = require 'atom'
# {repoForPath, getStyleObject, getFullExtension} = require "./helpers"
{$, View} = require 'atom-space-pen-views'
fs = require 'fs-plus'

Directory = require './directory'
DirectoryView = require './directory-view'
FileView = require './file-view'

# TODO triples?
LocalStorage = window.localStorage

module.exports = class LocalEndpointsView extends View
    panel: null

    @content: ->
        @div =>
            @div 'tree-view-scroller order--center', outlet: 'scroller', =>
                @ol class: 'list-tree', tabindex: -1, outlet: 'list'
            @div class: 'tree-view-resize-handle', outlet: 'resizeHandle'

    initialize: (state) ->
        rootPath = atom.project.getPaths()
        console.log(path)
        console.log rootPath[0]
        fs.traverseTreeSync rootPath, (file) -> @onFile(file), (dir) -> onDirectory(dir)

    onFile: (file) ->
        console.log 'file', file

    onDirectory: (dir) ->
        console.log 'dir', dir
