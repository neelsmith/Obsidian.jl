@testset "Test tagging of pages across a vault" begin
    v = Vault(joinpath(pwd(), "data", "presidents-vault"))

    abetags = tags(v, "Abraham Lincoln")
    @test length(abetags) == 2
    expectedtags = ["#assassinated", "#president"]
    for abetag in abetags
        @test abetag in expectedtags
    end

    presidents = tagged(v, "#president")
    @test length(presidents) == 2
    expectedpages = [ "Abraham Lincoln", "George Washington"]
    for name in presidents
        @test name in expectedpages
    end

    abeinlinks = linkedto(v, "Abraham Lincoln")
    @test length(abeinlinks) == 3
    expectedinlinks = [ "Abraham Lincoln 1860 census", "crossreferences",  "overview"]
    for abeinlink in abeinlinks
        @test abeinlink in expectedinlinks
    end

    abeoutlinks = linkson(v, "Abraham Lincoln")
    @test abeoutlinks == ["Lincoln"]
end