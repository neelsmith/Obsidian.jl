"""Lookup tag `t` in Vault `v`.
"""
function lookuptag(t, v)
    @warn("TBA")
    nothing
end

"""Lookup tag `t` in Vault `v`.
"""
function lookuplink(lnk, v)
    if haskey(v.filemap, lnk)
        v.filemap[lnk]
    else
        @warn("No link $(lnk) found")
        nothing
    end
end

"""Lookup a tag or link in Vault `v`.
"""
function lookup(s, v)
    if startswith(s,"#")
        lookuptag(s, v)
    else
        lookuplink(s, v)
    end
end