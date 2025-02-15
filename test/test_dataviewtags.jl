
@testset "Test removing hidden, visible, and line-initial inline tags" begin
    @test_broken 1 == 2
end

@testset "Test extracting tags from strings" begin
    s = "Honest Abe was the (hiddensequence:: 16) sixteenth president [sequence::16]."

    nohidden = Obsidian.stripdvtags(s)
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


    kvlist =  Obsidian.kvfromyaml(yamlstring)
    @test length(kvlist) == 1
    complextag = kvlist[1]
    @test complextag.k == "obj"
    @test complextag.v isa Dict
    @test length(complextag.v) == 3
    expectedkeys  = [ "key1", "key2", "key3"]
    for k in keys(complextag.v)
        @test k in expectedkeys
    end

    @test complextag.v["key1"] == "Val"
    @test complextag.v["key2"] == 3
    @test complextag.v["key3"] == ["List1", "List2", "List3"]


end