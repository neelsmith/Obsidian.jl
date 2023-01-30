

"""Extract wiki-style links from string `s`.
$SIGNATURES
"""
function links(s)
    linkre = r"\[\[([^\]]+)]]"

    #m = match(linkre, s)

    linklist = []
    for m in eachmatch(linkre, s)
        push!(linklist, m.captures[1])
    end
    linklist
end



#=
THIS IS FOR WIKI links
mdlinks = """This is some md with [[wiki links]] in the content [[everywhere]]!"""



=#