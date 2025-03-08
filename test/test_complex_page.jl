@testset "Test complex page" begin
    testroot = pwd()
    v = Vault(joinpath(testroot, "data", "syrena"))
    syrena = "Syrena Adams"
    allpagelinks = linkson(v, syrena)
end