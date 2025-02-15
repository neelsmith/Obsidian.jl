
"""Parse Obsidian file f into optional yaml header and
body section.
$(SIGNATURES)
"""
function parsefile(f; quarto = false)
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
                if quarto
                    push!(bodylines, replace(ln, "```mermaid" => "```{mermaid}"))
                else
                    push!(bodylines, ln)
                end
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

