//
//  RecorderView.swift
//  RecordAndPlay
//
//  Created by Olga Melnik on 14.01.2020.
//  Copyright © 2020 Olga Melnik. All rights reserved.
//

import UIKit


class RecorderView: UIView {

    let recordButton = UIButton()
    let playButton = UIButton()
    let saveButton = UIButton()
    let slider = UISlider()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureUI()
    }
    
    private func configureUI() {
        self.backgroundColor = UIColor.screenBG
        addRecordButton()
         self.setupRecordButtonConstraints()
        
    }
    
    
    //MARK: Subviews
    private func addRecordButton() {
        self.recordButton.translatesAutoresizingMaskIntoConstraints = false
        self.recordButton.setTitle("Record", for: .normal)
        self.recordButton.backgroundColor = UIColor.recordOff
        self.recordButton.layer.cornerRadius = self.recordButton.bounds.height/2
        self.recordButton.layer.masksToBounds = true
        self.addSubview(recordButton)
    }
    
    func addPlayButton() {
        self.playButton.translatesAutoresizingMaskIntoConstraints = false
        self.playButton.setTitle("Play", for: .normal)
        self.playButton.backgroundColor = UIColor.playButtonOff
        self.addSubview(playButton)
    }
    
    func addSaveButton () {
        self.saveButton.translatesAutoresizingMaskIntoConstraints = false
        self.saveButton.setTitle("Save", for: .normal)
        self.addSubview(saveButton)
        
    }
    
    func addSlider () {
        self.slider.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(slider)
        
    }
    
    //MARK: Constraints
    private func setupRecordButtonConstraints() {
         //let safeArea = self.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.recordButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30),
            self.recordButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.recordButton.widthAnchor.constraint(equalToConstant: 250.0)
            
        ])
    }
    
   func setupPlayButtonConstraints() {
        NSLayoutConstraint.activate([
            self.playButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.playButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.playButton.widthAnchor.constraint(equalToConstant: 250.0),
            self.playButton.heightAnchor.constraint(equalToConstant: 250.0)
            
        ])
    }
    
 func setupSaveButtonConstraints() {
        NSLayoutConstraint.activate([
            self.saveButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 30.0),
            self.saveButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30.0),
            self.saveButton.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func setupSliderConstraints() {
        NSLayoutConstraint.activate([
            self.slider.leadingAnchor.constraint(equalTo: playButton.leadingAnchor),
            self.slider.trailingAnchor.constraint(equalTo: playButton.trailingAnchor),
            self.slider.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 40.0)
        ])
    }
}
