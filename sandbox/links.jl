using Obsidian

repo = pwd()
v = Vault(joinpath(repo, "test", "data", "presidents-vault"))
#v = Vault(joinpath(repo, "test", "data", "customjsvault"))

#=
abe = path(v, "Abraham Lincoln")
ov = path(v, "overview")
census = path(v, "Abraham Lincoln 1860 census")
Obsidian.relativepath(abe,ov)
Obsidian.relativepath(ov, abe)
=#

## Mimic genealogy package:

genrepo = "/Users/nsmith/Dropbox/_obsidian/family-history"
gen = Vault(genrepo)

filenames = values(gen.filemap) |> collect
relativepaths = map(f -> replace(f, gen.root * "/" => ""), filenames)
docs = filter(f -> startswith(f, "transcriptions"), relativepaths)
docwikinames = map(d -> replace(basename(d), ".md" => ""), docs)

#outdir = joinpath(repo, "scratch", "famhist")
outdir = "/Users/nsmith/Desktop/famhist/quart-personal/familyhistory/sources"
for d in docwikinames
    try
        exportmd(gen, d, outdir)
    catch e
        @warn("Failed on $(d) with error $(e)")
    end
end


# Next, set up dummy pages for people.
folks = filter(f -> startswith(f, "people"), relativepaths)
folkswikinames = map(d -> replace(basename(d), ".md" => ""), folks)

function makepersonpage(v, n, outputdir)
    fname = replace(n, " " => "_") * ".qmd"
    dest = joinpath(outputdir, "people", fname)
    @info("$(dest)")
    pagelines = ["---","engine: julia", "---","","", n, "", ""]

    push!(pagelines, "## Page automatically generated")

    pagetext = join(pagelines, "\n")

    open(dest, "w") do io
        write(io, pagetext)
    end
end

for n in folkswikinames
    makepersonpage(gen, n, outdir)
end