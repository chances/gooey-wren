// https://dom.spec.whatwg.org/#interface-document
import "../dom" for Event, Node, Element

class Document is Node {
  documentElement { null }

  createElement(name: String) { null }
  createDocumentFragment() { DocumentFragment.new() }
  createEvent(name: String) { Event.new(name) }
}

class DocumentFragment is Node {}
