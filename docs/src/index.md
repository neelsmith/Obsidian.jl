
```@setup intro
root = pwd() |> dirname |> dirname
```



# Obsidian.jl

You can construct a `Vault` from a directory in your file system.

We've predefined the variable `root` to point to the base directory of this repository, and will use a sample Obsidian vault in its `test/data` directory.

```@example intro
basename(root)
```

```@example intro
vaultdir = joinpath(root, "test", "data", "presidents-vault")
isdir(vaultdir)
```

```@example intro
using Obsidian
v = Vault(vaultdir)
v isa Vault
```