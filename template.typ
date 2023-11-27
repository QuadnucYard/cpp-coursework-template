#import "@preview/codelst:1.0.0": sourcecode

#let project(title: "", body) = {
  // Set the document's basic properties.
  set document(author: (), title: title)
  set page(numbering: "1", number-align: center)

  set text(font: ("Linux Libertine", "Times New Roman", "SimSun", "SimHei"), lang: "en")
	show raw: set text(font: ("DejaVu Sans Mono", "Sarasa Mono SC"))
  // set heading(numbering: "1.1")
   
  // Title row.
  block(width: 100%, stroke: 1pt + purple.lighten(20%), fill: purple.lighten(90%), radius: 4pt, outset: 8pt)[
    #align(center, text(weight: 700, 1.75em, font: ("Linux Libertine", "SimHei"), fill: purple.darken(20%), title))
  ]
  
   
  // Main body.
  set par(justify: false)
   
  set math.equation(numbering: "(1)")

  show link: set text(fill: blue)

  show emph: text.with(font: ("Linux Libertine", "STKaiti"), fill: red)

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
  show heading: it => block(width: 100%)[
    #text(it.body, weight: "bold", font: ("Linux Libertine", "SimHei"))
  ]

  show heading.where(level: 1): it => block(width: 100%)[
    #text(fill: blue, it.body, weight: "bold", font: "SimHei")
  ]

  show heading.where(level: 2): it => block(width: 100%)[
    #text(it.body, size: 13pt, fill: orange, font: ("Linux Libertine", "SimHei"))
  ]

  set enum(numbering: "1.a)")
  
  doc
}

#let solution-style(doc) = {

  let h1-box(body) = {
    block(width: 100%, fill: blue.lighten(90%), stroke: (left: 3pt + blue.lighten(30%)), inset: 4pt, outset: 4pt, radius: (left: 4pt), body)
    v(4pt)
  }
  
  let h2-box(inset: 6pt, outset: 10pt, bar-space: 2pt, bar-width: 3pt, body) = {
    let ist = if type(inset) == dictionary { inset.top }    else { inset }
    let isb = if type(inset) == dictionary { inset.bottom } else { inset }
    let isl = if type(inset) == dictionary { inset.left }   else { inset }
    let isr = if type(inset) == dictionary { inset.right }  else { inset }
    style(styles => {
      let size = measure(body, styles)
      v(-8pt)
      block()[
        #stack(dir: ltr, spacing: bar-space,
          polygon(
            fill: eastern.lighten(80%),
            (-2pt, 0pt),
            (-2pt, size.height + 2 * inset),
            (size.width + 2 * inset + 10pt, size.height + 2 * inset),
            (size.width + 2 * inset, 0pt)
          ),
          polygon(
            fill: eastern.lighten(60%),
            (-10pt, 0pt),
            (0pt, size.height + 2 * inset),
            (0pt + bar-width, size.height + 2 * inset),
            (-10pt + bar-width, 0pt)
          )
        )
        #place(left + top, dy: inset, dx: inset, body)
      ]
      v(-2pt)
    })
  }
  
  show heading.where(level: 1): it => h1-box(text(fill: blue, it.body))
  show heading.where(level: 2): it => {
    // block(width: 100%, stroke: (top: 1.5pt + gradient.linear(eastern, white, white), bottom: 1.5pt + gradient.linear(eastern, white), left: 1.5pt + eastern), inset: 4pt, outset: 2pt, text(fill: eastern, it.body))
    // text(fill: eastern, it.body)
    h2-box(text(fill: eastern, it.body))
  }

  set enum(numbering: "1.a.i.")
  
  doc
}


#let codify(body) = {
  set raw(lang: "cpp")
  body
  set raw(lang: none)
}

#let codeblock(text, start: none, end: none, count: none) = {
  let a = text.split("\n")
  if end != none {
    a = a.slice(0, end)
  }
  if start != none {
    a = a.slice(start - 1)
  }
  if count != none {
    a = a.slice(0, count)
  }
  text = a.join("\n")
	raw(text, block: true, lang: "cpp")
}
