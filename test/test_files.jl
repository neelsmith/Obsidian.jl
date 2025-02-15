
@testset "Test stripping dataview blocks" begin
    testdata= """Regular markdown
```dataview
```    
More markdown.
"""
    expected = """Regular markdown
More markdown.
"""

    stripped = Obsidian.stripdataview(testdata)
    
    @test stripped == expected
    
end