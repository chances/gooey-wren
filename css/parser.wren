// See https://www.w3.org/TR/CSS21/grammar.html
import "wren-magpie/magpie" for Magpie

// See https://www.w3.org/TR/CSS21/grammar.html#scanner
// Tokens are case-insensitive
class Tokens {
  // [0-9a-f]
  static hex {
    Magpie.or(
      Magpie.digit,
      Magpie.or(
        Magpie.charFrom(Magpie.charRangeFrom("A", "F")),
        Magpie.charFrom(Magpie.charRangeFrom("a", "f"))
      )
    )
  }
  static nonascii {
    Magpie.charFrom(240..377)
  }
  // \\{h}{1,6}(\r\n|[ \t\r\n\f])?
  static unicode {
    Magpie.fail("Unimplemented token")
  }
  // {unicode}|\\[^\r\n\f0-9a-f]
  static escape {
    Magpie.or(
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
  // Purposefully omitting {escape} for simplicity
  static nmstart {
    Magpie.or([
      Magpie.or([
        Magpie.char("_"),
        Magpie.charFrom(Magpie.charRangeFrom("A", "Z")),
        Magpie.charFrom(Magpie.charRangeFrom("a", "z"))
      ]),
      Tokens.nonascii
    ])
  }
  // [_a-z0-9-]|{nonascii}|{escape}
  // Purposefully omitting {escape} for simplicity
  static nmchar {
    Magpie.or([
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
  // TODO: static string1 {  \"([^\n\r\f\\"]|\\{nl}|{escape})*\" }
  // TODO: static string2 {  \'([^\n\r\f\\']|\\{nl}|{escape})*\' }
  // TODO: static comment {  \/\*[^*]*\*+([^/*][^*]*\*+)*\/ }
  // -?{nmstart}{nmchar}*
  static ident {
    Magpie.sequence([
      Magpie.optional(Magpie.char("-")),
      Tokens.nmstart,
      Magpie.zeroOrMore(Tokens.nmchar)
    ])
  }
  static hash {
    Magpie.sequence(Magpie.char("#"), Tokens.name)
  }
  static important {
    // TODO: Support case-insensitivity here
    Magpie.str("!important")
  }
  // {nmchar}+
  static name {
    Magpie.oneOrMore(Tokens.nmchar)
  }
  // [0-9]+|[0-9]*"."[0-9]+
  static num {
    Magpie.or([
      Magpie.oneOrMore(Magpie.digit),
      Magpie.sequence([Magpie.zeroOrMore(Magpie.digit), Magpie.str("."), Magpie.oneOrMore(Magpie.digit)])
    ])
  }
  // {string1}|{string2}
  static string {
    Magpie.fail("Unimplemented token")
  }
  // ([!#$%&*-~]|{nonascii}|{escape})*
  static url {}
  // [ \t\r\n\f]+
  static s {
    Magpie.oneOrMore(Magpie.or([
      Magpie.char(20) // U+0020 SPACE
      Magpie.char("\t"),
      Magpie.char("\r"),
      Magpie.char("\n"),
      Magpie.char("\f"),
    ]))
  }
  // {s}?
  static w {
    Magpie.optional(Tokens.s)
  }
  // \n|\r\n|\r|\f
  static nl {
    Magpie.or([
      Magpie.char("\n")
      Magpie.str("\r\n")
      Magpie.char("\r")
      Magpie.char("\f")
    ])
  }
}

class Parser {}
