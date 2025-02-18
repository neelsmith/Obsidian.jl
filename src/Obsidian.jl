module Obsidian

using YAML
import Base: show

using Documenter, DocStringExtensions


include("vault.jl")
include("obsidiantags.jl")
include("wikilinks.jl")
include("properties.jl")
include("kvtags.jl")

include("files.jl")
include("navigation.jl")
include("note.jl")
include("export.jl")

export Note
export notes

export Vault
export wikinames, links, link, validlink
export pagestotags, tagstopages
export path
export linkson, linkedto
export tags, tagged
export kvtriples, valueslist, noteslist

export NoteKV
export wikiname, key, value

export kvpairs

export mdcontent, exportmd

end
