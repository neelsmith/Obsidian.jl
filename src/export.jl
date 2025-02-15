"""Export all notes in vault `v` to markdown files in root directory `dest``.
$(SIGNATURES)
"""
function exportmd(v::Vault, outputroot;
    keepyaml = false, yaml = "", quarto = true)
    for n in notes(v)
        exportmd(v, wikiname(n), outputroot; keepyaml = keepyaml, yaml = yaml, quarto = quarto)
    end
end


"""Export a note  `n` to a markdown file in a subdirectory of directory `outputroot`.
$(SIGNATURES)
"""
function exportmd(v::Vault,n::Note, outputroot; 
    keepyaml = false, yaml = "", quarto = true)
    exportmd(v, wikiname(n), outputroot; keepyaml = keepyaml, yaml = yaml, quarto = quarto)
end


"""Export a note named `pg` to a markdown file in a subdirectory of directory `outputroot`.
$(SIGNATURES)
"""
function exportmd(v::Vault, pg::AbstractString, outputroot; 
    keepyaml = false, yaml = "", quarto = true)

    srcpath = path(v,pg; relative = true)
    @info("SRCPATH $(srcpath)")
    dest = joinpath(outputroot, srcpath)
    @info("DEST IS $(dest)")
    if quarto
        qmd = replace(dest, r".md$" => ".qmd")
        dest = replace(qmd, " " => "_")
    end
    destdir = dirname(dest)
    if ! isdir(destdir)
        mkpath(destdir)
    end
    @debug("Export contents of note <$(pg)> to output $(dest)")
    mdtext = mdcontent(v,pg; quarto = quarto)
    @debug("TEXT IS $(mdtext)")
    # do quarto things if true
    if quarto
        #@info("Need to look for mermaid")
        #mdtext = replace(mdtext, "```mermaid" => "```{mermaid}")
    end


    finaltext = if keepyaml
        srccontents = parsefile(path(v, pg))
        string("---\n", pg.header, "---\n\n", mdtext)
    else
        yaml * mdtext
    end

    @info("WRITE FILE $(dest) ")
    
    #with $(finaltext)")
    open(dest, "w") do io
        write(io, finaltext)
    end

    
end


"""Extract the contents of a note as generic markdown.
YAML headers and `dataview` blocks are omitted. wiki-style
links are converted to standard markdown links with relative paths.
$(SIGNATURES)
"""
function mdcontent(v, pg; quarto = false)
    @debug("Get content of page $(pg)")
    # get body
    srccontents = parsefile(path(v, pg))
    # strip dataview
    nodv = stripdataview(srccontents.body)
    # strip hidden sequences
    stripped = striphidden(nodv)
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
        @debug("MAke links for $(lnk) to $(trgt)")

        replacethis = "[[$(lnk)]]"
        replacement = string("[", lnk, "](",trgt ,")")

        replaced = []
        for ln in split(text, "\n")
            push!(replaced, replace(ln, replacethis => replacement))
        end
        modifiedtext = join(replaced,"\n")
    end
    #=
    for k in keys(linkdict)
        #rellink = relativelink(v,k, linkdict[k])
        
        @info("Replace $(replacethis) with link ") #to $(rellink)")
        text = replace(text, replacethis => "LINK to $(k)")
        #k => string("[", k, "](", , ")" ))
    end
    =#
    modifiedtext
end


"""Strip any dataview hidden tags out of a string.
$(SIGNATURES)
"""
function striphidden(s)
    dvhidden = r"\([^)]+::[^)]+\)"
    raw = replace(s, dvhidden => "")
    tidier = replace(raw, r"[ ]+" => " ")
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

