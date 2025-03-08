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
            )
            
        else
            new(
                dir,
                mapfiles(dir, omit = omit),
                linkpagesindex(dir, omit = omit),
                pagelinksindex(dir, omit = omit ),
                tagpagesindex(dir, omit = omit),
                pagetagsindex(dir, omit = omit),
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


"""Find wikinames for notes in a vault.
Compare `notes(v::Vault)`.
$(SIGNATURES)
"""
function wikinames(v::Vault)::Vector{String}
    keys(mapfiles(v)) |> collect |> sort
end


"""Find all dataview key-value annotations in a vault.
$(SIGNATURES)
"""
function kvtriples(v::Vault)
    v.kvtriples
end


"""Create a dictionary of wikinames to full file paths.
$(SIGNATURES)
"""
function mapfiles(v::Vault)
    v.filemap
end

"""Beginning from directory `root`, create a dictionary
of wikinames to full file paths.
"""
function mapfiles(root; currmap = Dict(), omit = ["Templates"])
    @debug("Mapping files to honor $(omit)")
    for f in readdir(root)
        @debug("$(f) in omit? $(f in omit)")
        if startswith(f, ".") || f in omit
            @debug("omit invisible or excluded $(f)")

        elseif isdir(joinpath(root,f))
            @debug("Map subdirectory: $(f) ")
            currmap = mapfiles(joinpath(root, f), currmap = currmap, omit = omit)
            
        elseif endswith(f, ".md")
            linkname = replace(f, ".md" => "")
            currmap[linkname] = joinpath(root, f)
            @debug("Add md link: $(linkname)")
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

"""Beginning from directory `root`, index wikinames for pages to all links on that page.
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
            parsedfile = joinpath(root, f) |> parsefile
            filelinks = links(parsedfile.body)
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

            parsedfile = joinpath(root, f) |> parsefile
            filelinks = links(parsedfile.body)
          
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


"""Collect all dataview key-value pairs annotating each Obsidian note in a directory.
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


#=
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
=#


"""True if s is a valid link string to a note in a vault.
$(SIGNATURES)
"""
function validlink(s, v::Vault)
    iswikilink(s) ? link(s) in wikinames(v) : false
end

"""True if s is a valid wikiname in a vault.
$(SIGNATURES)
"""
function validname(s, v::Vault)
    s in wikinames(v)
end