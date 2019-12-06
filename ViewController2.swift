//
//  ViewController2.swift
//  RecordAudio
//
//  Created by Bé Dũn on 11/29/19.
//  Copyright © 2019 TVD. All rights reserved.
//
import UIKit
import AVFoundation
import Ripples

class ViewController2 : UIViewController {
    
    @IBOutlet weak var viewRecord: UIView!
    @IBOutlet weak var volumeMeter: UIProgressView!
    let ripple = Ripples()
    var recorder: AVAudioRecorder!
    var levelTimer = Timer()
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var soundbutton: UIButton!
    
    let LEVEL_THRESHOLD: Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ripple.radius = 200
        ripple.rippleCount = 10
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        ripple.position = viewRecord.center
        ripple.position = soundbutton.center
    }
    
    @IBAction func recordButtonTapped(_ sender: Any) {
        ripple.radius = 200
        ripple.rippleCount = 10
        view.layer.addSublayer(ripple)
        ripple.stop()
        RecordAudio()
    }
    
    @IBAction func playAudioTapped(_ sender: Any) {
        ripple.radius = 200
        ripple.rippleCount = 10
        view.layer.addSublayer(ripple)
        ripple.start()
        RecordAudio()
    }
    
    func RecordAudio(){
        
        let documents = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0])
        let url = documents.appendingPathComponent("record.caf")
        
        let recordSettings: [String: Any] = [
            AVFormatIDKey:              kAudioFormatAppleIMA4,
            AVSampleRateKey:            44100.0,
            AVNumberOfChannelsKey:      2,
            AVEncoderBitRateKey:        12800,
            AVLinearPCMBitDepthKey:     16,
            AVEncoderAudioQualityKey:   AVAudioQuality.max.rawValue
        ]
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.playAndRecord)
            try audioSession.setActive(true)
            try recorder = AVAudioRecorder(url:url, settings: recordSettings)
            
        } catch {
            return
        }
        
        recorder.prepareToRecord()
        recorder.isMeteringEnabled = true
        recorder.record()
        
        levelTimer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(levelTimerCallback), userInfo: nil, repeats: true)
        
    }
    
    @objc func levelTimerCallback() {
        recorder.updateMeters()
        
        let level = recorder.averagePower(forChannel: 0)
        let isLoud = level > LEVEL_THRESHOLD
        print(-10/level)
        volumeMeter.progress = -10/level
        
        // do whatever you want with isLoud
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
