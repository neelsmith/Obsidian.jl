

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

"""Extract tags from YAML header and markdown body of file `f`.
$(SIGNATURES)
"""
function tags(f)
    parsed = parsefile(f)
    vcat(mdtags(parsed.body), yamltags(parsed.header))
end

"""Extract tags from markdown string. Tags are tokens beginning with pound sign `#`.
$(SIGNATURES)
"""
function mdtags(md)
    taglist = String[]
    tagre = r"(#[^#\s ]+)"
    for m in eachmatch(tagre, md)
        push!(taglist, m.captures[1])
    end
    taglist
end

"""Extract tag list from yaml string, and format list of values with preceding pound sign.
$(SIGNATURES)
"""
function yamltags(yaml)
    if isempty(yaml)
        String[]
    else
        yamldict = parseyaml(yaml)
        raw =  if typeof(yamldict) <: Dict && haskey(yamldict, "tags")
            yamldict["tags"] 
        else
            String[]
        end
        map(s -> "#" * s, raw)
    end
end