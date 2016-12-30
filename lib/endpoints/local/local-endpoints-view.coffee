{$, View} = require 'atom-space-pen-views'
fs = require 'fs-plus'
path = require 'path'

requireUncache = require '../../utils/require-uncache'

{ToolbarView} = require '../../utils/toolbar-view'
toolbarConfig = require './local-endpoints-toolbar-config'

module.exports = class LocalEndpointsView extends View
    @content: ->
        @div =>
            @div =>
                @subview 'toolbar', new ToolbarView(toolbarConfig)
            @div class: 'srcollbale endpoints-list', =>
                @ul class: 'list-tree has-collapsable-children', outlet: 'endpointsListView'

    initialize: (state) ->
        @refresh()
        @toolbar.reload.click => @refresh()

    refresh: () ->
        @selectedEndpoints = {}
        rootPaths = atom.project.getPaths()
        @fileListConfig = requireUncache "#{__dirname}/file-list-config.json"
        list = @scanFiles(rootPaths[0], {}, rootPaths[0])
        @endpointsListView.empty()
        @endpointsListView.append @createFileList([list])

    scanFiles: (curDir, fileList = {}, rootPath) ->
        files = fs.listSync curDir
        fileList.rootPath = rootPath
        fileList.path = curDir
        fileList.pathName = path.basename(curDir)
        fileList.type = 'dir'
        fileList.content = []
        files.forEach (file) =>
            if (fs.isDirectorySync file )
                if (!@fileListConfig.excludedPaths.some (path) => file.includes path )
                    fileList.content.push @scanFiles(file, {}, rootPath)
            else
                if (@fileListConfig.includedExtensions.some (ext) => path.extname(file) == ext )
                    fileList.content.push {
                        path: file,
                        fileName: path.basename(file),
                        type: "file",
                        ext: path.extname(file)
                    }
        fileList

    createFileList: (data) =>
        ul = $ '<ul>'
        ul.addClass 'list-tree'
        data.map (el) =>

            if el.type == 'dir'
                li = $ "<li class='list-nested-item'>"

                if (el.pathName == path.basename el.rootPath) then icon = 'icon-repo'
                else icon = 'icon-file-directory'
                if el.content.length > 0
                    li.append "<div class='list-item'><span class='endpoint-dir icon #{icon}'>#{el.pathName}</span></div>"
                    li.click (e) =>
                        e.stopPropagation()
                        if e.target.localName == 'li'
                            $(e.target).toggleClass 'collapsed'
                        else if e.target.localName == 'div' and e.target.classList[0] == 'list-item'
                            $(e.target.parentNode).toggleClass 'collapsed'
                        else if e.target.localName == 'span' and e.target.classList[0] == 'endpoint-dir'
                            $(e.target.parentNode.parentNode).toggleClass 'collapsed'

                    ul.append(
                        li.append @createFileList el.content
                    )

            else
                ul.append(
                    $("<li class='list-item'>")
                        .attr 'id', "local-endpoint-#{el.path}"
                        .append(
                            $ "<input class='input-checkbox' type='checkbox'>"
                                .attr 'data-target', "#{el.path}"
                                .change (e) => @selectEndpoint e.target.dataset.target
                        )
                        .append "<span class='endpoint-title'>#{el.fileName}</span>"
                        .click (e) =>
                            if e.target.localName != 'input'
                                $(e.currentTarget).find('input:checkbox').trigger('click')
                    )


    selectEndpoint: (id, type = 'files') ->
        if !@selectedEndpoints[type]
            @selectedEndpoints[type] = []
        @selectedEndpoints[type].push id
        $(document.getElementById "local-endpoint-#{id}" ).toggleClass 'selected-endpoint'

    getEndpoints: () ->
        @selectedEndpoints
