#if os(Linux)

import XCTest
@testable import Hackathon
@testable import HackathonApp

XCTMain([
    testCase(HackathonTests.allTests),
])

#endif
