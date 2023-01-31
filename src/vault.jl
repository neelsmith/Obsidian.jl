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


""""Beginning from directory `root`, index wiki-style links to pages.
$(SIGNATURES)
"""
function maptagstopage(root, tagtopagedict = Dict(); omit = ["Templates"])

    for f in readdir(root)
        if startswith(f, ".") || f in omit
            @debug("omit invisible $(f)")

        elseif isdir(joinpath(root,f))
            @debug("DIRECTORY: $(f) ")
            tagtopagedict = maptagstopage(joinpath(root, f), tagtopagedict, omit = omit)
            
        elseif endswith(f, ".md")
            filelinkname = replace(f, ".md" => "")
            @info("Get tags on page $(joinpath(root, f))")
            #filedata = parsefile(joinpath(root, f))
            filelinks = links(String(read(joinpath(root, f))))
            #if haskey(tagtopagedict
            if isempty(filelinks)
            else
                for l in filelinks
                    @info("GOT $(filelinks)")
                    if haskey(tagtopagedict, l)
                        @info("Already have entry for $(l)")
                        oldreff = tagtopagedict[l]
                        tagtopagedict[l] =  push!(filelinkname, oldreff )
                    else
                        tagtopagedict[l] = [filelinkname]
                    end
                end

                
            end
            #currmap[linkname] = joinpath(root, f)
            #@info("Link: $(filelinkname): $(filedata |> typeof)")
        else
            @debug("omit non-markdown file $(f)")
        end
    end
    tagtopagedict
end

