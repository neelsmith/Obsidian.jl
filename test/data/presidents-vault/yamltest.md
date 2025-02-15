---
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
---


```dataview
TABLE obj.key1, obj.key2, obj.key3 WHERE file = this.file
WHERE file = this.file
```
