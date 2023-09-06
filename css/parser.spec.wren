import "io" for File
import "wren-assert/assert" for Assert
import "wren-magpie/magpie" for Magpie, Result

import "./parser" for Grammar, Parser

Assert.aborts(Fn.new { Magpie.parse(Grammar.class_, "div") })
Assert.doesNotAbort(Fn.new {
  var result = Magpie.parse(Grammar.class_, ".faded")
  Assert.equal(result.token, "faded")
})

Assert.doesNotAbort(Fn.new {
  Assert.equal(Result.tags(Magpie.parse(Grammar.selector, "*"))[0], "universal")
  Assert.equal(Result.tags(Magpie.parse(Grammar.selector, "div"))[0], "element")
  Assert.equal(Result.tags(Magpie.parse(Grammar.selector, ".faded"))[0], "class")
})

Assert.doesNotAbort(Fn.new {
  var css = File.read("css/test 1.css")
  var result = Parser.new().parse(css)
  System.print(result)
  Assert.ok(result.count > 0)
})
