//
//  ViewController.swift
//  0520_VideoPlayer
//
//  Created by Anna Oh on 19/5/2019.
//  Copyright © 2019 Anna Oh. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class ViewController: UIViewController {

    
        @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var videoView: UIView!
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    
    var isVideoPlaying = false
    
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
//    @IBOutlet weak var volumeSlider: UISlider!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
            //volumeSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
        let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/sprinshow19.appspot.com/o/Binging%20with%20Babish%20Master%20of%20None%20Carbonara.mp4?alt=media&token=1ff742a1-7e7e-47f6-86b9-2bdfb9b3ba40")!
        player = AVPlayer(url: url)
        
        //Slider setting///
        player.currentItem?.addObserver(self, forKeyPath: "duration", options: [.new, .initial], context: nil)
        addTimeObserver()
        playerLayer = AVPlayerLayer(player: player)
       /// lotated change layout
        playerLayer.videoGravity = .resize
        videoView.layer.addSublayer(playerLayer)
        
        ///Vertical Slider
//        volumeSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
//
//        ////////////////////////Voulme SETUP////////////////////
//        let videoVolumeView = MPVolumeView(frame: volumeSlider.frame)
//        //videoVolumeView.isHidden = false
//        videoVolumeView.alpha = 0.01
//        videoVolumeView.backgroundColor  = UIColor.clear
//        view.addSubview(videoVolumeView)
//
//        self.volumeSlider.alpha = 0.0
//        self.view.bringSubviewToFront(self.volumeSlider)
        
//        NotificationCenter.default.addObserver(self,selector: #selector(volumeDidChange(notification:)),
//                                               name: NSNotification.Name(rawValue: "AVSystemController_SystemVolumeDidChangeNotification"), object: nil)

    }
    
//    @objc func volumeDidChange(notification: NSNotification) {
//        let volume = notification.userInfo! ["AVSystemController_AudioVolumeNotificationParameter"] as! Float
//        self.volumeSlider.alpha = 1.0
//        volumeSlider.value = volume
//
//        UIView.animate(withDuration: 0.8, delay: 3, options: .curveEaseOut, animations: {[weak self] in
//            self?.volumeSlider.alpha = 0.0}, completion: nil)
//    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        player.play()
//    }
    
    
    override func viewDidLayoutSubviews() {
         super.viewDidLayoutSubviews()
          playerLayer.frame = videoView.bounds
    }
    
    func addTimeObserver(){
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        let mainQueue = DispatchQueue.main
        _=player.addPeriodicTimeObserver(forInterval: interval, queue: mainQueue, using: { [weak self]
            time in
            guard let currentItem = self?.player.currentItem else {return}
            self?.timeSlider.maximumValue = Float(currentItem.duration.seconds)
            self?.timeSlider.minimumValue = 0
            self?.timeSlider.value = Float(currentItem.currentTime().seconds)
            self?.currentTimeLabel.text = self?.getTimeString(from:currentItem.currentTime())
            
        })
    }
        
 
    @IBAction func playpressed(_ sender: UIButton) {
        
        if isVideoPlaying {
             player.pause()
            sender.setTitle("PLAY", for: .normal)
        } else  {
            player.play ()
            sender.setTitle("PAUSE", for: .normal)
        }
          isVideoPlaying =  !isVideoPlaying
    }
    
    
    @IBAction func rewindepressed(_ sender: Any) {
        let currentTime = CMTimeGetSeconds(player.currentTime())
        var newTime = currentTime - 5.0
        
        if newTime < 0 {
           newTime = 0
        }
        let time: CMTime = CMTimeMake(value: Int64(newTime*1000), timescale: 1000)
        player.seek(to: time)
    }
    
    
 
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        player.seek(to: CMTimeMake(value: Int64(sender.value*1000),timescale: 1000))
    
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if keyPath == "duration", let duration = player.currentItem?.duration.seconds, duration > 0.0 {
            self.durationLabel.text = getTimeString(from: player.currentItem!.duration)
            }
        }
    
    @IBAction func vloumeSliderValueChange(_sender:UISlider){
       player.volume = volumeSlider.value;
    }
 
    func getTimeString(from time : CMTime) -> String {
        let totalSeconds = CMTimeGetSeconds(time)
        let hours = Int (totalSeconds/3600)
        let minutes = Int(totalSeconds/60)%60
        let seconds = Int(totalSeconds.truncatingRemainder(dividingBy: 60))
        if hours > 0 {
            return String(format: "%i:%02i:%02i", arguments: [hours,minutes,seconds])
        } else {
            return String(format: "%02i:%02i", arguments: [minutes,seconds])
        }
        
    }
}

