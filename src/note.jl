struct Note
    wikiname
end


function isnoteref(s)
    startswith(s, "[[") && endswith(s, "]]")
end


function notes(v::Vault)
    Note.(wikinames(v))
end