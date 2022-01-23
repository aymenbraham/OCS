//
//  ProgrammePresenterTests.swift
//  OCSTests
//
//  Created by aymen braham on 22/01/2022.
//

import XCTest
import Combine
@testable import OCS

class ProgrammePresenterTests: XCTestCase {
    
    var presenter: ProgrammesPresenterProtocol!
    var interactor: TestProgrammeInteractor!
    var router: TestProgrammeRouter!
    var subscriptions = Set<AnyCancellable>()
    let programme: Programme = Programme(id: "GAMEOFT0806W0149298", title: [Title(value: "GAME OF THRONES")], subtitle: "saisons 1 Ã  8", imageURL: "/data_plateforme/saison/1691/origin_gameofthr08w0149292_ni72q.jpg?size=small", fullScreenImageUrl: "/data_plateforme/saison/1691/origin_gameofthr08w0149292_ni72q.jpg?size=large", detailLink: "/apps/v2/details/serie/PSGAMEOFTHRW0058624")
    
    
    override func setUp() {
        super.setUp()
        interactor = TestProgrammeInteractor()
        router = TestProgrammeRouter()
        presenter = ProgrammePresenter(interactor: interactor, router: router)
    }
    
    func testThatItRetrievesProgrammes() {
        let testExpectation = expectation(description: #function)
        
        let programme = ResponseProgrammes(contents: [programme])
        interactor.programme = programme
        
        presenter.showProgrammes(text: "Game").receive(on: DispatchQueue.main).sink(receiveCompletion: { (completion) in
            switch completion {
            case let .failure(error):
                print("Couldn't get programmes: \(error)")
            case .finished: break
            }
        }) { programmes in
            XCTAssertEqual(programmes.contents?.count, 146)
            XCTAssertEqual(programmes.contents?.first?.id, "GAMEOFT0806W0149298")
            XCTAssertEqual(programmes.contents?.first?.subtitle, "saisons 1 à 8")
            XCTAssertEqual(programmes.contents?.first?.imageURL, "/data_plateforme/saison/1691/origin_gameofthr08w0149292_ni72q.jpg?size=small")
            XCTAssertEqual(programmes.contents?.first?.fullScreenImageUrl, "/data_plateforme/saison/1691/origin_gameofthr08w0149292_ni72q.jpg?size=large")
            XCTAssertEqual(programmes.contents?.first?.detailLink, "/apps/v2/details/serie/PSGAMEOFTHRW0058624")
            testExpectation.fulfill()
        }
        .store(in: &subscriptions)
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testThatItShowsProgrammeDetailScreen() {
        presenter.showProgrammeDetail(for: programme)
        XCTAssertTrue(router.showProgrammeDetailCalled)
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

// Test Classes
extension ProgrammePresenterTests {
    
    class TestProgrammeRouter: ProgrammessRouterProtocol {
        
        var showProgrammeDetailCalled = false
        
        func showProgrammeDetail(for programme: Programme) {
            showProgrammeDetailCalled = true
        }
    }
    
    class TestProgrammeInteractor: ProgrammeInteractorProtocol {
        
        let apiService: ProgrammesAPIService = ProgrammesAPIService(networkController: NetworkController())
        var programme: ResponseProgrammes?
        
        func getProgrammes(text: String) -> AnyPublisher<ResponseProgrammes, Error> {
            apiService.getProgrammes(text: text).eraseToAnyPublisher()
        }
    }
}
