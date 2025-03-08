@testset "Test complex page" begin
    testroot = pwd()
    v = Vault(joinpath(testroot, "data", "syrena"))
    syrena = "Syrena Adams"
    allpagelinks = linkson(v, syrena) |> sort
    expected = ["Adams",
    "Elizabeth Stagg",
    "Friend Adams",
    "Panton, Adams Ferry Cemetery",
    "Syrena Adams overview",
    "White"]

    @test allpagelinks == expected 
end