"""Julia structure for an Obsidian vault.
$(SIGNATURES)
"""
struct Vault
    root
    filemap
    inlinks
    outlinks
    intags
    outtags
    kvtriples

    """Construct a Vault from a given directory.
    $(SIGNATURES)
    """
    function Vault(dir; omit = ["Templates"], dataview = true) 
        if dataview
            new(
                dir,
                mapfiles(dir, omit = omit),
                linkpagesindex(dir, omit = omit),
                pagelinksindex(dir, omit = omit),
                tagpagesindex(dir, omit = omit),
                pagetagsindex(dir, omit = omit),
                kvtriples(dir, omit = omit)

                #kvpagesindex(dir, omit = omit),
                #pageskvindex(dir, omit = omit)
            )
        else
            new(
                dir,
                mapfiles(dir, omit = omit),
                linkpagesindex(dir, omit = omit),
                pagelinksindex(dir, omit = omit ),
                tagpagesindex(dir, omit = omit),
                pagetagsindex(dir, omit = omit),
                nothing,
                nothing
            )
        end
    end
end

"""
Construct a Vault from current working directory.

$(SIGNATURES)
"""
function Vault(;  omit = ["Templates"], dataview = true)
    Vault(pwd(); omit = omit, dataview = dataview)
end

"""Override Base.show for `Vault`.
$(SIGNATURES)
"""
function show(io::IO, v::Vault)
    count = wikinames(v) |> length
    suffix = count == 1 ? "" : "s"
    str = string("Obsidian vault with $count note$suffix" )
    show(io,str)
end


"""Find all valid Obsidian names for files in a vault.
$(SIGNATURES)
"""
function wikinames(v::Vault)::Vector{String}
    keys(mapfiles(v)) |> collect |> sort
end

"""Create a dictionary of valid Obsidian link names to full file paths.
$(SIGNATURES)
"""
function mapfiles(v::Vault)
    mapfiles(v.root)
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

"""Beginning from directory `root`, index tags to pages where that tag occurs.
$(SIGNATURES)
"""
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


"""Collect all key-value pairs annotating each Obsidian note in a directory.
$(SIGNATURES)
"""
function kvtriples(root, triples = NoteKV[]; omit = ["Templates"] )
    for f in readdir(root)
        if startswith(f, ".") || f in omit
            @debug("omit file $(f) (invisible, or on omit list)")

        elseif isdir(joinpath(root,f))
            @debug("DIRECTORY: $(f) ")
            triples = kvtriples(joinpath(root, f), triples, omit = omit)
            
        elseif endswith(f, ".md")
            pgname = replace(f, ".md" => "")
            @debug("Working on file $(f)")
            for pr in kvpairs(joinpath(root,f))
                if isempty(pr)
                else
                    @debug("Look at $(pr)")
                    push!(triples, NoteKV(pgname, pr.k, pr.v))
                end
            end
        end
    end
    triples
end

function kvtriples(v::Vault)
    v.kvtriples
    #=
    results = NoteKV[]

    for pg in wikinames(v)
        for pr in kvpairs(v, pg)
            if isempty(pr)
            else
                @info("Look at $(pr)")
                push!(results, NoteKV(pg, pr.k, pr.v))
            end
        end
    end
    results
    =#
end

#=
function kvpagesindex(root, idx = Dict(); omit = ["Templates"])

    for f in readdir(root)
        if startswith(f, ".") || f in omit
            @debug("omit invisible $(f)")

        elseif isdir(joinpath(root,f))
            @debug("DIRECTORY: $(f) ")
            idx = kvpagesindex(joinpath(root, f), idx, omit = omit)
           
        elseif endswith(f, ".md")
            filelinkname = replace(f, ".md" => "")
            kvlinks = kvpairs(joinpath(root, f))
          
            if isempty(kvlinks)
            else
                for l in kvlinks
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

function pageskvindex(root, idx = Dict(); omit = ["Templates"])
end
=#
"""Find list of key-value pairs for a given note in a vault.
The result is a Vector of named tuples with fields `k` and `v`.


**Example**

```juliarepl
julia> kvpairs(v, notenames[1])
3-element Vector{Any}:
 (k = "sequence", v = "16")
 (k = "hiddensequence", v = "16")
 Dict{Any, Any}()
```


$(SIGNATURES)
"""
function kvpairs(v::Vault, note)
    path(v, note) |> kvpairs
end

"""Find list of key-value pairs for a given note in a vault.
$(SIGNATURES)
"""
function kvmap(v::Vault)
    kvdict = Dict()
    for wn in wikinames(v)
        kvlist = kvpairs(v, wn)
        @info("pg $wn has $(kvlist)")
    end
end


"""Find pairings of pagenames and values for a given key
in a key-value property.

$(SIGNATURES)
"""
function valueslist(v::Vault, k)
    results = NamedTuple{(:wikiname, :value), Tuple{String, String}}[]
    for triple in filter(trip -> key(trip) == k, kvtriples(v))
        push!(results,(wikiname = wikiname(triple), value = value(triple)))
    end
    results
end


function valueslist(v::Vault, pages::Vector{String}, k)
    results = NamedTuple{(:wikiname, :value), Tuple{String, String}}[]
    for triple in filter(trip -> key(trip) == k && wikiname(trip) in pages, kvtriples(v))
        push!(results,(wikiname = wikiname(triple), value = value(triple)))
    end
    results
end

function noteslist(vlt::Vault, k,v)::Vector{String}
    results = String[]
    @info("Look for k/v $(k)/$(v)")
    for triple in filter(trip -> key(trip) == k && value(trip) == v, kvtriples(vlt))
        push!(results, wikiname(triple))
    end
    results

end