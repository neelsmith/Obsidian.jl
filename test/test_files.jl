
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