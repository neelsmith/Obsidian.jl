

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


function tags(f)
    parsed = parsefile(f)
    mdtags(parsed.body)    
end

"""Extract tags from markdown string. Tags are tokens beginning with pound sign `#`.
$(SIGNATURES)
"""
function mdtags(md)
    @info("Get tags from $(md)")
    tokens = split(md, r"\s")
    filter(t -> !isempty(t) && t[1] == '#', tokens)
end