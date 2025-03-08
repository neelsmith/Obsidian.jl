"""Extract wiki-style links from string `s`.
$SIGNATURES
"""
function links(s)
    linkre = r"\[\[([^\]]+)]]"
    linklist = String[]
    for ln in split(s,"\n")
        for m in eachmatch(linkre, ln)
            linkparts = split(m.captures[1], "|")
            push!(linklist, linkparts[1])
        end
    end
    linklist
end

"""True if `s` is a wikilink.
"""
function iswikilink(s)
    re = r"^\[\[(.+)]]$"
    m = match(re, s)
    if isnothing(m) 
        false 
    else
        true
    end 
end

"""Extract wiki-style link from string `s`.
$SIGNATURES
"""
function link(s)
    re = r"^\[\[(.+)]]$"
    m = match(re, s)
    if isnothing(m)
        nothing
    else
        raw = m.captures[1]
        pieces = split(raw, "|")
        pieces[1]
    end
end


"""Find all links referring to non-existent note.
$(SIGNATURES)
"""
function missinglinks(v)
    linkvalues = values(v.outlinks) |> Iterators.flatten |> collect |> unique
    pagenames = wikinames(v)
    filter(linkvalues) do lnk
        ! (lnk in pagenames)
    end
end