
"""Apply YAML package parse to a string.
"""
function parseyaml(s::T) where T <: AbstractString
    YAML.load(IOBuffer(s))
end


function tagsfromyaml(s)
    parsed = parseyaml(s)
    haskey(parsed, "tags") ? parsed["tags"] : String[]
end

"""TBA"""
function kvfromyaml(s)
    parsed = parseyaml(s)
    #filter(parsed) so that key != "tags"
    nothing
end

function kvfrommd(s)
    initial = r"[^\([]+::"
    dvtag = r"[^[]\[([^\]]+)][^\]]"
    hiddendvtag = r"\(([^)]+)"
    # use eachmatch with each of those 3 regexen.
    # Split into k-v pairs
    @warn("TBA")
    nothing
end

#=
# Get line-initial from markdown
initial = r"[^\([]+::"
 m = match(initial, s, 1)
 isnothing(m) ? nothing :  m.match
=#

#=INLINE

=#

#=
THIS IS FOR WIKIN links
mdlinks = """This is some md with [[wiki links]] in the content [[everywhere]]!"""

lnk = r"\[\[([^\]]+)]]"

m = match(lnk, mdlinks)
m.captures

for m in eachmatch(lnk, mdlinks)
    println(m.captures[1])
end
=#