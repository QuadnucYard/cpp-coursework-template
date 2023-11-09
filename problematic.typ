
#let test-cases(..cases) = {
	let a = cases.pos()
	a = a.map(t => {
		if type(t) == "content" and t.func() == raw {
			let f = t.fields()
			f.insert("block", true)
			f.remove("text")
			return raw(t.text, ..f)
		}
	})
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

#let sample(input, output, num: none) = {
	let postfix = if num != none { " #" + str(num) } else { "" };
	table(
		columns: (50%, 50%),
		stroke: none,
		{ strong("Sample input" + postfix) },
		{ strong("Sample output" + postfix) },
		input,
		output,
	)
}

#let ensure-raw(content) = {
  if type(content) == str {
    raw(content)
  } else {
    content
  }
}
#let extract-raw(s) = {
  if type(s) == content and s.has("text") {
    s.text
  } else {
    s
  }
}

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