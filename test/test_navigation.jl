@testset "Test tagging of pages across a vault" begin
    v = Vault(joinpath(pwd(), "data", "presidents-vault"))
    
    presidents = tagged(v, "#president")
    @test length(presidents) == 2
    expectedpages = [ "Abraham Lincoln", "George Washington"]
    for name in presidents
        @test name in expectedpages
    end

    abetags = tags(v, "Abraham Lincoln")
    @test length(abetags) == 2
    expectedtags = ["#assassinated", "#president"]
    for abetag in abetags
        @test abetag in expectedtags
    end
    
end