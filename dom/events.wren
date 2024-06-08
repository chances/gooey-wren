// https://dom.spec.whatwg.org/#event
class Event {
  /// Params: name: String
  construct new(name) {
    _name = name
  }

  name { _name }
}

// https://dom.spec.whatwg.org/#eventtarget
class EventTarget {}
