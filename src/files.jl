
"""Parse Obsidian file f into optional yaml header and
body section.
$(SIGNATURES)
"""
function parsefile(f)
    lines = readlines(f)
    if isempty(lines)
        (header = "", body = "")
    else
        if lines[1] == "---"
            idx = 2
            headerlines = []
            while (lines[idx] != "---")
                push!(headerlines, lines[idx])
                idx = idx + 1
                @debug("$(idx): $(lines[idx])")
            end
            bodylines = []
            idx = idx + 1
            for ln in lines[idx:end]
                push!(bodylines, ln)
            end
            (   header = join(headerlines, "\n"), 
                body = join(bodylines, "\n")
            )

        else
            (header = "", body = read(f) |> String)
        end
    end
end

"""Apply YAML package's parsing to a string.
$(SIGNATURES)
"""
function parseyaml(s::T) where T <: AbstractString
    if isempty(s)   
        nothing 
    else 
        try
             YAML.load(IOBuffer(s))

        catch e 
            @error("Function parseyaml: failed to parse YAML. Input was $(s)\n\n")
            @error(string(e))
            nothing
        end
    end
end

"""Strip any dataview blocks out of a string.
$(SIGNATURES)
"""
function stripdataview(s::AbstractString)
    lines = split(s, "\n")
    contents = []
    incontent = true
    #@info("Work from $(lines)")
    for ln in lines
       # @info("Look at $(ln)")

        if startswith(ln, "```dataview")
            incontent = false

        elseif startswith(ln, "```") && (incontent == false)
            incontent = true

        elseif incontent
            push!(contents, ln)
        end
    end
    
    join(contents,"\n")
end

"""Find a relative path from full path s1 to full path s2.
$(SIGNATURES)
"""
function relativepath(s1, s2)
    parts1 = filter(piece -> ! isempty(piece), split(s1, "/"))
    parts2 = filter(piece -> ! isempty(piece), split(s2, "/"))


    i = 1
    done = false
    while ! done
        @debug("$(i): ")
        if parts1[i] == parts2[i]
            i = i + 1
            @debug("i now $(i)")
        else
            done = true
        end
    end
    lipomena1 = parts1[i:end]
    lipomena2 = parts2[i:end]
  


    l1 = length(lipomena1)
    l2 = length(lipomena2)
    
    
  #  if l1 == l2 || l1 > l2
        #@info("Same length!")
        prefix = repeat("../", l1)
        result = string(prefix, join(lipomena2,"/"))
        @info(result)
        #"../$(basename(s2))"

    #=elseif l1 > l2
       # @info("l1 is longer $(l1)  > $(l2)")

    else
        "l2 is longer $(l2)  > $(l1)"
        #l1 > l2 ? "First string is longer ($(l1) vs $(l2)))" : "S2 longer"
    end
=#
    @info("What's left: ")
    @info("$(lipomena1)") 
    @info("$(lipomena2)")
    result
    
end