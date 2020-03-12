//
//  Utils.swift
//  RecordAndPlay
//
//  Created by Olga Melnik on 14.01.2020.
//  Copyright © 2020 Olga Melnik. All rights reserved.
//

import Foundation

var appHasMicAccess = true

enum AudioStatus: Int, CustomStringConvertible {
  case stopped = 0,
  playing,
  recording
  
  var audioName: String {
    let audioNames = [
      "Audio: Stopped",
      "Audio:Playing",
      "Audio:Recording"]
    return audioNames[rawValue]
  }
  
  var description: String {
    return audioName
  }
}
