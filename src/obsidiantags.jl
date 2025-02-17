

"""Extract Obsidian tags from YAML header and markdown body of file `f`.
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

"""Extract Obsidian tags from markdown string. Tags are tokens beginning with pound sign `#`.
$(SIGNATURES)
"""
function mdtags(md)
    taglist = String[]
    #tagre = r"(#[^#\s ]+) "
     tagre = r"(#[^#\s ]+)"
     for ln in split(md,"\n")
        for m in eachmatch(tagre, ln)
            push!(taglist, m.captures[1])
        end
    end
    taglist
end


"""Extract list of Obsidian tags from yaml string, and format list of values with preceding pound sign.
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