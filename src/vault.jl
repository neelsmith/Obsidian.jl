struct Vault
    root
    filemap
    inlinks
    outlinks
    intags
    outtags
    indvtags
    outdvtags
    function Vault(dir) 

        new(
            dir,
            mapfiles(dir),
        nothing,
        nothing,
        nothing,
        nothing,
        nothing,
        nothing
        )
    end
end


function mapfiles(root)
    Dict()
end