import "io" for File
import "wren-assert/assert" for Assert

import "./parser" for Parser

Assert.doesNotAbort(Fn.new {
  var css = File.read("css/test 1.css")
  Parser.new().parse(css)
})
