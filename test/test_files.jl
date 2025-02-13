
@testset "Test stripping dataview blocks" begin
    testfile = joinpath(pwd(), "data", "testfile.md")
    stripped = Obsidian.stripdataview(testfile)
    contentlines = filter(ln -> ! isempty(ln), split(stripped,"\n"))
    
    expected = ["Last name: [[Neel]]", "## Notes", "Son of [[James Marion Neel]] and [[Luesey Clementine Neel]]", "He married [[Lydia Ruth Yell]] and they had many children", "## Claims"]
    @test contentlines == expected
end