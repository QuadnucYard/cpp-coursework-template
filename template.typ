#import "cody.typ": *
#import "font.typ": fonts

#let indent = h(2em)

#let unindent = h(-2em)

#let fake_par = {
  v(-1em)
  box()
}

#let indent-state = state("indent", false)

#let make-style(
  leading: 0.8em,
  justify: false,
  first-line-indent: true,
) = (
  leading: leading,
  justify: justify,
  first-line-indent: if first-line-indent { 2em } else { 0pt },
)

#let project(
  title: "",
  body,
) = {
  // Set the document's basic properties.
  set document(author: (), title: title)
  set page(numbering: "1", number-align: center)

  set text(font: fonts.primary, lang: "en")

  set block(spacing: 0.7em)

  set math.equation(numbering: "(1)")

  show link: set text(fill: blue)

  show heading: set text(font: fonts.strong)
  show strong: text.with(font: fonts.strong)
  show emph: text.with(font: fonts.emph, fill: red.darken(10%))

  show math.lt.eq: math.lt.eq.slant
  show math.gt.eq: math.gt.eq.slant

  // Title row.
  block(width: 100%, stroke: 1pt + purple.lighten(20%), fill: purple.lighten(90%), radius: 4pt, outset: 8pt, below: 2.0em)[
    #align(center, text(weight: 700, 1.75em, font: fonts.strong, fill: purple.darken(20%), title))
  ]

  // Main body.
  set table(stroke: 0.5pt)

  import "cody.typ": raw-style
  show: raw-style

  body

  place(bottom + right, text(size: 8pt, "Proudly powered by Typst 11.0", fill: gray))
}

#let check-indent(doc, par-style) = {
  set par(..par-style)
  if par-style.at("first-line-indent", default: 0pt) > 0pt {
    indent-state.update(true)
    show heading: it => {
      it
      fake_par
    }
    doc
  } else {
    doc
  }
}

#let assignment-style(doc, par-style: make-style()) = {
  set enum(numbering: "1.a)")

  show heading.where(level: 1): set text(size: 14pt, fill: blue)
  show heading.where(level: 1): set block(above: 1.0em, below: 1.0em)

  show heading.where(level: 2): set text(size: 13pt, fill: orange.darken(10%))
  show heading.where(level: 2): set block(above: 1.0em, below: 1.0em)

  show heading.where(level: 3): set text(size: 12pt, fill: eastern.darken(10%))
  show heading.where(level: 3): set block(above: 1.0em, below: 1.0em)

  show heading.where(level: 4): set text(fill: olive.darken(10%))
  show heading.where(level: 4): set block(above: 1.0em, below: 1.0em)

  check-indent(doc, par-style)
}

#let solution-style(doc, par-style: make-style()) = {
  let h1-box = block.with(width: 100%, fill: blue.lighten(90%), stroke: (left: 3pt + blue.lighten(30%)), inset: 4pt, outset: 4pt, radius: (left: 4pt), below: 12pt)

  let h2-box(inset: 6pt, outset: 10pt, bar-space: 2pt, bar-width: 3pt, body) = {
    let ist = if type(inset) == dictionary { inset.top } else { inset }
    let isb = if type(inset) == dictionary { inset.bottom } else { inset }
    let isl = if type(inset) == dictionary { inset.left } else { inset }
    let isr = if type(inset) == dictionary { inset.right } else { inset }
    context {
      let size = measure(body)
      block(above: 8pt, below: 8pt)[
        #stack(
          dir: ltr,
          spacing: bar-space,
          polygon(fill: eastern.lighten(80%), (-2pt, 0pt), (-2pt, size.height + 2 * inset), (size.width + 2 * inset + 10pt, size.height + 2 * inset), (size.width + 2 * inset, 0pt)),
          polygon(fill: eastern.lighten(60%), (-10pt, 0pt), (0pt, size.height + 2 * inset), (0pt + bar-width, size.height + 2 * inset), (-10pt + bar-width, 0pt)),
        )
        #place(left + top, dy: inset, dx: inset, body)
      ]
    }
  }
  show heading.where(level: 1): it => {
    set text(fill: blue, font: fonts.strong)
    h1-box(it.body)
  }
  show heading.where(level: 2): it => {
    set text(fill: eastern, font: fonts.strong)
    h2-box(it.body)
  }
  show heading.where(level: 3): it => {
    set block(above: 1.0em)
    it
  }

  set enum(numbering: "1.a.i.")

  check-indent(doc, par-style)
}
