//
//  DetailProgrammeRouter.swift
//  OCS
//
//  Created by aymen braham on 23/01/2022.
//

import Foundation
import AVKit

protocol DetailProgrammeRouterProtocol {
    func openVideo()
}

class DetailProgrammeRouter: DetailProgrammeRouterProtocol {
    
    let currentViewController: UIViewController
    
    init(currentViewController: UIViewController) {
        self.currentViewController = currentViewController
    }
    
    func openVideo() {
        let videoURL = URL(string: urlVideo)
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        currentViewController.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
}
