@testset "Test extracting tags from strings" begin
    s = "Honest Abe was the (hiddensequence:: 16) sixteenth president [sequence::16]."

    nohidden = Obsidian.striphidden(s)
    expected = "Honest Abe was the sixteenth president [sequence::16]."
    @test nohidden == expected


    stags = Obsidian.kvfrommd(s)
    @test length(stags) == 2
    @test (k = "sequence", v = "16") in stags
    @test (k = "hiddensequence", v = "16") in stags

    initialtag = "**Bold Field**:: Nice!"
    @test Obsidian.kvfrommd(initialtag) == [(k = "**Bold Field**", v = "Nice!")]
end


@testset "Test extracting tags from YAML strings" begin
yamlstring = """
obj: 
    key1: "Val" 
    key2: 3 
    key3: 
        - "List1" 
        - "List2" 
        - "List3"
tags: 
    - dataview
    - testing
"""

    taglist = Obsidian.yamltags(yamlstring)
    @test taglist == ["#dataview", "#testing"]

end