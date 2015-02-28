import "src/matchers" for Expect
import "src/suite" for Suite

import "src/matchers/base" for BaseMatchers
import "src/matchers/fiber" for FiberMatchers
import "src/matchers/stub" for StubMatchers

var TestMatchers = new Suite("Matchers") { |it|
  it.should("return an instance that is a subclass of all matcher classes") {
    var matcher = Expect.call(true)

    Expect.call(matcher).toBe(BaseMatchers)
    Expect.call(matcher).toBe(FiberMatchers)
    Expect.call(matcher).toBe(StubMatchers)
  }
}