module Obsidian

using YAML

using Documenter, DocStringExtensions


include("tags_links.jl")
include("kvtags.jl")
include("vault.jl")
include("files.jl")

export Vault
export lookup

end # module Obsidian
