import "src/matchers/fiber" for FiberMatchers

/**
 * Convenience method for creating new Matchers in a more readable style.
 *
 * @param {*} value Value to create a new matcher for.
 * @return A new `Matchers` instance for the given value.
 */
var Expect = new Fn { |value|
  return new FiberMatchers(value)
}