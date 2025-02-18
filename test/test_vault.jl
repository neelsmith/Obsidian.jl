
@testset "Test vault" begin
    v = Vault(joinpath(pwd(), "data", "presidents-vault"))
    @test v isa Vault
end

@testset "Test vault with harder string matching patterns" begin
    vaultdir = joinpath(pwd(), "data", "customjsvault")
    v = Vault(vaultdir)
    @test v isa Vault

    wnames = wikinames(v)
    @test length(wnames) == 5
    for wname in ["Hammond letter 7", "Stephen Ayres", "Will of Stephen Ayres", "intro", "testebenezer"]
        @test wname in wnames
    end

    letter7pairs = kvpairs(v, "Hammond letter 7")
    @test length(letter7pairs) == 2
end


@testset "Test notes objects and wikinames" begin
    v = Vault(joinpath(pwd(), "data", "presidents-vault"))

    noteslist = notes(v)
    
    expectednotes = [
    Note("Abraham Lincoln"),
    Note("Abraham Lincoln 1860 census"),
    Note("Custis"),
    Note("Dandridge"),
    Note("George Washington"),
    Note("Lincoln"),
    Note("Martha Washington"),
    Note("Springfield, Sangamon, Illinois"),
    Note("View geography"),
    Note("Washington"),
    Note("crossreferences"),
    Note("overview"),
    Note("yamltest")]

    @test length(noteslist)  == length(expectednotes)
    for n in noteslist
        @test n in expectednotes
    end

    abe = filter(n -> wikiname(n) == "Abraham Lincoln", noteslist)
    @test length(abe) == 1


    expectednames = map(n -> wikiname(n), expectednotes)
    @test wikinames(v) == expectednames
end