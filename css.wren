// https://drafts.csswg.org/cssom
// https://drafts.csswg.org/cssom/#css-object-model
import "./dom" for Element
import "./math" for Math

class StyleSheet {
  construct new() {
    _href = null
    _ownerNode = null
    _ownerRule = null
    _parent = null
    _rules = []
    _title = ""
    _media = []
    _disabled = false
  }

  type { "text/css" }
  href { _href }
  ownerNode { _ownerNode }
  ownerRule { _ownerRule }
  parentStyleSheet { _parent }
  cssRules { _rules }
  title { _title }
  media { _media }
  /// Returns: Bool
  disabled { _disabled }
  /// Params: value: Bool
  /// ditto
  disabled=(value) { _disabled = value }

  /// Params:
  /// rule: String
  /// index: Num
  /// Returns: Num
  /// See_Also: https://drafts.csswg.org/cssom/#dom-cssstylesheet-insertrule
  insertRule(rule, index) { -1 }
  /// Params: index: Num
  deleteRule(index) {}

  // TODO: Promise<CSSStyleSheet> replace(USVString text);
  // TODO: replaceSync(USVString text) {}
}

// https://drafts.csswg.org/cssom/#cssrule
class Rule {
  construct new() {
    _css = ""
    _parent = null
    _parentStyleSheet = null
    _selectors = []
    _style = null
  }

  cssText { _css }
  parent { _parent }
  parentStyleSheet { _parentStyleSheet }

  selectorText { "" }
  style { _style }
}

// https://drafts.csswg.org/cssom/#cssstyledeclaration
class Declaration {
  construct new() {
    _css = ""
    _parent = null
    _declarations = {}
    _declarationImportance = {}
  }

  cssText { _css }
  length { _declarations.count }
  /// Params: index: Num
  /// Returns: Any
  item(index) { _declarations.keys[index] }
  /// Params: property: String
  /// Returns: Any
  getPropertyValue(property) { _declarations[property] }
  // https://drafts.csswg.org/cssom/#dom-cssstyledeclaration-getpropertypriority
  /// Params: property: String
  /// Returns: String
  getPropertyPriority(property) {
    if (_declarationImportance[property]) return "important"
    return ""
  }
  /// Params:
  /// property: String
  /// value: String
  /// priority: String
  setProperty(property, value, priority) {
    _declarations[property] = value
    if (priority == "important") _declarationImportance[property] = true
    return
  }
  /// Params: property: String
  /// Returns: Null | Any
  removeProperty(property) {
    var value = _declarations.remove(property)
    if (value == null) return null
    return value
  }
  parentRule { _parent }
}

class Value {
  /// Params: value: String
  construct parse(value) {
    _identifier = null
    _numeric = 0
    _angle = 0
    _color = [0, 0, 0, 0]
    _unit = Unit.pixels
  }

  angle { Math.wrap_radians(_angle) }
  color { [0, 0, 0, 0] }
  identifier { null }
  number { 0 }
  length { 0 }
  percentage { 0 }
  time { 0 }
}

class Unit {
static degrees { "deg" }
  static radians { "rad" }
  static turn { "turn" }
  static capHeight { "cap" }
  static zeroAdvanceMeasure { "ch" }
  static fontSize { "em" }
  static rootFontSize { "rem" }
  static xHeight { "ex" }
  static lineHeight { "lh" }
  static rootLineHeight { "rlh" }
  static pixels { "px" }
  static centimeter { "cm" }
  static millimeter { "mm" }
  static inch { "in" }
  static pica { "pc" }
  static point { "pt" }
  static percentage { "\%" }
  static seconds { "s" }
  static milliseconds { "ms" }
}
