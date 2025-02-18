@testset "Test stripping Obsidian tags" begin
    notags = """
## Transcription

Burlington July 17 1842 About 3 oclock pm.
"""
    @test Obsidian.striptags(notags) == notags
end