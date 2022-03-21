//
//  ViewController.swift
//  playStreamM3u8
//
//  Created by Phùng Tùng on 21/03/2022.
//

import UIKit
import AVFoundation
import AVKit

class ViewController: UIViewController {
    
    @IBOutlet weak var playerContainner: UIView!
    
    let avPlayer = AVPlayer()
    let playerViewController = AVPlayerViewController()
    lazy var playerView: UIView = {
        let view = playerViewController.view!
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        play()
    }
    
    func play() {
        let urlString = "https://cph-p2p-msl.akamaized.net/hls/live/2000341/test/master.m3u8"
        guard let url = URL(string: urlString) else { return }
        playerContainner.addSubview(playerView)
        playerView.fitToSuperview()
        let asset = AVAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)
        avPlayer.replaceCurrentItem(with: playerItem)
        playerViewController.player = avPlayer
        playerViewController.player?.play()
        playerViewController.videoGravity = .resizeAspect
        
        playerViewController.player!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { (CMTime) -> Void in
            if self.playerViewController.player?.currentItem?.status == .readyToPlay {
                let time : Float64 = CMTimeGetSeconds((self.playerViewController.player!.currentTime()))
                print(time)
            }
        }
    }
}


extension UIView {
    var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.topAnchor
        } else {
            return topAnchor
        }
    }
    
    var safeBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.bottomAnchor
        } else {
            return bottomAnchor
        }
    }
    
    var safeLeadingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.leadingAnchor
        } else {
            return leadingAnchor
        }
    }
    
    var safeTrailingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.trailingAnchor
        } else {
            return trailingAnchor
        }
    }
    
    func fitToSuperview(_ edges: [UIRectEdge]? = [.all]) {
        guard let parent = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        for edge in edges ?? [.all] {
            switch edge {
            case .top:
                topAnchor.constraint(equalTo: parent.safeTopAnchor).isActive = true
                break
            case .bottom:
                bottomAnchor.constraint(equalTo: parent.safeBottomAnchor).isActive = true
                break
            case .left:
                leadingAnchor.constraint(equalTo: parent.safeLeadingAnchor).isActive = true
                break
            case .right:
                trailingAnchor.constraint(equalTo: parent.safeTrailingAnchor).isActive = true
                break
            case .all:
                leadingAnchor.constraint(equalTo: parent.safeLeadingAnchor).isActive = true
                trailingAnchor.constraint(equalTo: parent.safeTrailingAnchor).isActive = true
                topAnchor.constraint(equalTo: parent.safeTopAnchor).isActive = true
                bottomAnchor.constraint(equalTo: parent.safeBottomAnchor).isActive = true
                break
            default:
                break
            }
        }
    }
}
