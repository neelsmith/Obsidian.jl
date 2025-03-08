
@testset "Test stripping dataview blocks" begin
    testdata= """Regular markdown
```dataview
task from #projects/active
```    
More markdown.
"""
    expected = """Regular markdown
More markdown.
"""

    stripped = Obsidian.stripdataview(testdata)
    
    @test stripped == expected
    
end

@testset "Test note with both dataview and mermaid blocks" begin
    testdata= """Regular markdown
    ```dataview
    task from #projects/active
    ```    
    More markdown, including a mermaid block.

    ```mermaid
    graph TD;
        A-->B;
        A-->C;
        B-->D;
        C-->D;
    ```
    """
        expected = """Regular markdown
More markdown, including a mermaid block.

```mermaid
graph TD;
    A-->B;
    A-->C;
    B-->D;
    C-->D;
```
"""
    actual = Obsidian.parsefilebody(testdata; quarto = false)
    @test expected == actual

    actual2 = Obsidian.parsefilebody(testdata; quarto = true)
    expected2 = """Regular markdown
More markdown, including a mermaid block.

```{mermaid}
graph TD;
    A-->B;
    A-->C;
    B-->D;
    C-->D;
```
"""
    @test expected2 == actual2
end