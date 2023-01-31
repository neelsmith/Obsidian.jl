
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

"""Apply YAML package parse to a string.
"""
function parseyaml(s::T) where T <: AbstractString
    YAML.load(IOBuffer(s))
end

"""Find any tags in YAML string `s`.
$SIGNATURES
"""
function tagsfromyaml(s)
    if isempty(s)
        String[]
    else
        parsed = parseyaml(s)
        haskey(parsed, "tags") ? parsed["tags"] : String[]
    end
end



