@testset "Test extracting tags from strings" begin
    s = "Honest Abe was the (hiddensequence:: 16) sixteenth president [sequence::16]."

    nohidden = Obsidian.striphidden(s)
    expected = "Honest Abe was the sixteenth president [sequence::16]."
    @test nohidden == expected


    stags = Obsidian.kvfrommd(s)
    @test length(stags) == 2
    @test (k = "sequence", v = "16") in stags
    @test (k = "hiddensequence", v = "16") in stags
end


