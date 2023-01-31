@testset "Test parsing YAML strings" begin
    yamlfile = joinpath(pwd(), "data", "conf.yaml")
    yaml = read(yamlfile) |> String
    parse1 = YAML.load_file(yamlfile)
    parse2 = Obsidian.parseyaml(yaml)
    @test parse1 == parse2
end

@testset "Test markdown notation" begin
  md = """Basic Field:: Value
  **Bold Field**:: Nice!
  You can also write [field:: inline fields]; multiple [field2:: on the same line].
  If you want to hide the (field3:: key), you can do that too.
  """
  kvpairs = Obsidian.kvfrommd(md)
  @test length(kvpairs) == 5
end

@testset "Test yaml notation" begin
  yaml = """alias: "document"
last-reviewed: 2021-08-17
thoughts:
  rating: 8
  reviewable: false
tags: 
  - t1 
  - t2 
"""
  kvpairs = Obsidian.kvfromyaml(yaml)
  @test length(kvpairs) == 3
end

