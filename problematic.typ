// problematic

/// Make the body raw.
///
/// *Examples:*
///
/// - ```typst #ensure-raw("114514", block: true)``` \
///   #ensure-raw("114514", block: true)
/// - ```typst #ensure-raw("114514", block: false)``` \
///   #ensure-raw("114514", block: false)
/// - ```typst #ensure-raw(`114514`, block: true)``` \
///   #ensure-raw(`114514`, block: true)
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
/// - ```typst #extract-raw(`something`)``` \
///   #extract-raw(`something`)
/// - ```typst #extract-raw("anything")``` \
///   #extract-raw("anything")
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
/// #test-cases(`1 2 3`, `A`, `4 5`, `B`)
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
/// #sample(`114 514`, `1919810`, num: 1, ratio: 40%)
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


#{
  import "cody.typ": raw-style
  show: raw-style

  import "@preview/tidy:0.1.0"
  let my-module = tidy.parse-module(read("problematic.typ"), name: "problematic", scope: (ensure-raw: ensure-raw, extract-raw: extract-raw, test-cases: test-cases, sample: sample))
  tidy.show-module(my-module)
}
