
function parsefilebody(s; quarto = true)
    @debug("Raw data for file body: $(s)")
    resultlines = []
    stripped = stripdataview(s)
    for ln in split(stripped, "\n")
        if quarto
            push!(resultlines, replace(ln, "```mermaid" => "```{mermaid}"))
        else
            push!(resultlines, ln)
        end
    end
    output = join(resultlines, "\n")
    @debug("Striped to $(output)")
    output
    
end

"""Parse Obsidian file f into optional yaml header and
body section.
$(SIGNATURES)
"""
function parsefile(f; quarto = false)
    lines = readlines(f)
    @debug("Read $(length(lines)) lines from $(f)")
    if isempty(lines)
        (header = "", body = "")
    else
        idx = 0
        if lines[1] == "---"
            @debug("YAML header detected")
            idx = 2
            headerlines = []
            while (lines[idx] != "---")
                push!(headerlines, lines[idx])
                idx = idx + 1
                @debug("$(idx): $(lines[idx])")
            end
        
            body = parsefilebody(join(lines[idx + 1:end], "\n"); quarto = quarto)

            @debug("Body lines $(body)")
            (   header = join(headerlines, "\n"), 
                body = body)
        
        else
            (header = "", body = parsefilebody(read(f, String); quarto = quarto))
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

