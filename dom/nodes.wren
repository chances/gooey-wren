// https://dom.spec.whatwg.org/#nodes

// https://dom.spec.whatwg.org/#node
import "../dom" for EventTarget

class Node is EventTarget {
  construct new() {
    _type = null
    _name = null
    _parent = null
    _children = []
  }

  static var ELEMENT_NODE = 1
  static var ATTRIBUTE_NODE = 2
  static var TEXT_NODE = 3
  static var CDATA_SECTION_NODE = 4
  static var ENTITY_REFERENCE_NODE = 5
  static var ENTITY_NODE = 6
  static var PROCESSING_INSTRUCTION_NODE = 7
  static var COMMENT_NODE = 8
  static var DOCUMENT_NODE = 9
  static var DOCUMENT_TYPE_NODE = 10
  static var DOCUMENT_FRAGMENT_NODE = 11

  nodeType { _type }
  name { _name }

  var baseURI = ""

  isConnected { false }
  ownerDocument { null }
  getRootNode(options) { this }
  parentNode { _parent }
  parentElement { null }
  hasChildNodes() { _children.count > 0 }
  childNodes { _children }
  firstChild { _children[0] }
  lastChild { _children[_children.count - 1] }
  previousSibling { null }
  nextSibling { null }

  textContent { "" }

  cloneNode(deep: Bool) { null }
  isEqualNode(otherNode: Node) { false }
  isSameNode(otherNode: Node) { false }

  static var DOCUMENT_POSITION_DISCONNECTED = 0x01
  static var DOCUMENT_POSITION_PRECEDING = 0x02
  static var DOCUMENT_POSITION_FOLLOWING = 0x04
  static var DOCUMENT_POSITION_CONTAINS = 0x08
  static var DOCUMENT_POSITION_CONTAINED_BY = 0x10
  static var DOCUMENT_POSITION_IMPLEMENTATION_SPECIFIC = 0x20
  compareDocumentPosition(other: Node) { DOCUMENT_POSITION_DISCONNECTED }
  contains(other: Node) { false }

  insertBefore(node: Node, child: Node) {
    var childIndex = _children.indexOf(child)
    if (childIndex == -1) return node
    _children.insert(childIndex - 1, node)
    node._parent = this
    return node
  }
  appendChild(node: Node) {
    _children.add(node)
    node._parent = this
    return node
  }
  replaceChild(node: Node, child: Node) {
    var childIndex = _children.indexOf(child)
    if (childIndex == -1) return node
    _children.removeAt(childIndex)
    child._parent = null
    _children.insert(childIndex, node)
    node._parent = this
    return node
  }
  removeChild(child: Node) {
    var childIndex = _children.indexOf(child)
    if (childIndex == -1) return child
    _children.removeAt(childIndex)
    return child
  }
}
