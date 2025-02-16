"""Export all notes in vault `v` to markdown files in root directory `dest``.
$(SIGNATURES)
"""
function exportmd(v::Vault, outputroot;
    keepyaml = false, yaml = "", quarto = true, striptags = true)
    for n in notes(v)
        exportmd(v, wikiname(n), outputroot; keepyaml = keepyaml, yaml = yaml, quarto = quarto, striptags = striptags)
    end
    @info("$(v) exported to directory $(outputroot)")
end


"""Export a note  `n` to a markdown file in a subdirectory of directory `outputroot`.
$(SIGNATURES)
"""
function exportmd(v::Vault,n::Note, outputroot; 
    keepyaml = false, yaml = "", quarto = true, striptags = true)
    exportmd(v, wikiname(n), outputroot; keepyaml = keepyaml, yaml = yaml, quarto = quarto, striptags = striptags)
end


"""Export a note named `pg` to a markdown file in a subdirectory of directory `outputroot`.
$(SIGNATURES)
"""
function exportmd(v::Vault, pg::AbstractString, outputroot; 
    keepyaml = false, yaml = "", quarto = true, striptags = true)

    srcpath = path(v,pg; relative = true)    
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

    mdtext = mdcontent(v,pg; quarto = quarto, striptags = striptags)
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
function mdcontent(v, pg; quarto = false, striptags = true)
    @debug("Get content of page $(pg)")
    # get body
    srccontents = parsefile(path(v, pg); quarto = quarto)
    # strip dataview
    nodv = stripdataview(srccontents.body)
    # strip hidden sequences
    @debug("Page before stripping tags: $(nodv)")
    stripped = stripdvtags(nodv; striptags = striptags)
    # linkify
    linked = linkify(v,pg,stripped; quarto = quarto)
end


function relativelink(v, src, dest)
    relativepath(path(v, src), path(v, dest))
end


function linkify(v,pgname, text; quarto = false)
    @debug("Linkify $(pgname)")
    linkkeys = linkson(v, pgname)
    
    modifiedtext = text
    for lnk in linkkeys
        trgt = replace(relativelink(v, pgname, lnk), " " => "_")
        if quarto
            trgt = replace(trgt, r".md$" => ".html")
        end
        @debug("Make links for $(lnk) to $(trgt)")

        replacethis = "[[$(lnk)]]"
        replacement = string("[", lnk, "](",trgt ,")")

        replaced = []
        for ln in split(text, "\n")
            push!(replaced, replace(ln, replacethis => replacement))
        end
        modifiedtext = join(replaced,"\n")
    end
    modifiedtext
end


"""Strip dataview hidden tags out of a string.
Always strip hidden tags; strip visible tags based on
setting of `striptags` parameter.
$(SIGNATURES)
"""
function stripdvtags(s; striptags = false)
    dvhidden = r"\([^)]+::[^)]+\)"
    stripped1 = replace(s, dvhidden => "")
    @info("Stripped hidden tags to get $(stripped1)")
    stripped = if striptags
        #@info("Now strip visible tags")
        dvvisible = r"\[[^::]+::[^\]]+]" 
        replace(stripped1, dvvisible => "")
        
    else
        stripped1
    end
    tidier = replace(stripped, r"[ ]+" => " ")
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
    @debug("REL PATHS FOR $(s1), $(s2)")
    parts1 = filter(piece -> ! isempty(piece), split(s1, "/"))
    parts2 = filter(piece -> ! isempty(piece), split(s2, "/"))
    i = 1
    done = false
    while ! done
        @debug("$(i): ")
        if parts1[i] == parts2[i]
            i = i + 1
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
    result = string(prefix, join(lipomena2,"/"))
    @debug(result)
        
    @debug("What's left: ")
    @debug("$(lipomena1)") 
    @debug("$(lipomena2)")
    result
    
end

