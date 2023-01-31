struct Vault
    root
    filemap
    inlinks
    outlinks
    intags
    outtags
    inkvpairs
    outkvpairs

    function Vault(dir; omit = ["Templates"]) 
        new(
            dir,
            mapfiles(dir, omit = omit),
            linkpagesindex(dir, omit = omit),
            pagelinksindex(dir, omit = omit),
            tagpagesindex(dir, omit = omit),
            pagetagsindex(dir, omit = omit),
        nothing,
        nothing
        )
    end
end


"""Finds list of pages in Vault `v`
that link to wikiname `wikiname`.
$(SIGNATURES)
"""
function linked(v::Vault, wikiname)
    @warn("TBA")
    nothing
end

"""Finds list of links on page `wikiname` in Vault `v`.
$(SIGNATURES)
"""
function links(v::Vault, wikiname)
    @warn("TBA")
    nothing
end


"""Finds list of pages in Vault `v`
that are tagged with tag `t`.
$(SIGNATURES)
"""
function tagged(v::Vault, t)
    @warn("TBA")
    nothing
end


"""Finds list of tags on page `p` in Vault `v`.
$(SIGNATURES)
"""
function tags(v::Vault, p)
    @warn("TBA")
    nothing
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

"""Beginning from directory `root`, index wikiname for pages to all tags on that page.
$(SIGNATURES)
"""
function pagetagsindex(root, idx = Dict(); omit = ["Templates"])
    for f in readdir(root)
        if startswith(f, ".") || f in omit
            @debug("omit invisible $(f)")

        elseif isdir(joinpath(root,f))
            @debug("DIRECTORY: $(f) ")
            idx = pagetagsindex(joinpath(root, f), idx, omit = omit)
            
        elseif endswith(f, ".md")
            wikiname = replace(f, ".md" => "")
            @debug("Get tags for $(f)")
            filetags = tags(joinpath(root,f))
            idx[wikiname] = filetags
      
        else
            @debug("omit non-markdown file $(f)")
        end
    end
    idx
end


function tagpagesindex(root, idx = Dict(); omit = ["Templates"])
    for f in readdir(root)
        if startswith(f, ".") || f in omit
            @debug("omit invisible $(f)")

        elseif isdir(joinpath(root,f))
            @debug("DIRECTORY: $(f) ")
            idx = tagpagesindex(joinpath(root, f), idx, omit = omit)
            
        elseif endswith(f, ".md")
            filelinkname = replace(f, ".md" => "")
            filetags = tags(joinpath(root,f))
           
            if isempty(filetags)
            else
                for l in filetags
                    if haskey(idx, l)
                        oldreff = idx[l]
                        idx[l] =  push!(oldreff, filelinkname)
                    else
                        idx[l] = [filelinkname]
                    end
                end 
            end
        else
            @debug("omit non-markdown file $(f)")
        end
    end
    idx
end

"""Beginning from directory `root`, index wiki names for pages to all links on that page.
$(SIGNATURES)
"""
function pagelinksindex(root, idx = Dict(); omit = ["Templates"])
    for f in readdir(root)
        if startswith(f, ".") || f in omit
            @debug("omit invisible $(f)")

        elseif isdir(joinpath(root,f))
            @debug("DIRECTORY: $(f) ")
            idx = pagelinksindex(joinpath(root, f), idx, omit = omit)
            
        elseif endswith(f, ".md")
            wikiname = replace(f, ".md" => "")
            filelinks = links(String(read(joinpath(root, f))))
            idx[wikiname] = filelinks
      
        else
            @debug("omit non-markdown file $(f)")
        end
    end
    idx
end

""""Beginning from directory `root`, index wiki-style links to pages where the link occurs.
$(SIGNATURES)
"""
function linkpagesindex(root, idx = Dict(); omit = ["Templates"])

    for f in readdir(root)
        if startswith(f, ".") || f in omit
            @debug("omit invisible $(f)")

        elseif isdir(joinpath(root,f))
            @debug("DIRECTORY: $(f) ")
            idx = linkpagesindex(joinpath(root, f), idx, omit = omit)
            
        elseif endswith(f, ".md")
            filelinkname = replace(f, ".md" => "")
            filelinks = links(String(read(joinpath(root, f))))
           
            if isempty(filelinks)
            else
                for l in filelinks
                    if haskey(idx, l)
                        oldreff = idx[l]
                        idx[l] =  push!(oldreff, filelinkname)
                    else
                        idx[l] = [filelinkname]
                    end
                end 
            end
        else
            @debug("omit non-markdown file $(f)")
        end
    end
    idx
end

