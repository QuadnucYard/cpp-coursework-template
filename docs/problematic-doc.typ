#{
  import "@preview/tidy:0.2.0"
  import "../problematic.typ"
  let my-module = tidy.parse-module(read("../problematic.typ"), name: "problematic", scope: (problematic: problematic))
  tidy.show-module(my-module, sort-functions: none)
}
