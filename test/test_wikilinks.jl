
@testset "Test links" begin
    s = "[[Abraham Lincoln]]"
    @test Obsidian.iswikilink(s)
    @test Obsidian.link(s) == "Abraham Lincoln"

    namedlink = "[[Candace White|Candace]]"
    @test Obsidian.link(namedlink) == "Candace White"
end


@testset "Test multiple wikilinks" begin


    textselection = """refersto::[[Horatio Nelson White]]
refersto::[[Susan Spaulding]]


## Transcription

Name of Groom White, Horatio N.

Name of Bride Spaulding, Susan B.
"""

end



@testset "Test identifying bad links" begin
    v = Vault(joinpath(pwd(), "data", "presidents-vault"))
    badlinks = missinglinks(v)
    @test badlinks == ["an error"]
end