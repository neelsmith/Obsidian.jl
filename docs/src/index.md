# Obsidian.jl

Construct a `Vault` from a directory.

```@setup intro
root = pwd() |> dirname |> dirname
```
```@example intro
vaultdir = joinpath(root, "test", "data", "presidents-vault")
```

```@example intro
using Obsidian
v = Vault(vaultdir)
v isa Vault
```