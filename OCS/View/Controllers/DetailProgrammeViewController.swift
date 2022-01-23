//
//  DetailProgrammeViewController.swift
//  OCS
//
//  Created by aymen braham on 20/01/2022.
//

import UIKit
import Combine
import Kingfisher

class DetailProgrammeViewController: UIViewController {
    
    // MARK: -Outlets
    @IBOutlet weak var programmeImage: UIImageView!
    @IBOutlet weak var programmeTitle: UILabel!
    @IBOutlet weak var programmeSubtitle: UILabel!
    @IBOutlet weak var programmePitch: UITextView!
    @IBOutlet weak var playButton: UIButton!
    
    // MARK: - Variables
    public var buttonPressedSubject = PassthroughSubject<Void, Never>()
    var presenter: DetailProgrammesPresenterProtocol!
    var model: ResponsDetailProgramme?
    var programme: Programme?
    var subscriptions = Set<AnyCancellable>()
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        if let detailLink = programme?.detailLink {
            getDetailProgramme(detailLink: detailLink)
        }
    }
    
    // MARK: - SetUp UI
    private func setUpUI() {
        self.programmeTitle.text = self.programme?.title?[0].value
        self.programmeSubtitle.text = self.programme?.subtitle
        if let urlimage = self.programme?.imageURL {
            let fullURL = baseUrlImage + urlimage
            self.programmeImage.kf.indicatorType = .activity
            let url = URL(string: fullURL)
            self.programmeImage.kf.setImage(with: url)
        }
    }
    
    // MARK: - Get Programme Detail
    private func getDetailProgramme(detailLink: String) {
        if let detailLink = self.programme?.detailLink {
            presenter?.showDetailProgrammes(detailLink: detailLink).receive(on: DispatchQueue.main).sink(receiveCompletion: { (completion) in
                switch completion {
                case let .failure(error):
                    print("Couldn't get detail programme: \(error)")
                case .finished: break
                }
            }) { detailProgrammes in
                self.model = detailProgrammes
                if let saison = self.model?.contents?.seasons {
                    self.programmePitch.text = saison[0].pitch
                } else if let pitch = self.model?.contents?.pitch {
                    self.programmePitch.text = pitch
                }
            }
            .store(in: &subscriptions)
        }
    }
    
    // MARK: - UserInteraction
    @IBAction func playButtonAction(_ sender: Any) {
        presenter?.openVideo()
    }
}
