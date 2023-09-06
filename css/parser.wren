import "wren-magpie/magpie" for Magpie, Result

import "../css" for StyleSheet, Rule, Declaration, Value, Unit

class Parser {
  construct new() {}
  parse(source) {
    // TODO: Support file handles
    if (!(source is String)) Fiber.abort("Source input is of an unrecognized type")
    return Magpie.parse(Grammar.stylesheet, source)
  }
}

// See https://www.w3.org/TR/CSS21/grammar.html
class Grammar {
  //   : [ CHARSET_SYM STRING ';' ]?
  //     [S|CDO|CDC]* [ import [ CDO S* | CDC S* ]* ]*
  //     [ [ ruleset | media | page ] [ CDO S* | CDC S* ]* ]*
  //   ;
  // Purposefully omitted charset specifier
  static stylesheet {
    var cData = Magpie.zeroOrMore(Magpie.or([
      Magpie.sequence(Tokens.cdo, Magpie.zeroOrMore(Tokens.s)),
      Magpie.sequence(Tokens.cdc, Magpie.zeroOrMore(Tokens.s))
    ]))

    return Magpie.sequence([
      // Comments
      Magpie.zeroOrMore(Magpie.or([
        Tokens.s,
        Tokens.cdo,
        Tokens.cdc
      ])),
      // Imports
      Magpie.zeroOrMore(Magpie.sequence([
        Grammar.import_,
        cData
      ])),
      // Rulesets, Media Queries, and Pages
      Magpie.zeroOrMore(Magpie.sequence([
        Magpie.or([Grammar.ruleset, Grammar.media, Grammar.page]),
        cData
      ]))
    ])
  }
  //   : IMPORT_SYM S*
  //     [STRING|URI] S* media_list? ';' S*
  //   ;
  static import_ {
    return Magpie.sequence([
      Magpie.str("import"),
      Magpie.zeroOrMore(Tokens.s),
      Magpie.or(Tokens.string, Tokens.uri),
      Magpie.zeroOrMore(Tokens.s),
      Magpie.optional(Grammar.media_list),
      Magpie.char(";"),
      Magpie.zeroOrMore(Tokens.s)
    ])
  }
  //   : MEDIA_SYM S* media_list '{' S* ruleset* '}' S*
  //   ;
  static media {
    return Magpie.sequence([
      Magpie.str("media"),
      Magpie.zeroOrMore(Tokens.s),
      Magpie.one(Grammar.media_list),
      Magpie.char("{"),
      Magpie.zeroOrMore(Tokens.s),
      Magpie.zeroOrMore(Grammar.ruleset),
      Magpie.char("}"),
      Magpie.zeroOrMore(Tokens.s),
    ])
  }
  //   : medium [ COMMA S* medium]*
  //   ;
  static media_list {
    return Magpie.sequence([
      Magpie.one(Grammar.medium),
      Magpie.optional([
        Magpie.char(","),
        Magpie.zeroOrMore(Tokens.s),
        Magpie.one(Grammar.medium)
      ])
    ])
  }
  //   : IDENT S*
  //   ;
  static medium { Magpie.sequence(Tokens.ident, Magpie.zeroOrMore(Tokens.s)) }
  //   : PAGE_SYM S* pseudo_page?
  //     '{' S* declaration? [ ';' S* declaration? ]* '}' S*
  //   ;
  static page { Magpie.fail("Unimplemented CSS feature") }
  //   : ':' IDENT S*
  //   ;
  static pseudo_page {
    return Magpie.sequence([Magpie.char(":"), Tokens.ident, Magpie.zeroOrMore(Tokens.s)])
  }
  //   : '/' S* | ',' S*
  //   ;
  static operator {
    return Magpie.sequence(
      Magpie.or(Magpie.char("/").tag("slash"), Magpie.char(",").tag("comma")),
      Magpie.zeroOrMore(Tokens.s)
    )
  }
  //   : '~' S*
  //   | '+' S*
  //   | '>' S*
  //   ;
  static combinator {
    return Magpie.sequence(
      Magpie.or(
        Magpie.char("~").tag("sibling:general"),
        Magpie.char("+").tag("sibling:adjacent"),
        Magpie.char(">").tag("child")
      ),
      Magpie.zeroOrMore(Tokens.s)
    )
  }
  //   : '-' | '+'
  //   ;
  static unary_operator {
    return Magpie.or(Magpie.char("-"), Magpie.char("+"))
  }
  //   : IDENT S*
  //   ;
  static property {
    return Magpie.sequence(
      Magpie.one(Tokens.ident),
      Magpie.zeroOrMore(Tokens.s)
    )
  }
  //   : selector [ ',' S* selector ]*
  //     '{' S* declaration? [ ';' S* declaration? ]* '}' S*
  //   ;
  static ruleset {
    return Magpie.sequence([
      Grammar.selector,
      Magpie.zeroOrMore(Magpie.sequence([
        Magpie.char(","),
        Magpie.zeroOrMore(Tokens.s),
        Grammar.selector,
      ])).tag("list"),
      Magpie.char("{"),
      Magpie.zeroOrMore(Tokens.s),
      Magpie.optional(Grammar.declaration),
      Magpie.zeroOrMore(Magpie.sequence([
        Magpie.char(";"),
        Magpie.zeroOrMore(Tokens.s),
        Magpie.optional(Grammar.declaration),
      ])),
      Magpie.char("}"),
      Magpie.zeroOrMore(Tokens.s)
    ])
  }
  //   : simple_selector
  //   | combinatorial_selector
  //   ;
  static selector {
    return Magpie.or(
      Grammar.simple_selector,
      Grammar.combinatorial_selector
    ).map {|result|
      // TODO: Create a Selector structure
      return result
    }
  }
  //   : element_name [ HASH | class | attrib | pseudo ]*
  //   | [ HASH | class | attrib | pseudo ]+
  //   ;
  static simple_selector {
    var idClassAttrPseudo = Magpie.or([
      Tokens.hash.tag("id"),
      Grammar.class_.tag("class"),
      Grammar.attrib.tag("attr"),
      Grammar.pseudo.tag("pseudo"),
    ])
    return Magpie.or(
      Magpie.sequence(Grammar.element_name, Magpie.zeroOrMore(idClassAttrPseudo)),
      Magpie.oneOrMore(idClassAttrPseudo)
    )
  }
  //   : combinator selector
  //   | S+ [ combinator? selector ]?
  //   ;
  static combinatorial_selector {
    // FIXME: Tests hang and leak memory. There's left-recursion here.
    // Magpie.or([
    //   Magpie.sequence([Grammar.combinator, Grammar.selector]),
    //   Magpie.sequence([
    //     Magpie.zeroOrMore(Tokens.s),
    //     Magpie.sequence(Magpie.optional(Grammar.combinator), Grammar.selector)
    //   ])
    // ])
    return Magpie.fail("Unimplemented CSS feature")
  }
  //   : '.' IDENT
  //   ;
  static class_ {
    return Magpie.sequence(
      Magpie.char("."),
      Magpie.one(Tokens.ident)
    ).map {|result| result[0].rewrite(result[1..-1].map {|r| r.lexeme }.join()) }
  }
  //   : IDENT | '*'
  //   ;
  static element_name {
    return Magpie.or(
      Magpie.one(Tokens.ident).join.tag("element"),
      Magpie.char("*").tag("universal")
    )
  }
  //   : '[' S* IDENT S* [ [ '=' | INCLUDES | DASHMATCH ] S*
  //     [ IDENT | STRING ] S* ]? ']'
  //   ;
  static attrib { Magpie.fail("Unimplemented CSS feature") }
  //   : ':' [ IDENT | FUNCTION S* [IDENT S*]? ')' ]
  //   ;
  static pseudo { Magpie.fail("Unimplemented CSS feature") }
  //   : property ':' S* expr prio?
  //   ;
  static declaration {
    return Magpie.sequence([
      Grammar.property,
      Magpie.char(":"),
      Magpie.zeroOrMore(Tokens.s),
      Grammar.expr,
      // FIXME: Grammar.expr.tag("expr"),
      Magpie.optional(Grammar.prio)
      // FIXME: Magpie.optional(Grammar.prio).tag("prio")
    ]).map {|result|
      return {
        name: result[0].token,
        value: result.where {|r| r.tag == "expr" },
        prio: result.where {|r| r.tag == "prio" }.count > 0
      }
    }
  }
  //   : IMPORTANT_SYM S*
  //   ;
  static prio { Magpie.sequence(Tokens.important, Magpie.zeroOrMore(Tokens.s)) }
  //   : term [ operator? term ]*
  //   ;
  static expr {
    return Magpie.sequence(
      Grammar.term,
      Magpie.zeroOrMore(Magpie.sequence(
        Magpie.optional(Grammar.operator), Grammar.term
      ))
    )
  }
  //   : unary_operator?
  //     [ NUMBER S* | PERCENTAGE S* | LENGTH S* | EMS S* | EXS S* | ANGLE S* |
  //       TIME S* | FREQ S* ]
  //   | STRING S* | IDENT S* | URI S* | hexcolor | function
  //   ;
  static term { Magpie.fail("Unimplemented CSS feature") }
  //   : FUNCTION S* expr ')' S*
  //   ;
  static function {
    return Magpie.sequence([
      Tokens.function,
      Magpie.zeroOrMore(Tokens.s),
      Grammar.expr,
      Magpie.char(")"),
      Magpie.zeroOrMore(Tokens.s),
    ])
  }
  /*
   * There is a constraint on the color that it must
   * have either 3 or 6 hex-digits (i.e., [0-9a-fA-F])
   * after the "#"; e.g., "#000" is OK, but "#abcd" is not.
   */
  //   : HASH S*
  //   ;
  static hexcolor { Magpie.sequence(Tokens.hash, Magpie.zeroOrMore(Tokens.s)) }
}

// See https://www.w3.org/TR/CSS21/grammar.html#scanner
// Tokens are case-insensitive
class Tokens {
  // [0-9a-f]
  static hex {
    return Magpie.or(
      Magpie.digit,
      Magpie.or(
        Magpie.charFrom(Magpie.charRangeFrom("A", "F")),
        Magpie.charFrom(Magpie.charRangeFrom("a", "f"))
      )
    )
  }

  static nonascii { Magpie.charFrom(240..377) }
  static cdo { Magpie.str("<!--") }
  static cdc { Magpie.str("-->") }

  // \\{h}{1,6}(\r\n|[ \t\r\n\f])?
  static unicode { Magpie.fail("Unimplemented token") }

  // {unicode}|\\[^\r\n\f0-9a-f]
  static escape {
    return Magpie.or(
      Tokens.unicode,
      Magpie.sequence([
        Magpie.char("\\"),
        Magpie.or([
          Magpie.digit,
          Magpie.charFrom(Magpie.charRangeFrom("A", "Z")),
          Magpie.charFrom(Magpie.charRangeFrom("a", "z"))
        ])
      ])
    )
  }

  // [_a-z]|{nonascii}|{escape}
  // Purposefully ommitting {escape} for simplicity
  static nmstart {
    return Magpie.or([
      Magpie.or([
        Magpie.char("_"),
        Magpie.charFrom(Magpie.charRangeFrom("A", "Z")),
        Magpie.charFrom(Magpie.charRangeFrom("a", "z"))
      ]),
      Tokens.nonascii
    ])
  }

  // [_a-z0-9-]|{nonascii}|{escape}
  // Purposefully ommitting {escape} for simplicity
  static nmchar {
    return Magpie.or([
      Magpie.or([
        Magpie.char("_"),
        Magpie.charFrom(Magpie.charRangeFrom("A", "Z")),
        Magpie.charFrom(Magpie.charRangeFrom("a", "z")),
        Magpie.digit,
        Magpie.char("-")
      ]),
      Tokens.nonascii
    ])
  }

  // "url("{w}{string}{w}")"
  // "url("{w}{url}{w}")"
  static uri {
    return Magpie.sequence([
      Magpie.str("url("),
      Tokens.w,
      Magpie.or(Tokens.string, Tokens.url),
      Tokens.w,
      Magpie.str(")")
    ])
  }

  // TODO: static string1 {  \"([^\n\r\f\\"]|\\{nl}|{escape})*\" }
  // TODO: static string2 {  \'([^\n\r\f\\']|\\{nl}|{escape})*\' }
  // TODO: static comment {  \/\*[^*]*\*+([^/*][^*]*\*+)*\/ }
  // -?{nmstart}{nmchar}*
  static ident {
    return Magpie.sequence([
      Magpie.optional(Magpie.char("-")),
      Tokens.nmstart,
      Magpie.zeroOrMore(Tokens.nmchar)
    ])
  }

  static hash { Magpie.sequence(Magpie.char("#"), Tokens.name) }

  static important {
    // TODO: Support case-insensitivity here
    return Magpie.str("!important")
  }

  // {nmchar}+
  static name { Magpie.oneOrMore(Tokens.nmchar) }

  // [0-9]+|[0-9]*"."[0-9]+
  static num {
    return Magpie.or([
      Magpie.oneOrMore(Magpie.digit),
      Magpie.sequence([Magpie.zeroOrMore(Magpie.digit), Magpie.str("."), Magpie.oneOrMore(Magpie.digit)])
    ])
  }

  // {string1}|{string2}
  static string { Magpie.fail("Unimplemented token") }

  // ([!#$%&*-~]|{nonascii}|{escape})*
  static url {
    var terminators = [
      Magpie.char("!"), Magpie.char("#"), Magpie.char("$"), Magpie.char("\%"),
      Magpie.char("&"), Magpie.char("*"), Magpie.char("-"), Magpie.char("~")
    ]
    // TODO: Add above escape hatch to the or clause
    return Magpie.zeroOrMore(Magpie.or(Tokens.nonascii, Tokens.escape))
  }

  // [ \t\r\n\f]+
  static s {
    return Magpie.oneOrMore(Magpie.or([
      Magpie.char(20), // U+0020 SPACE
      Magpie.char("\t"),
      Magpie.char("\r"),
      Magpie.char("\n"),
      Magpie.char("\f"),
    ]))
  }

  // {s}?
  static w { Magpie.optional(Tokens.s) }

  // \n|\r\n|\r|\f
  static nl {
    return Magpie.or([
      Magpie.char("\n"),
      Magpie.str("\r\n"),
      Magpie.char("\r"),
      Magpie.char("\f")
    ])
  }
}
