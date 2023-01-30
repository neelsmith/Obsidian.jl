module Obsidian

using YAML


include("dvtags.jl")
include("vault.jl")
include("files.jl")

export Vault
export lookup

end # module Obsidian
