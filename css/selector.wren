// A CSS selector.
class Selector {
  // The weight of a CSS selector to determine which rule from competing CSS declarations gets applied to an element.
  // See: https://developer.mozilla.org/en-US/docs/Web/CSS/Specificity
  specificity { 0 }
}

// A simple CSS selector.
class SimpleSelector is Selector {
  construct new(tag) {
      _tag = tag
      _id = null
      _classes = []
    }
    construct new(tag, id, classes) {
      _tag = tag
      _id = id
      _classes = classes
    }

    tag { _tag }
    id { _id }
    classes { _classes }

    specificity { 0 }
  }
