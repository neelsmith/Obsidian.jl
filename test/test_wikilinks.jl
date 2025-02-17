
@testset "Test links" begin
    s = "[[Abraham Lincoln]]"
    @test Obsidian.iswikilink(s)
    @test Obsidian.link(s) == "Abraham Lincoln"
end


