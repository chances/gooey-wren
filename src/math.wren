class Math {
  // Normalizes any number to an arbitrary range by assuming the range wraps around when going
  // below `min` or above `max`.
  // See: https://stackoverflow.com/a/2021986/1363247
  static normalize(value, min, max) {
    var width       = max - min
    var offsetValue = value - min
    return (offsetValue - ((offsetValue / width).floor * width)) + min
  }

  // Normalize the given `angle` to the unit circle.
  static wrapRadians(angle) {
    return angle - 2 * Num.pi * (angle / (2 * Num.pi)).floor
  }
}
