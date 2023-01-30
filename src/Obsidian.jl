module Obsidian

using YAML

using Documenter, DocStringExtensions

include("dvtags.jl")
include("vault.jl")
include("files.jl")

export Vault
export lookup

end # module Obsidian
