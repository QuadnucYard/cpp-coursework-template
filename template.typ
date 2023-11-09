#import "@preview/codelst:1.0.0": sourcecode

// #let states = (lst-disabled: false)

#let project(title: "", body) = {
  // Set the document's basic properties.
  set document(author: (), title: title)
  set page(numbering: "1", number-align: center)

  set text(font: ("Linux Libertine", "Times New Roman", "SimSun", "SimHei"), lang: "en")
	show raw: set text(font: ("DejaVu Sans Mono", "Sarasa Mono SC"))
  // set heading(numbering: "1.1")
   
  // Title row.
  align(center)[
    #block(text(weight: 700, 1.75em, title, font: ("Linux Libertine", "Times New Roman", "SimHei")))
  ]
   
  // Main body.
  set par(justify: false)
   
  set math.equation(numbering: "(1)")

  show link: set text(fill: blue)

	set table(stroke: 0.5pt)

	show raw: it => {
		if not it.has("block") {
			it
		} else if it.block {
			if it.lang != none {
				sourcecode(it)
			} else {
				block(width: 100%, radius: 2pt, fill: rgb("#f8f8f8"), stroke: 0.5pt + rgb("#ddd"), inset: 0.5em, it)
			}
		} else {
			box(inset: (left: 0.2em, right: 0.2em), box(radius: 2pt, fill: rgb(50%, 50%, 50%, 10%), outset: 0.2em, it))
		}	
	}
   
  body

  place(bottom + right, text(size: 8pt, "Powered by Typst.", fill: gray))
}

#let assignment-style(doc) = {
  show heading.where(level: 1): it => block(width: 100%)[
    #text(fill: blue, it.body, weight: "bold", font: "SimHei")
  ]

  show heading.where(level: 2): it => block(width: 100%)[
    #text(it.body, size: 13pt, fill: orange)
  ]

  show emph: text.with(font: ("Linux Libertine", "STKaiti"), fill: red)

  set enum(numbering: "1.a)")
  
  doc
}

#let solution-style(doc) = {
  show heading.where(level: 1): it => block(width: 100%)[
    #overline(offset: -1em, extent: 4pt, text(fill: blue, it.body))
  ]
  show heading.where(level: 2): it => block(width: 100%)[
    #text(fill: eastern, it.body)
  ]
  
  doc
}


#let codify(body) = {
  set raw(lang: "cpp")
  body
  set raw(lang: none)
}

#let codeblock(text, start: none, count: none) = {
  let a = text.split("\n")
  if start != none {
    a = a.slice(start - 1)
  }
  if count != none {
    a = a.slice(0, count)
  }
  text = a.join("\n")
	raw(text, block: true, lang: "cpp")
}

// #let lst-disable() = { states.lst-disabled = true; }
// #let lst-enable() = { states.lst-disabled = false; }