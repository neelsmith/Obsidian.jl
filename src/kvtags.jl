
"""Extract list of key-value pairs from file `f`. 
The result is a Vector of named tuples with two fields,
`k` and `v`.

**Example**

```juliarepl
julia> kvpairs("/path/to/file.md")
3-element Vector{Any}:
 (k = "sequence", v = "16")
 (k = "hiddensequence", v = "16")
 Dict{Any, Any}()
```

$(SIGNATURES)
"""
function kvpairs(f)
    parsed = parsefile(f)
    try 
        yamlout = kvfromyaml(parsed.header)
        @debug("YAML parsing yields $(yamlout)")
        vcat(kvfrommd(parsed.body), yamlout)
    catch e
        @warn("Failed to get kv pairs from file $(f)")
        []
    end
end

"""Extract  key-value pairs.from YAML string `s`.
Omit key `tags`.
$(SIGNATURES)
"""
function kvfromyaml(s)
    parsed = parseyaml(s)
    if isnothing(parsed) 
        []
    else 
        notags = filter(pr -> pr[1] != "tags", parsed)    
        if isempty(notags)
            []
        else
            results = []
            for k in keys(notags)
                push!(results, (k = k, v = notags[k]))
            end
            results
        end
    end
end

"""Extract from markdown string `s` any key-value pairs encoded using the notation of the `dataview` plugin.
There are three possible encodings for dataview key-value pairs: line-initial, inline, and hidden inline. See https://github.com/blacksmithgu/obsidian-dataview.

We use regexen to pull out key-value pairs. Since regexen are line-oriented, we extract the key-value pairs line by line.

Leading and trailing white space is trimmed from the value strings.

$(SIGNATURES)
"""
function kvfrommd(s)
    results = NamedTuple{(:k, :v), Tuple{String, String}}[]
    mdlines = split(s, r"[\r\n]")

    initialdv = r"^([^[:\(]+)::(.+)$"
    dvtag = r"[^[]\[([^[\]]+)]"
    hiddendvtag = r"\(([^)]+)"
    # use eachmatch with each of those 3 regexen.
    # Split into k-v pairs
    for ln in  mdlines
        for m in eachmatch(initialdv, ln)
            push!(results, (k = m.captures[1], v = strip(m.captures[2])))
        end
        for m in eachmatch(dvtag, ln)
            parts = split(m.captures[1], "::")
            if length(parts) != 2
                #@warn("Bad syntax for kv link: matched $(m.captures)")
                #@warn("Input was \n$(s)")
            else
                push!(results, (k = parts[1], v = strip(parts[2])))
            end
        end
        for m in eachmatch(hiddendvtag, ln)
            parts = split(m.captures[1], "::")
            if length(parts) != 2
                #@warn("Bad syntax for kv link: matched $(m.captures)")
            else
                push!(results, (k = parts[1], v = strip(parts[2])))
            end
        end
    end
    results
end

