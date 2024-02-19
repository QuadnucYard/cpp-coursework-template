// problematic

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
/// - ..cases (string, raw): Input and output alternate. If is `raw`, it will be ensured block.
/// -> content
#let test-cases(..cases) = {
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
    [*Case*], [*Sample input*], [*Sample output*],
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
  ..cases
  ) = {
  test-cases(
    ..for case in cases.pos() {
      (ensure-raw(case), ensure-raw(solver(..input(case.text))))
    }
  )
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
  table(
    columns: range(columns).map(t => 100% / columns),
    stroke: none,
    ..for i in range(children.pos().len()) {
      ([#{str.from-unicode(65 + i) + ". "}#children.pos().at(i)],)
    }
  )
}

#let choice-placer = underline("        ")

#{
  import "cody.typ": raw-style
  show: raw-style

}

/// Put an underline to hold choices
///
/// *Example:*
///
/// #example(`problematic.choice-placer`)
///
/// -> content
#let choice-placer = "______"
