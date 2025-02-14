
"""Parse Obsidian file f into optional yaml header and
body section.
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