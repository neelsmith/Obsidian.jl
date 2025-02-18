"""Key-value metadata annotation for an Obsidian note, or page.
$(SIGNATURES)
"""
struct NoteKV
    wikiname
    key
    value
end


"""Identify wikiname for a `NoteKV`.
$(SIGNATURES)
"""
function wikiname(triple::NoteKV)
    triple.wikiname
end


"""Identify the property key for a `NoteKV`.
$(SIGNATURES)
"""
function key(triple::NoteKV)
    triple.key
end


"""Identify the property value for a `NoteKV`.
$(SIGNATURES)
"""
function value(triple::NoteKV)
    triple.value
end