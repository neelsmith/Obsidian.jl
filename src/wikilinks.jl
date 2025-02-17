"""Extract wiki-style links from string `s`.
$SIGNATURES
"""
function links(s)
    linkre = r"\[\[([^\]]+)]]"
    linklist = String[]
    for m in eachmatch(linkre, s)
        push!(linklist, m.captures[1])
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
        m.captures[1]
    end
end
