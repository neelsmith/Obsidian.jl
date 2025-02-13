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

```dataviewjs
dv.el("h3", "Assertions about death")
let page = dv.current()
let assertions = []

for (let pg of dv.pages()) {
	if (pg.death) {
		for (ln of pg.death) {
			let cols = ln.split("|")
			if (cols[0] == "[[" + page.file.name + "]]")  {
				assertions.push(cols)
			}
		}
	}
}
if (assertions.length == 0) {
	dv.el("li", "No claims about death recorded.")
} else {
	dv.table(
	["Date", "Place", "Source", "Assertion"],
	assertions.map(row => [row[1], row[2], row[3], row[4]])
	);
}
```


```dataviewjs
dv.el("h3", "Assertions about parents")
let page = dv.current()
let assertions = []

for (let pg of dv.pages()) {
	if (pg.parents) {
		for (ln of pg.parents) {
			let cols = ln.split("|")
			if (cols[0] == "[[" + page.file.name + "]]")  {
				assertions.push(cols)
			}
		}
	}
}
if (assertions.length == 0) {
	dv.el("li", "No claims about parents recorded.")
} else {
	dv.table(
	["Father", "Mother", "Source", "Assertion"],
	assertions.map(row => [row[1], row[2], row[3], row[4]])
	);
}

```



```dataviewjs
dv.el("h3", "Assertions about marriages")
let page = dv.current()
let pglink = "[[" + page.file.name + "]]"
let assertions = []

for (let pg of dv.pages()) {
	if (pg.marriage) {
		for (ln of pg.marriage) {
			let cols = ln.split("|")
			if (cols[0] == pglink || cols[1] == pglink) {
				assertions.push(cols)
			}
		}
	} 
}

if (assertions.length == 0) {
	dv.el("li", "No claims about marriages recorded.")
} else {
	dv.table(
	["Husband", "Wife", "Date", "Place", "Source"],
	assertions.map(row => [row[0], row[1], row[2], row[3], row[4]])
	);
}
```


```dataviewjs
dv.el("h3", "Assertions about location")
let page = dv.current()
let assertions = []

for (let pg of dv.pages()) {
	if (pg.where) {
		for (ln of pg.where) {
			let cols = ln.split("|")
			if (cols[0] == "[[" + page.file.name + "]]")  {
				assertions.push(cols)
			}
		}
	}
}
if (assertions.length == 0) {
	dv.el("li", "No claims about location recorded.")
} else {
	dv.table(
	["Date", "Place", "Source", "Assertion"],
	assertions.map(row => [row[1], row[2], row[3], row[4]])
	);
}
```


```dataviewjs
dv.el("h3", "Assertions about occupation")

let page = dv.current()
let assertions = []

for (let pg of dv.pages()) {
	if (pg.occupation) {
		for (ln of pg.occupation) {
			let cols = ln.split("|")
			if (cols[0] == "[[" + page.file.name + "]]")  {
				assertions.push(cols)
			}
		}
	}
}

if (assertions.length == 0) {
	dv.el("li", "No claims about occupation recorded.")
} else {
	dv.table(
	["Occupation", "Date", "Place", "Source", "Assertion"],
	assertions.map(row => [row[1], row[2], row[3], row[4], row[5]])
	);
}
```


```dataviewjs
dv.el("h2", "Sources")
let page = dv.current();

let srclist = []
for (let pg of  dv.pages('"transcriptions"')) {
	if (pg.refersto === undefined || pg.refersto === null) {
		//console.log("No ref " + pg.file.name)
	} else if (dv.isArray(pg.refersto)) {
		//console.log("ARRAY  of reff: " + pg.refersto.length)
		for (let ref of pg.refersto) {
			if (ref.fileName === undefined) {
				dv.paragraph("(Badly formatted `refersto` tag: " + pg.refersto + ")")
			} else if (ref.fileName() == page.file.name) {
				srclist.push(pg)		
			}
		}
	} else if (pg.refersto.fileName() == page.file.name) {
		srclist.push(pg)		
	}
}

if (srclist.length == 0) {
	dv.paragraph("No sources found for " + page.file.name)
} else {
	dv.list(srclist.map(src => src.file.link))
}
```



