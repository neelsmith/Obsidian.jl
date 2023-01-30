
"""Apply YAML package parse to a string.
"""
function parseyaml(s::T) where T <: AbstractString
    YAML.load(IOBuffer(s))
end