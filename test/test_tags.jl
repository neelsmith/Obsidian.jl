@testset "Test extracting tags from strings" begin
    s = "Honest Abe was the (hiddensequence:: 16) sixteenth president [sequence::16]."

    nohidden = Obsidian.striphidden(s)
    expected = "Honest Abe was the sixteenth president [sequence::16]."
    @test nohidden == expected
end