struct Vault
    root
    filemap
    inlinks
    outlinks
    intags
    outtags
    indvtags
    outdvtags
    function Vault(dir; omit = ["Templates"]) 
        new(
            dir,
            mapfiles(dir, omit = omit),
            
        nothing,
        nothing,
        nothing,
        nothing,
        nothing,
        nothing
        )
    end
end


"""Beginning from directory `root`, create a dictionary
of valid Obsidian link names to full file paths.
"""
function mapfiles(root; currmap = Dict(), omit = ["Templates"])
    for f in readdir(root)
        if startswith(f, ".") || f in omit
            @debug("omit invisible $(f)")

        elseif isdir(joinpath(root,f))
            @debug("DIRECTORY: $(f) ")
            currmap = mapfiles(joinpath(root, f), currmap = currmap, omit = omit)
            
        elseif endswith(f, ".md")
            linkname = replace(f, ".md" => "")
            currmap[linkname] = joinpath(root, f)
            @debug("Link: $(linkname)")
        else
            @debug("omit non-markdown file $(f)")
        end
    end
    currmap
end
