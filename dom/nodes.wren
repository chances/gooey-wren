// https://dom.spec.whatwg.org/#nodes

// https://dom.spec.whatwg.org/#node
import "./events" for EventTarget

class Node is EventTarget {
  construct new() {
    _type = null
    _name = null
    _parent = null
    _children = []
  }

  static ELEMENT_NODE { 1 }
  static ATTRIBUTE_NODE { 2 }
  static TEXT_NODE { 3 }
  static CDATA_SECTION_NODE { 4 }
  static ENTITY_REFERENCE_NODE { 5 }
  static ENTITY_NODE { 6 }
  static PROCESSING_INSTRUCTION_NODE { 7 }
  static COMMENT_NODE { 8 }
  static DOCUMENT_NODE { 9 }
  static DOCUMENT_TYPE_NODE { 10 }
  static DOCUMENT_FRAGMENT_NODE { 11 }

  nodeType { _type }
  name { _name }

  baseURI { "" }

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

  /// Params: deep: Bool
  cloneNode(deep) { null }
  /// Params: otherNode: Node
  isEqualNode(otherNode) { false }
  /// Params: otherNode: Node
  isSameNode(otherNode) { false }

  static DOCUMENT_POSITION_DISCONNECTED { 0x01 }
  static DOCUMENT_POSITION_PRECEDING { 0x02 }
  static DOCUMENT_POSITION_FOLLOWING { 0x04 }
  static DOCUMENT_POSITION_CONTAINS { 0x08 }
  static DOCUMENT_POSITION_CONTAINED_BY { 0x10 }
  static DOCUMENT_POSITION_IMPLEMENTATION_SPECIFIC { 0x20 }


  /// Params: other: Node
  compareDocumentPosition(other) { Node.DOCUMENT_POSITION_DISCONNECTED }
  /// Params: other: Node
  contains(other) { false }

  /// Params:
  /// node: Node
  /// child: Node
  insertBefore(node, child) {
    var childIndex = _children.indexOf(child)
    if (childIndex == -1) return node
    _children.insert(childIndex - 1, node)
    node.parent = this
    return node
  }
  /// Params: node: Node
  appendChild(node) {
    _children.add(node)
    node.parent = this
    return node
  }
  /// Params:
  /// node: Node
  /// child: Node
  replaceChild(node, child) {
    var childIndex = _children.indexOf(child)
    if (childIndex == -1) return node
    _children.removeAt(childIndex)
    child.parent = null
    _children.insert(childIndex, node)
    node.parent = this
    return node
  }
  /// Params: child: Node
  removeChild(child) {
    var childIndex = _children.indexOf(child)
    if (childIndex == -1) return child
    _children.removeAt(childIndex)
    return child
  }
}
