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
include("note.jl")
include("export.jl")

export Note
export notes

export Vault
export wikinames, links, link, validlink
export path
export linkson, linkedto
export tags, tagged
export kvtriples, valueslist, noteslist

export NoteKV
export wikiname, key, value

export kvpairs

export exportmd

end
