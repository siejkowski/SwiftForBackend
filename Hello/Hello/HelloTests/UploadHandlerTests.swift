import XCTest
import PerfectLib
@testable import Hello

class UploadHandlerTests: XCTestCase {
    
    var sut: UploadHandler?
    
    var context: MustacheEvaluationContext?
    var collector: MustacheEvaluationOutputCollector?
    
    override func setUp() {
        sut = UploadHandler()
        context = MustacheEvaluationContext(map: [:])
        collector = MustacheEvaluationOutputCollector()
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testUploadHandlerShouldSetProperTitle() {
        let values : [String:Any] = try! sut!.valuesForResponse(context!, collector: collector!)
        let title = values["title"] as? String
        XCTAssertTrue(title.map({ $0 == "swift"}) ?? false)
    }
    
}
