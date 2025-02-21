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

## Genealogy data:

genrepo = "/Users/nsmith/Dropbox/_obsidian/family-history"
gen = Vault(genrepo)
