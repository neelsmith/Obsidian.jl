
"""Parse Obsidian file f into optional yaml header and
body section.
"""
function parsefile(f)
    lines = readlines(f)
    if isempty(lines)
        (header = "", body = "")
    else
        if lines[1] == "---"
            idx = 2
            headerlines = []
            while (lines[idx] != "---")
                push!(headerlines, lines[idx])
                idx = idx + 1
                @warn("$(idx): $(lines[idx])")
            end
            bodylines = []
            idx = idx + 1
            for ln in lines[idx:end]
                push!(bodylines, ln)
            end
            (   header = join(headerlines, "\n"), 
                body = join(bodylines, "\n")
            )

        else
            (header = "", body = read(f) |> String)
        end
    end
end

"""Find pages in Vault `v` taggged with  tag `t`.
"""
function lookuptag(t, v)
    @warn("TBA")
    nothing
end

"""Find pages in Vault `v` linking to `lnk`.
"""
function lookuplink(lnk, v)
    if haskey(v.filemap, lnk)
        v.filemap[lnk]
    else
        @warn("
        No link $(lnk) found")
        nothing
    end
end

"""List tags included in page `p`.
"""
function tagsonpage(v, p)

    @warn("TBA")
    nothing
end


"""List wiki-style links included in page `p`.
"""
function linksonpage(v, p)
    @warn("TBA")
    nothing
end

"""Find pages in Vault `v` containing either  tag or link `s`.
"""
function lookup(s, v)
    if startswith(s,"#")
        lookuptag(s, v)
    else
        lookuplink(s, v)
    end
end



"""Apply YAML package parse to a string.
"""
function parseyaml(s::T) where T <: AbstractString
    YAML.load(IOBuffer(s))
end


"""Find any tags in YAML string `s`.
$SIGNATURES
"""
function tagsfromyaml(s)
    parsed = parseyaml(s)
    haskey(parsed, "tags") ? parsed["tags"] : String[]
end




function maptagstopage(root, tagtopagedict = Dict(); omit = ["Templates"])

    for f in readdir(root)
        if startswith(f, ".") || f in omit
            @debug("omit invisible $(f)")

        elseif isdir(joinpath(root,f))
            @debug("DIRECTORY: $(f) ")
            tagtopagedict = maptagstopage(joinpath(root, f), tagtopagedict, omit = omit)
            
        elseif endswith(f, ".md")
            linkname = replace(f, ".md" => "")
            @info("Get tags on page $(joinpath(root, f))")
            filedata = parsefile(joinpath(root, f))
            #currmap[linkname] = joinpath(root, f)
            @info("Link: $(linkname): $(filedata |> typeof)")
        else
            @debug("omit non-markdown file $(f)")
        end
    end
    tagtopagedict
end
