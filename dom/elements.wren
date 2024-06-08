// https://dom.spec.whatwg.org/#element
import "./nodes" for Node

// https://dom.spec.whatwg.org/#interface-attr
class Attr is Node {
  /// Params: name: String
  construct new(name) {
    _name = name
    _value = ""
  }

  name { _name }
  value { _value }
  value=(value) { _value = value }
}

// https://dom.spec.whatwg.org/#element
class Element is Node {
  construct new() {
    _id = null
    _className = ""
    _attributes = {}
  }

  localName { _localName }
  tagName { _tag }

  /// Returns: String
  id { _id }
  /// Params: value: String
  /// Returns: String
  id=(value) { _id = value }
  /// Returns: String
  className { _className }
  /// Params: value: String
  /// Returns: String
  className=(value) { _className = value }
  /// Returns: List<String>
  classList { _className.split(" ") }

  hasAttributes() { _attributes.count > 0 }
  attributes { _attributes }
  getAttributeNames() { _attributes.keys }
  /// Params: qualifiedName: String
  /// Returns: String
  getAttribute(qualifiedName) { null }
  /// Params:
  /// qualifiedName: String
  /// value: String
  /// Returns: String
  setAttribute(qualifiedName, value) {}
  /// Params: qualifiedName: String
  /// Returns: String
  removeAttribute(qualifiedName) {}
  /// Params:
  /// qualifiedName: String
  /// force: Bool
  /// Returns: Bool
  /// See Also: https://dom.spec.whatwg.org/#dom-element-toggleattribute
  toggleAttribute(qualifiedName, force) {
    var attr = this.getAttribute(qualifiedName)
    if (attr == null && force) {
      _attributes[qualifiedName] = ""
      return true
    }
    if (attr == null) return false
    _attributes.remove(qualifiedName)
    return true
  }
  /// Params: qualifiedName: String
  /// Returns: Bool
  hasAttribute(qualifiedName) { _attributes.containsKey(qualifiedName) }
}
