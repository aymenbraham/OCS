//
//  DetailProgrammePresenterTests.swift
//  OCSTests
//
//  Created by aymen braham on 22/01/2022.
//

import XCTest
import Combine
@testable import OCS

class DetailProgrammePresenterTests: XCTestCase {
    
    var presenter: DetailProgrammesPresenterProtocol!
    var interactor: TestDetailProgrammeInteractor!
    var router: TestDetailProgrammeRouter!
    var subscriptions = Set<AnyCancellable>()
    let programmeSerie: Programme = Programme(id: "GAMEOFT0806W0149298", title: [Title(value: "GAME OF THRONES")], subtitle: "saisons 1 Ã  8", imageURL: "/data_plateforme/saison/1691/origin_gameofthr08w0149292_ni72q.jpg?size=small", fullScreenImageUrl: "/data_plateforme/saison/1691/origin_gameofthr08w0149292_ni72q.jpg?size=large", detailLink: "/apps/v2/details/serie/PSGAMEOFTHRW0058624")
    let serie: Seasons = Seasons(seasons: [DetailProgramme(pitch: "Dans le royaume des Sept Couronnes les familles s'unissent et s'affrontent afin de garder ou reconquérir le Trône de fer")], pitch: nil)
    
    let programmeMovie: Programme = Programme(id: "GAMEOFT0806W0149298", title: [Title(value: "LEGO MARVEL SUPERHEROES - SPIDERMAN CONTRE VENOM")], subtitle: "ados, enfants", imageURL: "/data_plateforme/saison/1691/origin_gameofthr08w0149292_ni72q.jpg?size=small", fullScreenImageUrl: "/data_plateforme/saison/1691/origin_gameofthr08w0149292_ni72q.jpg?size=large", detailLink: "/apps/v2/details/programme/LEGOMARVELSW0178383")
    let movie: Seasons = Seasons(seasons: nil, pitch: "Le Bouffon Vert et Venom s'associent pour mettre en oeuvre un plan machiavélique. Ils tentent de récupérer différentes clés qui leur permettront de détruire la ville de New York. Spiderman parviendra-t-il à les en empêcher ? Action et humour sont réunis dans ce court métrage qui met en scène Spiderman en version Lego.")
    
    override func setUp() {
        super.setUp()
        interactor = TestDetailProgrammeInteractor()
        router = TestDetailProgrammeRouter()
        presenter = DetailProgrammePresenter(interactor: interactor, router: router)
    }
    
    func testGetDetailSerieProgramme() {
        let testExpectation = expectation(description: #function)
        
        let detailProgramme = ResponsDetailProgramme(contents: serie)
        interactor.detailProgramme = detailProgramme
        
        presenter.showDetailProgrammes(detailLink: programmeSerie.detailLink).receive(on: DispatchQueue.main).sink(receiveCompletion: { (completion) in
            switch completion {
            case let .failure(error):
                print("Couldn't get programmes: \(error)")
            case .finished: break
            }
        }) { detailProgramme in
            XCTAssertEqual(detailProgramme.contents?.pitch, nil)
            XCTAssertEqual(detailProgramme.contents?.seasons?.first?.pitch, "Dans le royaume des Sept Couronnes les familles s'unissent et s'affrontent afin de garder ou reconquérir le Trône de fer")
            testExpectation.fulfill()
        }
        .store(in: &subscriptions)
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testGetDetailMovieProgramme() {
        let testExpectation = expectation(description: #function)
        
        let detailProgramme = ResponsDetailProgramme(contents: serie)
        interactor.detailProgramme = detailProgramme
        
        presenter.showDetailProgrammes(detailLink: programmeMovie.detailLink).receive(on: DispatchQueue.main).sink(receiveCompletion: { (completion) in
            switch completion {
            case let .failure(error):
                print("Couldn't get programmes: \(error)")
            case .finished: break
            }
        }) { detailProgramme in
            XCTAssertEqual(detailProgramme.contents?.pitch, "Le Bouffon Vert et Venom s'associent pour mettre en oeuvre un plan machiavélique. Ils tentent de récupérer différentes clés qui leur permettront de détruire la ville de New York. Spiderman parviendra-t-il à les en empêcher ? Action et humour sont réunis dans ce court métrage qui met en scène Spiderman en version Lego.")
            XCTAssertEqual(detailProgramme.contents?.seasons?.first?.pitch, nil)
            testExpectation.fulfill()
        }
        .store(in: &subscriptions)
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testThatItOpenVideo() {
        presenter.openVideo()
        XCTAssertTrue(router.openVideoCalled)
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

extension DetailProgrammePresenterTests {
    
    class TestDetailProgrammeRouter: DetailProgrammeRouterProtocol {
        
        var openVideoCalled = false
        
        func openVideo() {
            openVideoCalled = true
        }
        
    }
    
    class TestDetailProgrammeInteractor: DetailProgrammeInteractorProtocol {
        
        let apiService: ProgrammesAPIService = ProgrammesAPIService(networkController: NetworkController())
        var detailProgramme: ResponsDetailProgramme?
        
        func getDetailProgrammes(detailLink: String) -> AnyPublisher<ResponsDetailProgramme, Error> {
            apiService.getDetailProgrammes(detailLink: detailLink).eraseToAnyPublisher()
        }
    }
}
