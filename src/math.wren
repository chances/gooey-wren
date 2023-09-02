class Math {
  // Clamp the given `angle` such that
  static wrapRadians(angle) {
    return angle > Num.pi ? angle % Num.pi : angle
  }
}
