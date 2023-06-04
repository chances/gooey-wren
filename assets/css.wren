// See https://drafts.csswg.org/cssom
// See https://drafts.csswg.org/cssom/#css-object-model
import "gooey: dom" for Element

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
  disabled { _disabled }
  disabled=(value: Bool) { _disabled = value }

  // See https://drafts.csswg.org/cssom/#dom-cssstylesheet-insertrule
  insertRule(rule: String, index: Num) { -1 }
  deleteRule(index: Num) {}

  // TODO: Promise<CSSStyleSheet> replace(USVString text);
  // TODO: replaceSync(USVString text) {}
}

// See https://drafts.csswg.org/cssom/#cssrule
class Rule {
  construct new() {
    _css = ""
    _parent = null;
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

// See https://drafts.csswg.org/cssom/#cssstyledeclaration
class Declaration {
  construct new() {
    _css = ""
    _parent = null;
    _declarations = {}
    _declarationImportance = {}
  }

  cssText { _css }
  length { _declarations.count }
  item(index: Num) { _declarations.keys[index] }
  getPropertyValue(property: String) { _declarations[property] }
  // See https://drafts.csswg.org/cssom/#dom-cssstyledeclaration-getpropertypriority
  getPropertyPriority(property: String) {
    if (_declarationImportance[property]) return "important"
    return ""
  }
  setProperty(property: String, value: String, priority: String) {
    _declarations[property] = value;
    if (priority == "important") _declarationImportance[property] = true
    return
  }
  removeProperty(property: String) {
    var value = _declarations.remove(property)
    if (value == null) return ""
    else return value
  }
  parentRule { _parent }
}
