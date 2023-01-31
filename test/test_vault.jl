
@testset "Test vault" begin
    v = Vault(joinpath(pwd(), "data", "presidents-vault"))
    @test v isa Vault
end