import "src/matchers" for Expect
import "src/suite" for Suite

import "src/expectation" for Expectation
import "src/matchers/base" for BaseMatchers

var TestBaseMatchers = Suite.new("BaseMatchers") { |it|
  var matcher

  it.beforeEach {
    matcher = BaseMatchers.new("string")
  }

  it.suite("#not") { |it|
    it.should("return itself") {
      Expect.call(matcher.not).toEqual(matcher)
    }

    it.should("negate the result") {
      var matchResult = Fiber.new {
        matcher.not.toBe(Num)
      }

      var expectation = matchResult.try()
      Expect.call(expectation).toBe(Expectation)
      Expect.call(expectation.passed).toBeTrue
    }

    it.should("have the correct failure message") {
      var matchResult = Fiber.new {
        matcher.not.toBe(Num)
      }

      var expectation = matchResult.try()
      Expect.call(expectation).toBe(Expectation)
      Expect.call(expectation.message).toEqual(
          "Expected string of class String to be of class Num")
    }
  }

  it.suite("#toBe") { |it|
    it.should("be true") {
      var matchResult = Fiber.new {
        matcher.toBe(String)
      }

      var expectation = matchResult.try()
      Expect.call(expectation).toBe(Expectation)
      Expect.call(expectation.passed).toBeTrue
    }

    it.should("be true for superclasses") {
      var matchResult = Fiber.new {
        matcher.toBe(Object)
      }

      var expectation = matchResult.try()
      Expect.call(expectation).toBe(Expectation)
      Expect.call(expectation.passed).toBeTrue
    }

    it.should("be true for user-defined classes") {
      class Foo {
        construct new() {}
      }

      matcher = BaseMatchers.new(Foo.new())
      var matchResult = Fiber.new {
        matcher.toBe(Foo)
      }

      var expectation = matchResult.try()
      Expect.call(expectation).toBe(Expectation)
      Expect.call(expectation.passed).toBeTrue
    }

    it.should("have the correct failure message") {
      var matchResult = Fiber.new {
        matcher.toBe(Num)
      }

      var expectation = matchResult.try()
      Expect.call(expectation).toBe(Expectation)
      Expect.call(expectation.passed).toBeFalse
      Expect.call(expectation.message).toEqual(
          "Expected string of class String to be of class Num")
    }
  }

  it.suite("#toBeFalse") { |it|
    it.should("be true for boolean false") {
      var matchResult = Fiber.new {
        var matcher = BaseMatchers.new(false)
        matcher.toBeFalse
      }

      var expectation = matchResult.try()
      Expect.call(expectation).toBe(Expectation)
      Expect.call(expectation.passed).toBeTrue
    }

    it.should("be false for null") {
      var matchResult = Fiber.new {
        var matcher = BaseMatchers.new(null)
        matcher.toBeFalse
      }

      var expectation = matchResult.try()
      Expect.call(expectation).toBe(Expectation)
      Expect.call(expectation.passed).toBeFalse
    }

    it.should("have the correct failure message") {
      var matchResult = Fiber.new {
        var matcher = BaseMatchers.new([])
        matcher.toBeFalse
      }

      var expectation = matchResult.try()
      Expect.call(expectation).toBe(Expectation)
      Expect.call(expectation.passed).toBeFalse
      Expect.call(expectation.message).toEqual("Expected [] to be false")
    }
  }

  it.suite("#toBeTrue") { |it|
    it.should("be true for boolean true") {
      var matchResult = Fiber.new {
        var matcher = BaseMatchers.new(true)
        matcher.toBeTrue
      }

      var expectation = matchResult.try()
      Expect.call(expectation).toBe(Expectation)
      Expect.call(expectation.passed).toBeTrue
    }

    it.should("not be true for null") {
      var matchResult = Fiber.new {
        var matcher = BaseMatchers.new(null)
        matcher.toBeTrue
      }

      var expectation = matchResult.try()
      Expect.call(expectation).toBe(Expectation)
      Expect.call(expectation.passed).toBeFalse
    }

    it.should("not be true for anything else") {
      var matchResult = Fiber.new {
        var matcher = BaseMatchers.new([])
        matcher.toBeTrue
      }

      var expectation = matchResult.try()
      Expect.call(expectation).toBe(Expectation)
      Expect.call(expectation.passed).toBeFalse
    }

    it.should("should have the correct failure message") {
      var matchResult = Fiber.new {
        var matcher = BaseMatchers.new(false)
        matcher.toBeTrue
      }

      var expectation = matchResult.try()
      Expect.call(expectation).toBe(Expectation)
      Expect.call(expectation.passed).toBeFalse
      Expect.call(expectation.message).toEqual("Expected false to be true")
    }
  }

  it.suite("#toBeNull") { |it|
    it.should("be true") {
      var matchResult = Fiber.new {
        var matcher = BaseMatchers.new(null)
        matcher.toBeNull
      }

      var expectation = matchResult.try()
      Expect.call(expectation).toBe(Expectation)
      Expect.call(expectation.passed).toBeTrue
    }

    it.should("not be true for any other value") {
      var matchResult = Fiber.new {
        var matcher = BaseMatchers.new(1)
        matcher.toBeNull
      }

      var expectation = matchResult.try()
      Expect.call(expectation).toBe(Expectation)
      Expect.call(expectation.passed).toBeFalse
      Expect.call(expectation.message).toEqual("Expected 1 to be null")
    }
  }

  it.suite("#toEqual") { |it|
    it.should("work correctly") {
      var matchResult = Fiber.new {
        matcher.toEqual("string")
      }

      var expectation = matchResult.try()
      Expect.call(expectation).toBe(Expectation)
      Expect.call(expectation.passed).toBeTrue
    }

    it.should("have the correct failure message") {
      var matchResult = Fiber.new {
        matcher.toEqual("value")
      }

      var expectation = matchResult.try()
      Expect.call(expectation).toBe(Expectation)
      Expect.call(expectation.passed).toBeFalse
      Expect.call(expectation.message).toEqual(
          "Expected string to equal value")
    }
  }
}
