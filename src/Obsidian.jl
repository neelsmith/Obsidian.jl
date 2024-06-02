module Obsidian

using YAML
import Base: show

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
export kvtriples, valueslist, noteslist

export NoteKV
export wikiname, key, value

export kvpairs

end # module Obsidian
