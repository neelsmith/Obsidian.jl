"""Extract wiki-style links from string `s`.
$SIGNATURES
"""
function links(s)
    linkre = r"\[\[([^\]]+)]]"
    linklist = String[]
    for ln in split(s,"\n")
        for m in eachmatch(linkre, ln)
            push!(linklist, m.captures[1])
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
