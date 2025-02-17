"""Notes in obsidian are identified by their "wikiname".
This is just the base file name with no extension of the note
in the Obsidian vault.
$(SIGNATURES)
"""
struct Note
    wikiname
end

"""Get wikiname for a note.
$(SIGNATURES)
"""
function wikiname(n::Note)
    n.wikiname
end

"""Find all notes in a vault.
$(SIGNATURES)
"""
function notes(v::Vault)
    Note.(wikinames(v))
end

