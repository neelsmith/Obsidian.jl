# Navigation


```@setup nav
using Obsidian
root = pwd() |> dirname |> dirname
vaultdir = joinpath(root, "test", "data", "presidents-vault")
v = Vault(vaultdir)
```

Using the same test vault created on the introductory page, find the full path to the page with wiki name "Abraham Lincoln":

```@example nav
path(v, "Abraham Lincoln")
```


Find links occuring on the page with wiki name "Abraham Lincoln" (that is, links outgoing from "Abraham Lincoln"):

```@example nav
linkson(v, "Abraham Lincoln")
```

Find pages that link to "Abraham Lincoln" (that is, links incoming to "Abraham Lincoln"):

```@example nav
linkedto(v, "Abraham Lincoln")
```

Find tags labelling the page "Abraham Lincoln":

```@example nav
tags(v, "Abraham Lincoln")
```

Find pages tagged `#president`:


```@example nav
tagged(v, "#president")
```
