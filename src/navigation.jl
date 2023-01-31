
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

"""Finds list of pages in Vault `v`
that are tagged with tag `t`.
$(SIGNATURES)
"""
function tagged(v::Vault, t)
    if haskey(v.intags, t)
        v.intags[t]
    else
        String[]
    end
end


"""Finds list of tags on page `wikiname` in Vault `v`.
$(SIGNATURES)
"""
function tags(v::Vault, wikiname)
    if haskey(v.outtags, wikiname)
        v.outtags[wikiname]
    else
        String[]
    end
end
