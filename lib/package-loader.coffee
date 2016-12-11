getNotLoadedPackages = (packages) ->
    notLoaded = []
    for pack in packages
        if !atom.packages.isPackageLoaded(pack)
            notLoaded.push(pack)
    notLoaded
    
    # notloaded = packages.map (p): -> if !atom.packages.isPackageLoaded(p) then p

checkForPackageDependencies = (packages) ->
    getNotLoadedPackages(packages)


module.exports = {
    checkForPackageDependencies: checkForPackageDependencies
}
