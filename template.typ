#import "cody.typ": *

#let __font-serif = "Libertinus Serif"
#let fonts = (
  primary: (__font-serif, "SimSun"),
  strong: (__font-serif, "SimHei"),
  emph: (__font-serif, "STKaiti"),
)

#let project(title: "", body) = {
  // Set the document's basic properties.
  set document(author: (), title: title)
  set page(numbering: "1", number-align: center)

  set text(font: fonts.primary, lang: "en")

  set block(spacing: 0.7em)

  set math.equation(numbering: "(1)")

  show link: set text(fill: blue)

  show heading: set text(font: fonts.strong)
  show heading.where(level: 3): set block(above: 1em)

  show strong: text.with(font: fonts.strong)
  show emph: text.with(font: fonts.emph, fill: red.darken(10%))

  show math.lt.eq: math.lt.eq.slant
  show math.gt.eq: math.gt.eq.slant

  // Title row.
  block(width: 100%, stroke: 1pt + purple.lighten(20%), fill: purple.lighten(90%), radius: 4pt, outset: 8pt)[
    #align(center, text(weight: 700, 1.75em, font: fonts.strong, fill: purple.darken(20%), title))
  ]

  // Main body.
  set par(justify: false)

  set table(stroke: 0.5pt)

  import "cody.typ": raw-style
  show: raw-style

  body

  place(bottom + right, text(size: 8pt, "Powered by Typst.", fill: gray))
}

#let assignment-style(doc) = {
  show heading.where(level: 1): set text(fill: blue)
  show heading.where(level: 2): set text(size: 13pt, fill: orange)
  show heading.where(level: 3): it => {
    let a = counter(heading)
    counter(heading).display()
    " "
    text(weight: "regular", font: fonts.primary, it.body)
  }

  set heading(numbering: (..nums) => {
    let a = nums.pos()
    if a.len() > 2 { numbering("1.a.", ..a.slice(2)) }
  })

  set enum(numbering: "1.a)")

  doc
}

#let solution-style(doc) = {
  let h1-box(body) = {
    block(width: 100%, fill: blue.lighten(90%), stroke: (left: 3pt + blue.lighten(30%)), inset: 4pt, outset: 4pt, radius: (left: 4pt), below: 12pt, body)
  }
  
  let h2-box(inset: 6pt, outset: 10pt, bar-space: 2pt, bar-width: 3pt, body) = {
    let ist = if type(inset) == dictionary { inset.top }    else { inset }
    let isb = if type(inset) == dictionary { inset.bottom } else { inset }
    let isl = if type(inset) == dictionary { inset.left }   else { inset }
    let isr = if type(inset) == dictionary { inset.right }  else { inset }
    style(styles => {
      let size = measure(body, styles)
      block(above: 8pt, below: 8pt)[
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
    })
  }
  
  show heading.where(level: 1): it => {
    set text(fill: blue)
    h1-box(it)
  }
  show heading.where(level: 2): it => {
    set text(fill: eastern)
    h2-box(it)
  }

  set enum(numbering: "1.a.i.")
  
  doc
}
