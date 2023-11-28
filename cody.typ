// cody.typ

/// Add boxes to raw contents.
///
/// - doc (any): The document.
/// -> content
#let raw-style(doc) = {
  import "@preview/codelst:1.0.0": sourcecode

  show raw: set text(font: ("DejaVu Sans Mono", "Sarasa Mono SC"))

  show raw.where(block: true): it => {
    if it.lang == none {
      block(width: 100%, radius: 2pt, fill: rgb("#f8f8f8"), stroke: 0.5pt + rgb("#ddd"), inset: 0.5em, it)
    } else {
      sourcecode(it)
    }
  }
  show raw.where(block: false): it => box(inset: (left: 0.2em, right: 0.2em), box(radius: 2pt, fill: rgb(50%, 50%, 50%, 10%), outset: 0.2em, it))

  doc
}

/// Make raw contents have the default language.
///
/// - lang (string): The language.
/// -> content
#let codify(body, lang: "cpp") = {
  set raw(lang: lang)
  body
}

/// Make a code block from text slice.
///
/// - start (integer none): The start line (from 1). If none, slice from the first line.
/// - end (integer none): The end line (from 1). If none, slice to the last line.
/// - count (integer none): Number of lines from start. If none, all lines will be kept.
/// - lang (string): The language to use.
/// -> content
#let codeblock(text, start: none, end: none, count: none, lang: "cpp") = {
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
	raw(text, block: true, lang: lang)
}

#{
  import "@preview/tidy:0.1.0"
  let my-module = tidy.parse-module(read("cody.typ"), name: "cody")
  tidy.show-module(my-module)
}
