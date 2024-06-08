// https://dom.spec.whatwg.org/#interface-document
import "./elements" for Element
import "./events" for Event
import "./nodes" for Node

class Document is Node {
  documentElement { null }

  /// Params: name: String
  createElement(name) { null }
  createDocumentFragment() { DocumentFragment.new() }
  /// Params: name: String
  createEvent(name) { Event.new(name) }
}

class DocumentFragment is Node {}
