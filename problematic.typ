// problematic
#import "font.typ": fonts

/// Make the body raw.
///
/// *Examples:*
///
/// #example(`problematic.ensure-raw("114514", block: true)`)
/// #example(`problematic.ensure-raw("114514", block: false)`)
/// #example(``` problematic.ensure-raw(`114514`, block: true)```)
///
/// - body (string, raw): Some text
/// - block (boolean): Whether to force `block = true`.
/// -> content
#let ensure-raw(body, block: true) = {
  if type(body) == str {
    return raw(body, block: block)
  } else if type(body) == content and body.func() == raw {
    if (block and not body.block) {
      let f = body.fields()
      f.insert("block", true)
      f.remove("text")
      return raw(body.text, ..f)
    }
  }
  body
}

/// Extract text from content.
///
/// *Examples:*
///
/// #example(``` problematic.extract-raw(`something`)```)
/// #example(``` problematic.extract-raw("anything")```)
///
/// - s (content, string): Something like content.
/// -> string
#let extract-raw(s) = {
  if type(s) == content and s.has("text") {
    s.text
  } else {
    s
  }
}

/// Show test cases in grid.
///
/// *Example:*
///
/// #example(``` problematic.test-cases(`1 2 3`, `A`, `4 5`, `B`) ```, scale-preview: 100%)
///
/// - columns (integer): A dummy argument for prettypst to correctly align items.
/// - ..cases (string, raw): Input and output alternate. If is `raw`, it will be ensured block.
/// -> content
#let test-cases(columns: 2, ..cases) = {
  let a = cases.pos().map(ensure-raw)
  let content = for i in range(int(a.len() / 2)) {
    (box(inset: (y: 0.4em), str(i + 1)), a.at(i * 2), a.at(i * 2 + 1))
  }
  // [=== Test cases]
  table(
    columns: (30pt, 50% - 15pt, 50% - 15pt),
    align: (center, left, left),
    stroke: none,
    inset: 2pt,
    [*Case*],
    [*Sample input*],
    [*Sample output*],
    ..content
  )
}

/// Show a sample test case.
///
/// *Example:*
///
/// #example(``` problematic.sample(`114 514`, `1919810`, num: 1, ratio: 40%)```, scale-preview: 100%)
///
/// - input (any): Sample input.
/// - output (any): Sample output.
/// - num (integer, none): The serial number of this sample. If none, does not show the number.
/// - ratio (length): The size of left (input) column.
/// -> content
#let sample(input, output, num: none, ratio: 50%) = {
  let postfix = if num != none { " #" + str(num) } else { "" };
  table(
    columns: (ratio, 100% - ratio),
    stroke: none,
    { strong("Sample input" + postfix) },
    { strong("Sample output" + postfix) },
    ensure-raw(input),
    ensure-raw(output),
  )
}

/// Make test cases from input and solver.
///
/// - solver (function): A mapper from input to output.
/// - input (function): A function to process input to feed the solver.
/// - ..cases (string, content): Test cases.
/// -> content
#let make-test-cases(
  solver: s => s,
  input: s => (s, ),
  ..cases,
) = {
  test-cases(
    ..for case in cases.pos() {
      (ensure-raw(case), ensure-raw(solver(..input(case.text))))
    }
  )
}

/// Display a problem as heading
#let problem(body, heading-level: 3) = {
  show heading: set block(above: 0.65em, below: 0.65em)
  heading(level: heading-level, {
    counter("problem").step()
    strong(counter("problem").display("1. "))
    text(weight: "regular", font: fonts.primary, body)
  })
}

/// Display multiple choices
///
/// *Example:*
///
/// #example(``` problematic.choices(columns: 2, [Choice A], [`Choice B`]) ```, scale-preview: 100%)
///
/// - columns (integer): Number of columns.
/// - ..children (content): Contents of choices
/// -> content
#let choices(columns: 2, ..children) = {
  let cnt = counter("choices")
  cnt.update(0)
  table(
    columns: range(columns).map(t => 1fr),
    stroke: none,
    ..for i in range(children.pos().len()) {
      ([#cnt.step() #cnt.display("A. ") #children.pos().at(i)], )
    }
  )
}

/// Put an underline to hold choices
///
/// *Example:*
///
/// #example(`problematic.choice-placer`)
///
/// -> content
#let choice-placer = "______"

#let tag(body, fill: auto) = {
  set text(size: 0.8em, fill.darken(40%))
  box(inset: (left: 3pt, right: 3pt), box(radius: 4pt, outset: 3pt, fill: fill.lighten(75%), body))
}

#let tag-opt = tag(fill: fuchsia)[*选做*]
#let tag-prog = tag(fill: lime)[*编程*]
#let tag-ans = tag(fill: orange)[*简答*]
