using Obsidian
using Markdown
outdir = joinpath(pwd(), "scratch", "debug")
obsgen = joinpath(pwd() |> dirname, "ObsidianGenealogy.jl")
testvault = joinpath(obsgen,"test", "assets", "presidents-vault")
isdir(testvault)

v = Vault(testvault)
notenames = wikinames(v)

census = "Abraham Lincoln 1860 census"

pgmd = mdcontent(v,census)
Markdown.parse(pgmd)

exportmd(v,census,outdir)



