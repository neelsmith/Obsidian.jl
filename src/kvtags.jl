


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
