import "src/expectation" for Expectation

/**
 * Run a test block.
 */
class Runnable {
  /**
   * Create a new runnable test object. Either a Fiber or Fn can be given as the
   * runnable object.
   *
   * @param {String} title Name of the test.
   * @param {Fiber|Fn} body Fiber or function that represents the test to run.
   */
  new (title, fn, beforeEaches, afterEaches) {
    _title = title

    _beforeEaches = beforeEaches
    _afterEaches = afterEaches

    _expectations = []

    // Wrap bare functions in Fibers.
    if (fn.type != Fiber) {
      fn = new Fiber(fn)
    }

    _fn = fn
  }

  /**
   * @return {String} The error string of this Runnable if an error was
   * encountered while running this test.
   */
  error { _fn.error }

  expectations { _expectations }

  /**
   * Runs the test function and collects the `Expectation`s that were generated.
   *
   * @return {Sequence[Expectation]} List of `Expectation`s that were emitted by
   * the test body.
   */
  run {
    for (fn in _beforeEaches) { fn.call }

    while (!_fn.isDone) {
      var result = _fn.try

      // Ignore any values that were yielded that weren't an Expectation.
      // Note: When a fiber is finished the last `yield` invocation returns
      // `null` so it will not be added to the array.
      if (result is Expectation) {
        _expectations.add(result)
      }
    }

    for (fn in _afterEaches) { fn.call }

    return _expectations
  }

  /**
   * @return {String} Title string of this Runnable.
   */
  title { _title }
}