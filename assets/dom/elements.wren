// https://dom.spec.whatwg.org/#element
import "gooey: dom" for Node

// https://dom.spec.whatwg.org/#interface-attr
class Attr is Node {
  construct new(name: String) {
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
  id=(value: String) { _id = value }
  className { _className }
  className=(value: String) { _className = value }
  classList { _className.split(" ") }

  hasAttributes() { _attributes.count > 0 }
  attributes { _attributes }
  getAttributeNames() { _attributes.keys }
  getAttribute(qualifiedName: String) { null }
  setAttribute(qualifiedName: String, value: String) {}
  removeAttribute(qualifiedName: String) {}
  // https://dom.spec.whatwg.org/#dom-element-toggleattribute
  boolean toggleAttribute(qualifiedName: String, force: Bool) {
    var attr = this.getAttribute(qualifiedName)
    if (attr == null && force) {
      _attributes[qualifiedName] = ""
      return true
    } else if (attr == null) { return false }
    _attributes.remove(qualifiedName)
    return true
  }
  hasAttribute(qualifiedName: String) { _attributes.containsKey(qualifiedName) }
}
