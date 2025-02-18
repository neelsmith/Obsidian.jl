"""Find file path for wiki name.
$(SIGNATURES)
"""
function path(v::Vault, wikiname; relative = false) 
    
    if haskey(v.filemap, wikiname)
        relative ? "." * replace(v.filemap[wikiname], v.root => "" ) :   v.filemap[wikiname]
    else
        @warn("Failed to find path to $(wikiname)")
        nothing
    end
end



"""Finds list of pages in Vault `v`
that link to wikiname `wikiname`.
$(SIGNATURES)
"""
function linkedto(v::Vault, wikiname)
    if haskey(v.inlinks, wikiname)
        v.inlinks[wikiname]
    else
        String[]
    end
end

"""Finds list of links on page `wikiname` in Vault `v`.
$(SIGNATURES)
"""
function linkson(v::Vault, wikiname)
    if haskey(v.outlinks, wikiname)
        v.outlinks[wikiname]
    else
        String[]
    end
end



