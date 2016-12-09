getNotLoadedPackages = (packages) ->
    notLoaded = []
    for pack in packages
        if !atom.packages.isPackageLoaded(pack)
            notLoaded.push(pack)
    notLoaded

checkForPackageDependencies = (packages) ->
    getNotLoadedPackages(packages)


module.exports = {
    checkForPackageDependencies: checkForPackageDependencies
}
