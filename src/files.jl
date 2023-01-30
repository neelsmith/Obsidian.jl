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
        @warn("No link $(lnk) found")
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