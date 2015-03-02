import "src/matchers" for Expect
import "src/suite" for Suite

import "src/expectation" for Expectation

// Module under test.
import "src/runnable" for Runnable

var TestRunnable = new Suite("Runnable") { |it|
  it.should("wrap a bare function") {
    var runnable = new Runnable("Test", [], []) {
      return new Expectation(true, "Fail")
    }

    var result = runnable.run()

    Expect.call(result.count).toEqual(1)
    Expect.call(result[0].passed).toBeTrue
    Expect.call(result[0].message).toEqual("Fail")
  }

  it.should("not return values yielded that aren't Expectation") {
    var testFiber = new Fiber {
      Fiber.yield(1)
    }
    var runnable = new Runnable("Test", [], [], testFiber)

    Expect.call(runnable.run().count).toEqual(0)
  }

  it.should("return all expectations emitted by the function") {
    var testFiber = new Fiber {
      Fiber.yield(new Expectation(true, "First"))

      // Yield a value that isn't an Expectation.
      Fiber.yield(false)

      Fiber.yield(new Expectation(false, "Second"))
    }
    var runnable = new Runnable("Test", [], [], testFiber)

    var result = runnable.run()

    Expect.call(result[0].passed).toBeTrue
    Expect.call(result[0].message).toEqual("First")
    Expect.call(result[1].passed).toBeFalse
    Expect.call(result[1].message).toEqual("Second")
  }

  it.suite("beforeEach & afterEach") { |it|
    it.should("call beforeEach functions") {
      var value = 0

      var beforeEach = new Fn {
        value = 1
      }

      var runnable = new Runnable("Test", [beforeEach], []) {
        Fiber.yield(new Expectation(true, value.toString))
      }

      var result = runnable.run()

      Expect.call(result[0].passed).toBeTrue
      Expect.call(result[0].message).toEqual("1")
    }

    it.should("call afterEach functions") {
      var value = 0

      var afterEach = new Fn {
        value = 1
      }

      var runnable = new Runnable("Test", [], [afterEach]) {
        Fiber.yield(new Expectation(value == 0, value.toString))
      }

      var result = runnable.run()

      Expect.call(value).toEqual(1)
      Expect.call(result[0].passed).toBeTrue
      Expect.call(result[0].message).toEqual("0")
    }
  }

  it.suite("public getters") { |it|
    it.should("return the title") {
      var runnable = new Runnable("Test Title", [], []) {}

      Expect.call(runnable.title).toEqual("Test Title")
    }

    it.should("return the duration of a test run") {
      var runnable = new Runnable("Test", [], []) {}
      runnable.run()

      Expect.call(runnable.duration > 0).toBeTrue
    }

    it.should("correctly say if the runnable has been run") {
      var runnable = new Runnable("Test", [], []) {}

      Expect.call(runnable.hasRun).toBeFalse

      runnable.run()

      Expect.call(runnable.hasRun).toBeTrue
    }

    it.should("return null if no error was generated by the test") {
      var runnable = new Runnable("Test Title", [], []) {}

      runnable.run()

      Expect.call(runnable.error).toEqual(null)
    }

    it.should("return the error generated by a test error") {
      var block = new Fn { Fiber.abort("Test error!") }
      var runnable = new Runnable("Test Title", [], [], block)

      runnable.run()

      Expect.call(runnable.error).toEqual("Test error!")
    }

    it.should("return the expectations generated by the test") {
      var expectation = new Expectation(true, "Fail")
      var runnable = new Runnable("Test", [], []) { expectation }

      runnable.run()

      // TODO: Enable after supporting better equals for complex objects.
      //Expect.call(runnable.expectations).toEqual([expectation])
    }
  }
}