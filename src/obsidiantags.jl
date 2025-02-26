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



"""Returns the dictionary of unique tags to pages where the tag occurs.
$(SIGNATURES)
"""
function tagstopages(v::Vault)
    v.intags
end

"""Returns the dictionary of pages to tags occuring on the page.
$(SIGNATURES)
"""
function pagestotags(v::Vault)
    v.outtags
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

"""Return dictionary of page names to tags.
$(SIGNATURES)
"""
function pagestotags(v)::Dict
    v.outtags
end


"""Return dictionary of Obsidan tags to page names.
$(SIGNATURES)
"""
function tagstopages(v)::Dict
    v.intags
end

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
        @debug("Look for tags in $(yaml)")
        yamldict = parseyaml(yaml)
        if isnothing(yamldict)
            @error("Function yamltags failed to parse yaml.")
            @error("Input was ($yaml)")
        elseif typeof(yamldict) <: Dict && haskey(yamldict, "tags")
            raw = yamldict["tags"] 
            if isnothing(raw)
                String[]
            elseif typeof(raw) <: AbstractString
                "#" * raw
            else
                map(s -> "#" * s, raw)
            end
        else
            String[]
        end
    end
end