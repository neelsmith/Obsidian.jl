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
function islink(s)
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




"""Extract tags from YAML header and markdown body of file `f`.
$(SIGNATURES)
"""
function tags(f)
    parsed = parsefile(f)

    try
        hdrtags = yamltags(parsed.header)
        bodytags = mdtags(parsed.body)
        vcat(bodytags, hdrtags)
    catch e
        @error("Failed to parse file $(f)")
        @error("function tags: failed to parse tags. Error was $(e)")
        []
    end
    
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
        if isnothing(yamldict)
            @error("Function yamltags failed to parse yaml.")
            @error("Input was ($yaml)")
        elseif typeof(yamldict) <: Dict && haskey(yamldict, "tags")
            raw = yamldict["tags"] 
            if typeof(raw) <: AbstractString
                "#" * raw
            else
                map(s -> "#" * s, raw)
            end
        else
            String[]
        end
    end
end