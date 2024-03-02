#import "template.typ": codify
#import "@preview/showybox:2.0.1": showybox

#let __msgbox(body, title, code, frame) = {
  let content = showybox(frame: frame, title: strong(title), breakable: true, body)
  if code { codify(content) } else { content }
}

#let wrong-answer(body, title: "Typical wrong answers", code: true) = {
  __msgbox(body, title, code, (
    border-color: red.darken(20%),
    title-color: red.lighten(10%),
    body-color: red.lighten(95%),
    footer-color: red.lighten(80%),
  ))
}

#let warning(body, title: "Warning", code: true) = {
  __msgbox(body, title, code, (
    border-color: yellow.darken(20%),
    title-color: yellow.darken(10%),
    body-color: yellow.lighten(95%),
    footer-color: yellow.lighten(80%),
  ))
}

#let tip(code: true, title: "Tip", body) = {
  __msgbox(body, title, code, (
    border-color: blue,
    title-color: blue.lighten(30%),
    body-color: blue.lighten(95%),
    footer-color: blue.lighten(80%),
  ))
}

#let info(code: true, title: "Info", body) = {
  __msgbox(body, title, code, (
    border-color: gray,
    title-color: gray.lighten(30%),
    body-color: gray.lighten(95%),
    footer-color: gray.lighten(80%),
  ))
}

#let note(code: true, title: "Note", body) = {
  __msgbox(body, title, code, (
    border-color: green,
    title-color: green.lighten(20%),
    body-color: green.lighten(95%),
    footer-color: green.lighten(80%),
  ))
}

#let study-case(first, second) = {
  let cnt = counter("study-case")
  cnt.step()
  block(width: 100%, fill: maroon.lighten(80%), inset: 8pt, radius: (top: 4pt), {
    strong([Case #cnt.display()])
    first
  })
  block(width: 100%, fill: olive.lighten(80%), inset: 8pt, radius: (bottom: 4pt), above: 0pt, {
    strong([Analysis #cnt.display()])
    second
  })
}
