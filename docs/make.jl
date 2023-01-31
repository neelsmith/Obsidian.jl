# Run this from repository root, e.g. with
# 
#    julia --project=docs/ docs/make.jl
#
# Run this from repository root to serve:
#
#   julia -e 'using LiveServer; serve(dir="docs/build")'
#
using Pkg
Pkg.activate(".")
Pkg.instantiate()

using Documenter, DocStringExtensions
using Obsidian

makedocs(   
    sitename = "Obsidian",
    pages = [
        "Overview" => "index.md",
        "Navigation" => "navigation.md",
        "Key-value pairs in dataview format" => "dataview.md",
    ]
    )

deploydocs(
    repo = "github.com/neelsmith/Obsidian.jl.git",
)    
