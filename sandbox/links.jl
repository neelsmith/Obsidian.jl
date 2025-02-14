using Obsidian

repo = pwd()
v = Vault(joinpath(repo, "test", "data", "presidents-vault"))


abe = path(v, "Abraham Lincoln")
ov = path(v, "overview")
census = path(v, "Abraham Lincoln 1860 census")
Obsidian.relativelink(abe,overview)
Obsidian.relativelink(overview, abe)