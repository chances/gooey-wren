// https://dom.spec.whatwg.org/#element
import "../dom" for Node

// https://dom.spec.whatwg.org/#interface-attr
class Attr is Node {
  // Params:
  // name: String
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

  id { _id }
  // Params:
  // value: String
  id=(value) { _id = value }
  className { _className }
  // Params:
  // value: String
  className=(value) { _className = value }
  classList { _className.split(" ") }

  hasAttributes() { _attributes.count > 0 }
  attributes { _attributes }
  getAttributeNames() { _attributes.keys }
  // Params:
  // qualifiedName: String
  getAttribute(qualifiedName) { null }
  // Params:
  // qualifiedName: String
  // value: String
  setAttribute(qualifiedName, value) {}
  // Params:
  // qualifiedName: String
  removeAttribute(qualifiedName) {}
  // https://dom.spec.whatwg.org/#dom-element-toggleattribute
  // Params:
  // qualifiedName: String
  // force: Bool
  // Returns: Whether the attribute was set, `false` if it was unset.
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
  // Params:
  // qualifiedName: String
  // Returns: Whether this element has an attribute with the given name.
  hasAttribute(qualifiedName) { _attributes.containsKey(qualifiedName) }
}
