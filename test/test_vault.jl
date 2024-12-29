
@testset "Test vault" begin
    v = Vault(joinpath(pwd(), "data", "presidents-vault"))
    @test v isa Vault
end

@testset "Test vault with harder string matching patterns" begin
    vaultdir = joinpath(pwd(), "data", "customjsvault")
    v = Vault(vaultdir)
    @test v isa Vault

    wnames = wikinames(v)
    @test length(wnames) == 4
    for wname in ["Hammond letter 7", "Stephen Ayres", "Will of Stephen Ayres", "intro"]
        @test wname in wnames
    end
end