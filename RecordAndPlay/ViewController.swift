//
//  ViewController.swift
//  RecordAndPlay
//
//  Created by Olga Melnik on 14.01.2020.
//  Copyright © 2020 Olga Melnik. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
   private var recordView: RecorderView {
       return self.view as! RecorderView
   }
    
    var audioStatus: AudioStatus = AudioStatus.stopped
    
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    
    //MARK: -setup
    override func loadView() {
        super.loadView()
        self.view = RecorderView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // notification
        let nc = NotificationCenter.default
        let session = AVAudioSession.sharedInstance()
        nc.addObserver(self, selector: #selector(handleInterruption(notification:)), name: AVAudioSession.interruptionNotification, object: session)
        nc.addObserver(self, selector: #selector(handleRouteChange(notification:)), name: AVAudioSession.routeChangeNotification, object: session)
        setupRecorder()
        recordView.recordButton.addTarget(self, action: #selector(recordOn), for: .touchUpInside)
        recordView.playButton.addTarget(self, action: #selector(playOn), for: .touchUpInside)
        
    }

    @objc func recordOn() {
        if appHasMicAccess == true {
            if audioStatus != .playing {
                switch audioStatus {
                case .stopped:
                    recordView.recordButton.setTitle("Stop", for: .normal)
                    recordView.recordButton.backgroundColor = UIColor.recordOn
                    record()
                   
                case .recording:
                    recordView.recordButton.setTitle("Record", for: .normal)
                    recordView.recordButton.backgroundColor = UIColor.recordOff
                    stopRecording()
                    self.recordView.addPlayButton()
                    self.recordView.setupPlayButtonConstraints()
                    self.recordView.addSaveButton()
                    self.recordView.setupSaveButtonConstraints()
                    self.recordView.addSlider()
                    self.recordView.setupSliderConstraints()
                    self.recordView.slider.minimumValue = 0.0
                    self.recordView.slider.maximumValue = 100.0
                default:
                    break
                }
            }
        } else {
            recordView.recordButton.isEnabled = false
        }
    }
    
    @objc func playOn() {
        if audioStatus != .recording {
            switch audioStatus {
            case .stopped:
                
                play()
                
                
            case .playing:
                stopPlayBack()
            default:
                break
            }
        }
    }
    
    func setPlayButtonOn(flag: Bool) {
        if flag == true {
            recordView.playButton.setTitle("Stop", for: .normal)
            recordView.playButton.backgroundColor = UIColor.playButtonOn
        } else {
            recordView.playButton.setTitle("Play", for: .normal)
            recordView.playButton.backgroundColor = UIColor.playButtonOff
        }
    }
}

//MARK: - AVFoundation Methods
extension ViewController: AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    
    //MARK: Recording
    
    func setupRecorder() {
        let fileURL = getURLforMemo()
            //.appendingPathComponent("recording.m4a")
        let recordSettings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue] as [String : Any]
        
        do {
            audioRecorder = try AVAudioRecorder(url: fileURL, settings: recordSettings)
            audioRecorder.delegate = self
            audioRecorder.prepareToRecord()
        } catch {
            print("Error happened while setupRecorder")
        }
    }
    
    func record() {
        audioStatus = .recording
        audioRecorder.record()
    }
    
    func stopRecording() {
        recordView.recordButton.setTitle("Record", for: .normal)
        recordView.recordButton.backgroundColor = UIColor.recordOff
        audioStatus = .stopped
        audioRecorder.stop()
    }
    func play() {
        let fileURL = getURLforMemo()
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
            audioPlayer.delegate = self
            if audioPlayer.duration > 0.0 {
                setPlayButtonOn(flag: true)
                
             //   self.recordView.slider.setValue(Float(audioPlayer.duration), animated: true)
//                self.recordView.slider.maximumValue = Float(audioPlayer.duration)
//                valueOfSliderChanged(slider: self.recordView.slider, audioPlayer: audioPlayer, for: .valueChanged)
//                self.recordView.slider.addTarget(self, action: #selector(sliderAction(_:)), for: .valueChanged)
                
                audioPlayer.play()
                self.recordView.slider.maximumValue = Float(audioPlayer.duration)
                valueOfSliderChanged(slider: self.recordView.slider, audioPlayer: audioPlayer, for: .valueChanged)
                audioStatus = .playing
            }
        } catch {
            print("Error happened while play")
        }
    }
    
    private func valueOfSliderChanged(slider: UISlider, audioPlayer: AVAudioPlayer, for: UIControl.Event) {
        audioPlayer.currentTime = TimeInterval(slider.value)
    }
    
    

    func stopPlayBack() {
        setPlayButtonOn(flag: false)
        audioStatus = .stopped
        audioPlayer.stop()
    }
    
    //MARK: Delegates
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        audioStatus = .stopped
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        setPlayButtonOn(flag: false)
             audioStatus = .stopped
    }
    
    //MARK: Notifications
    @objc func handleInterruption(notification: NSNotification) {
        if let info = notification.userInfo {
            let type = AVAudioSession.InterruptionType(rawValue: info [AVAudioSessionInterruptionTypeKey] as! UInt)
            if type == .began {
                if audioStatus == .playing {
                    stopPlayBack()
                } else if audioStatus == .recording {
                    stopRecording()
                }
            } else {
                let options = AVAudioSession.InterruptionOptions(rawValue: info[AVAudioSessionInterruptionTypeKey] as! UInt)
                if options == .shouldResume {
                    
                }
            }
        }
    }
    
    @objc func handleRouteChange (notification: NSNotification) {
        if let info = notification.userInfo {
            let reason = AVAudioSession.RouteChangeReason(rawValue: info[AVAudioSessionRouteChangeReasonKey] as! UInt)
            if reason == .oldDeviceUnavailable {
                let previousRoute = info[AVAudioSessionRouteChangePreviousRouteKey] as? AVAudioSessionRouteDescription
                let previousOutput = previousRoute!.outputs.first!
                if previousOutput.portType == AVAudioSession.Port.headphones {
                    if audioStatus == .playing {
                        stopPlayBack()
                    } else if audioStatus == .recording {
                        stopRecording()
                    }
                }
            }
        }
    }
    func getURLforMemo() -> URL {
        // найти лучшее место сохранинения записей
       let tempDir = NSTemporaryDirectory()
//        let date = Date()
//        let filePath = tempDir + "/tempoMemo.m4p"
        let path = FileManager()
        let filePath = path[0] + "/tempoMemo.m4p"
        return filePath
//        let path = FileManager.default.ur
//        return URL(fileURLWithPath: filePath)
    }
}

