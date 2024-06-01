module Obsidian

using YAML

using Documenter, DocStringExtensions


include("tags_links.jl")
include("properties.jl")
include("kvtags.jl")
include("vault.jl")
include("files.jl")
include("navigation.jl")

export Vault
export wikinames
export path
export linkson, linkedto
export tags, tagged

export NoteKV

export kvpairs

end # module Obsidian
