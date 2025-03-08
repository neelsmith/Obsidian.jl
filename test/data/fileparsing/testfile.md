Last name: [[Neel]]

## Notes

Son of [[James Marion Neel]] and [[Luesey Clementine Neel]]

He married [[Lydia Ruth Yell]] and they had many children


## Claims

```dataviewjs
dv.el("h3", "Assertions about birth")
let page = dv.current()
let assertions = []

for (let pg of dv.pages()) {
	if (pg.birth) {
		for (ln of pg.birth) {
			let cols = ln.split("|")
			if (cols[0] == "[[" + page.file.name + "]]")  {
				assertions.push(cols)
			}
		}
	}
}
if (assertions.length == 0) {
	dv.el("li", "No claims about birth recorded.")
} else {
	dv.table(
	["Date", "Place", "Source", "Assertion"],
	assertions.map(row => [row[1], row[2], row[3], row[4]])
	);
}
```




