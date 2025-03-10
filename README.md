# Obsidian.jl

Work with [Obsidian vaults](https://obsidian.md) in  Julia.

An Obsidian vault is just a directory with markdown content. In addition to standard Markdown, the Obsidian app supports wiki-style links for navigating within your vault, and tags beginning with `#` to add metadata to your notes. It also allows executable code blocks in javascript.

But javascript is not my favorite language, so `Obsidian.jl` indexes your vault in much the same way as the Obsidian app:  you can find incoming and outgoing links to pages,  tags occurring on pages or all tags on a page.

In addition, the [dataview plugin](https://github.com/blacksmithgu/obsidian-dataview) adds a notation for key-value pairs. By default, `Obsidian.jl` also  indexes these k-v pairs.

To see how it works, see the [documentation](https://neelsmith.quarto.pub/obsidian/).

