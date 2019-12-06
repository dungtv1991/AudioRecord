//
//  ViewController.swift
//  RecordAudio
//
//  Created by Bé Dũn on 11/28/19.
//  Copyright © 2019 TVD. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Ripples

class ViewController: UIViewController,AVAudioRecorderDelegate {
    
    var pulseEffect:LFTPulseAnimation!
    var isRecord = true
    let ripple = Ripples()
    var recorder = AudioRecord.shared
    
    @IBOutlet weak var paly: UIButton!
    @IBOutlet weak var record: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        recorder.recordName = "music"
        
        
    }
    @IBAction func record(_ sender: Any) {
        if isRecord {
            self.record.setTitle("Stop", for: .normal)
            recorder.record()
            
            isRecord = false
        }else {
            self.record.setTitle("Start", for: .normal)
            recorder.stop()
            isRecord = true
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        ripple.position = paly.center
    }
    
    @IBAction func play(_ sender: Any) {
        
        recorder.play()
        ripple.radius = 100
        ripple.rippleCount = 5
        view.layer.addSublayer(ripple)
        
        ripple.start()
        
    }
}

