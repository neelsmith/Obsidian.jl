"""Export all notes in vault `v` to markdown files in root directory `dest``.
$(SIGNATURES)
"""
function exportmd(v::Vault, outputroot;
    keepyaml = false, yaml = "", quarto = true)
    for n in notes(v)
        exportmd(v, wikiname(n), outputroot; keepyaml = keepyaml, yaml = yaml, quarto = quarto)
    end
end

function exportmd(v::Vault,n::Note, outputroot; 
    keepyaml = false, yaml = "", quarto = true)
    exportmd(v, wikiname(n), outputroot; keepyaml = keepyaml, yaml = yaml, quarto = quarto)
end

function exportmd(v::Vault, pg::AbstractString, outputroot; 
    keepyaml = false, yaml = "", quarto = true)
    srcpath = path(v,pg; relative = true)
    dest = joinpath(outputroot, srcpath)
    if quarto
        dest = replace(dest, r".md$" => ".qmd")
    end
    destdir = dirname(dest)
    if ! isdir(destdir)
        mkpath(destdir)
    end
    @debug("Export contents of note <$(pg)> to output $(dest)")
    mdtext = mdcontent(v,pg)
    
    # do quarto things if true
    if quarto
        mdtext = replace(mdtext, "```mermaid" => "```{mermaid}")
    end

    open(dest, "w") do io
        write(io, mdtext)
    end
    #testread = read(dest, String)
    #@info("It worked! $(testread)")
    
end

function mdcontent(v, pg)
    # get body
    srccontents = parsefile(path(v, pg))
    # strip dataview
    nodv = stripdataview(srccontents.body)
    # linkify
    linked = linkify(v,pg,nodv)
    # strip hidden sequences
    striphidden(linked)
end


function linkify(v,pgname, text)
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
    #@info("Work from $(lines)")
    for ln in lines
       # @info("Look at $(ln)")

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

