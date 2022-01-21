//
//  DetailProgrammeViewController.swift
//  OCS
//
//  Created by aymen braham on 20/01/2022.
//

import UIKit
import AVKit
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
        if let detailLink = programme?.detailLink {
            getDetailProgramme(detailLink: detailLink)
        }
    }
    
    // MARK: - SetUp UI
    
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
                if let urlimage = self.programme?.imageURL {
                    let urle = baseUrlImage + urlimage
                    self.programmeImage.kf.indicatorType = .activity
                    let url = URL(string: urle)
                    self.programmeImage.kf.setImage(with: url)
                }
                if let saison = self.model?.contents?.seasons {
                    self.programmePitch.text = saison[0]?.pitch
                } else if let pitch = self.model?.contents?.pitch {
                    self.programmePitch.text = pitch
                }
                self.programmeTitle.text = self.programme?.title?[0].value
                self.programmeSubtitle.text = self.programme?.subtitle
            }
            .store(in: &subscriptions)
        }
    }
    
    private func updateModel(detail: String ) {
        self.programmePitch.text = detail
    }
    
    // MARK: - UserInteraction
    
    @IBAction func playButtonAction(_ sender: Any) {
        let videoURL = URL(string: urlVideo)
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
}
