module Obsidian

using YAML

using Documenter, DocStringExtensions


include("tags_links.jl")
include("kvtags.jl")
include("vault.jl")
include("files.jl")
include("navigation.jl")

export Vault
export linkson, linkedto
export tags, tagged

end # module Obsidian
