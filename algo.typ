// Original: 
//
// SPDX-FileCopyrightText: 2023 Jade Lovelace
//
// SPDX-License-Identifier: MIT

#let iflike_block(kw1: "", kw2: "", cond: "", ..body) = (
  ([#strong(kw1) #cond #strong(kw2)]),
  (change_indent: 2, body: body.pos()),
)

#let function_like(name, kw: "function", args: (), ..body) = iflike_block(
  kw1: kw,
  cond: (smallcaps(name) + "(" + args.join(", ") + ")"),
  ..body,
)

#let listify(v) = {
  if type(v) == list {
    v
  } else {
    (v, )
  }
}

#let Function = function_like.with(kw: "function")
#let Procedure = function_like.with(kw: "procedure")

#let State(block) = ((body: block), )
#let S = State

/// Inline call
#let CallI(name, args) = smallcaps(name) + "(" + listify(args).join(", ") + ")"
#let Call(..args) = (CallI(..args), )
#let FnI(f, args) = strong(f) + " (" + listify(args).join(", ") + ")"
#let Fn(..args) = (FnI(..args), )
#let Ic(c) = sym.triangle.stroked.r + " " + c
#let Cmt(c) = (Ic(c), )
// It kind of sucks that Else is a separate block but it's fine
#let If = iflike_block.with(kw1: "if", kw2: "then")
#let While = iflike_block.with(kw1: "while", kw2: "do")
#let For = iflike_block.with(kw1: "for", kw2: "do")
#let Assign(var, val) = ([#var $<-$ #val], )

#let Else = iflike_block.with(kw1: "else")
#let ElsIf = iflike_block.with(kw1: "else if", kw2: "then")
#let ElseIf = ElsIf
#let Return(arg) = ([*return* #arg], )

/*
 * Generated AST:
 * (change_indent: int, body: ((ast | content)[] | content | ast)
 */
#let ast_to_content_list(indent, ast) = {
  if type(ast) == array {
    ast.map(d => ast_to_content_list(indent, d))
  } else if type(ast) == dictionary {
    let new_indent = ast.at("change_indent", default: 0) + indent
    ast_to_content_list(new_indent, ast.body)
  } else {
    (pad(left: indent * 1em, ast), )
  }
}

#let pseudocode(input: none, output: none, ..bits) = {
  if input != none or output != none {
    block(inset: (left: 0.5em, top: 0.2em), below: 0.5em, {
      if input != none [
        *Input:* #input
        #linebreak()
      ]
      if output != none [
        *Output:* #output
        #linebreak()
      ]
    })
  }

  let content = bits.pos().map(b => ast_to_content_list(0, b)).flatten()
  let table_bits = for lineno in range(content.len()) {
    ([#{ lineno + 1 }:], content.at(lineno))
  }

  table(
    columns: (18pt, 100%),
    // line spacing
    inset: 0.3em,
    stroke: none,
    ..table_bits
  )
}

#let algorithm = figure.with(kind: "algo", supplement: "Algorithm")

#let setup-algo(
  line-number-style: text.with(size: .7em),
  line-number-supplement: "Line",
  body,
) = {
  show ref: it => {
    if it.element != none and it.element.func() == figure and it.element.kind == "algo-line-no" {
      link(it.element.location(), { line-number-supplement; sym.space; it.element.body })
    } else {
      it
    }
  }
  show figure.where(kind: "algo-line-no"): it => line-number-style(it.body)
  show figure.where(kind: "algo"): it => {
    let booktabbed = block(
      stroke: (y: 1.3pt),
      inset: 0pt,
      breakable: true,
      width: 100%,
      {
        set align(left)
        block(
          inset: (y: 5pt),
          width: 100%,
          stroke: (bottom: .8pt),
          {
            strong({
              it.supplement
              sym.space.nobreak
              counter(figure.where(kind: "algo")).display(it.numbering)
              [: ]
            })
            it.caption.body
          },
        )
        block(
          inset: (bottom: 5pt),
          above: 0.2em,
          breakable: true,
          it.body,
        )
      },
    )
    let centered = pad(booktabbed)
    if it.placement in (auto, top, bottom) {
      place(it.placement, float: true, centered)
    } else {
      centered
    }
  }

  body
}
