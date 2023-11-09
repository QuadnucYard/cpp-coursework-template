#import "template.typ": codify
#import "@preview/showybox:2.0.1": showybox

#let wrong-answer(body, title: "Typical wrong answers", code: true) = {
	let content = showybox(
		frame: (
			border-color: red.darken(20%),
			title-color: red.lighten(10%),
			body-color: red.lighten(95%),
			footer-color: red.lighten(80%)
		),
		title: strong(title),
		breakable: true,
		body
	)
  if code { codify(content) } else { content }
}

#let warning(body, title: "Warning", code: true) = {
  let content = showybox(
		frame: (
			border-color: yellow.darken(20%),
			title-color: yellow.darken(10%),
			body-color: yellow.lighten(95%),
			footer-color: yellow.lighten(80%)
		),
		title: strong(title),
		breakable: true,
		body
	)
	if code { codify(content) } else { content }
}

#let tip(code: true, title: "Tip", body) = {
	let content = showybox(
		frame: (
			border-color: blue,
			title-color: blue.lighten(30%),
			body-color: blue.lighten(95%),
			footer-color: blue.lighten(80%)
		),
		title: strong(title),
		breakable: true,
		body
	)
	if code { codify(content) } else { content }
}

#let info(code: true, title: "Info", body) = {
	let content = showybox(
		frame: (
			border-color: gray,
			title-color: gray.lighten(30%),
			body-color: gray.lighten(95%),
			footer-color: gray.lighten(80%)
		),
		title: strong(title),
		breakable: true,
		body
	)
	if code { codify(content) } else { content }
}
