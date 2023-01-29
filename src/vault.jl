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


function mapfiles(root, currmap = Dict())

    for f in readdir(root)
        if startswith(f, ".")
            @warn("omit invisible $(f)")

        elseif isdir(joinpath(root,f))
            @info("DIRECTORY: $(f) ")
        
            
        elseif endswith(f, ".md")
            @info("FILE: $(f)")
        else
            @warn("omit $(f)")
        end
    end
    #Dict()
end