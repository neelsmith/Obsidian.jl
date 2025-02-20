"""Export all notes in vault `v` to markdown files in root directory `dest``.
$(SIGNATURES)
"""
function exportmd(v::Vault, outputroot;
    keepyaml = false, yaml = "", quarto = true, omitdvtags = true, omittags = true)
    for n in notes(v)
        exportmd(v, wikiname(n), outputroot; keepyaml = keepyaml, yaml = yaml, quarto = quarto, omitdvtags = omitdvtags, omittags = omittags)
    end
    @info("$(v) exported to directory $(outputroot)")
end


"""Export a note  `n` to a markdown file in a subdirectory of directory `outputroot`.
$(SIGNATURES)
"""
function exportmd(v::Vault, n::Note, outputroot; 
    keepyaml = false, yaml = "", quarto = true, omitdvtags = true, omittags = true)
    exportmd(v, wikiname(n), outputroot; keepyaml = keepyaml, yaml = yaml, quarto = quarto, omitdvtags = omitdvtags, omittags = true)
end


"""Export a note named `pg` to a markdown file in a subdirectory of directory `outputroot`.
$(SIGNATURES)
"""
function exportmd(v::Vault, pg::AbstractString, outputroot; 
    keepyaml = false, yaml = "", quarto = true, omitdvtags = true, omittags = true)
    @debug("Start to export page $(pg)")
    srcpath = path(v,pg; relative = true)   
    @debug("SRC $(srcpath)") 
    dest = joinpath(outputroot, srcpath)
    if quarto
        qmd = replace(dest, r".md$" => ".qmd")
        dest = replace(qmd, " " => "_")
    end
    destdir = dirname(dest)
    if ! isdir(destdir)
        mkpath(destdir)
    end
    @debug("Export contents of note <$(pg)> to output $(dest)")

    mdtext = mdcontent(v,pg; quarto = quarto, omitdvtags = omitdvtags, omittags = omittags)
    finaltext = if keepyaml
        srccontents = parsefile(path(v, pg))
        string("---\n", srccontents.header, "---\n\n", mdtext)
    else
        yaml * mdtext
    end
    
    open(dest, "w") do io
        write(io, finaltext)
    end
end


"""Extract the contents of a note as generic markdown.
YAML headers and `dataview` blocks are omitted. wiki-style
links are converted to standard markdown links with relative paths.
$(SIGNATURES)
"""
function mdcontent(v, pg; quarto = false, omitdvtags = true, omittags = true)
    @debug("Get content of page $(pg)")
    # get body
    srccontents = parsefile(path(v, pg); quarto = quarto)
    # strip dataview
    nodv = stripdataview(srccontents.body)
    # strip dataveiw tags
    @debug("Page before stripping tags: $(nodv)")
    stripped = stripdvtags(nodv; omitdvtags = omitdvtags)
    # strip Obsidian tags
    stripped = if omittags
        striptags(stripped)
    else
        stripped
    end
    @debug("Stripped text: $(stripped)")
    # linkify
    linked = linkify(v,pg,stripped; quarto = quarto)
end


function relativelink(v, src, dest)
    p1 = path(v, src)
    p2 = path(v, dest)
    @debug("Get relative path from $(p1) to")
    @debug(p2)
    relativepath(p1, p2)
end

"""Modify the text of a source page to convert wikilinks to regular HTML links with relative paths.
$(SIGNATURES)
"""
function linkify(v, pgname, text; quarto = false)
    @debug("Linkify $(pgname)")
    linkkeys = linkson(v, pgname)
    @debug("Link keys $(linkkeys)")
    modifiedtext = text
    for lnk in linkkeys
        @debug("Get relative ref for $(pgname) to $(lnk)")
        relativeref = relativelink(v, pgname, lnk)
        if isnothing(relativeref)
            @debug("Relative ref is $(relativeref)!")
        else
            trgt = replace(relativeref, " " => "_")
            if quarto
                trgt = replace(trgt, r".md$" => ".html")
            end
            @debug("Make links for $(lnk) to $(trgt)")


            ## WHAT IF IT'S ALREADY A WIKI LINK?
            replacethis = iswikilink(lnk) ? lnk : "[[$(lnk)]]"
            replacement = string("[", lnk, "](",trgt ,")")
            @debug("Linkfy string $(text)")
            replaced = []
            if ! isnothing(text)
                for ln in split(text, "\n")
                    push!(replaced, replace(ln, replacethis => replacement))
                end
            end
            modifiedtext = join(replaced,"\n")
        end
    end
    modifiedtext
end

"""Strip Obsidian tags out of a string.
$(SIGNATURES)
"""
function striptags(s)
    @debug("Strip Obs tgs from page")
    tagre = r"[ \t]*#[^ \t\n#]+"
    stripped = []
    for ln in split(s,"\n")
        notags = replace(ln, tagre => "")
        push!(stripped, notags)
    end
    @debug("Completed.")
    join(stripped, "\n")
end

"""Strip dataview hidden tags out of a string.
Always strip hidden tags; strip visible tags based on
setting of `omitdvtags` parameter.
$(SIGNATURES)
"""
function stripdvtags(s; omitdvtags = false)
    dvhidden = r"[ \t]*\([^)]+::[^)]+\)"
    dvvisible = r"[ \t]*\[[^::]+::[^\]]+]" 


    strippedlines = []
    for ln in split(s,"\n")
        stripped1 = replace(ln, dvhidden => "")
        @debug("Stripped hidden tags to get $(stripped1)")
        stripped = if omitdvtags
            @debug("Now strip visible tags")
            replace(stripped1, dvvisible => "")
        else
            stripped1
        end
        tidier = replace(stripped, r"[ ]+" => " ")
        push!(strippedlines, tidier)
    end
    join(strippedlines,"\n")
end

"""Strip any dataview blocks out of a string.
$(SIGNATURES)
"""
function stripdataview(s::AbstractString)
    lines = split(s, "\n")
    contents = []
    incontent = true
    @debug("Work from $(lines)")
    for ln in lines
       @debug("Look at $(ln)")

        if startswith(ln, "```dataview")
            incontent = false

        elseif startswith(ln, "```") && (incontent == false)
            incontent = true

        elseif incontent
            push!(contents, ln)
        end
    end
    
    join(contents,"\n")
end


"""Find a relative path from full path s1 to full path s2.
$(SIGNATURES)
"""
function relativepath(s1, s2)
    skipit = false
    @debug("Relative $(s1) to $(s2)")
    if isnothing(s1)
        skipit = true
    end
    if isnothing(s2)
        skipit = true
    end

    @debug("Skip it? $(skipit)")

    if skipit
        @debug("Something was empty or nothing.")
        nothing

    else
        @debug("REL PATHS FOR $(s1), $(s2)")
        parts1 = filter(piece -> ! isempty(piece), split(s1, "/"))
        parts2 = filter(piece -> ! isempty(piece), split(s2, "/"))
        @debug("Pieces $(parts1), $(parts2)")
        i = 1
        done = false
        
        while ! done
            @debug("$(i): $(parts1[i]), $(parts2[i]) ")
            if parts1[i] == parts2[i]
                i = i + 1
                if (i > length(parts1)) || (i > length(parts2))
                    done = true
                end
                @debug("i now $(i)")
            else
                done = true
            end
        end
        lipomena1 = parts1[i:end]
        lipomena2 = parts2[i:end]
    
        l1 = length(lipomena1)
        #l2 = length(lipomena2)
        
        prefix = repeat("../", l1)
        relative = string(prefix, join(lipomena2,"/"))
        result = replace(relative, r"^\.\./" => "./")
        @debug(result)
            
        @debug("What's left: ")
        @debug("$(lipomena1)") 
        @debug("$(lipomena2)")
        result
    end
end

