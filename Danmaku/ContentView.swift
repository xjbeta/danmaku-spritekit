//
//  ContentView.swift
//  Danmaku
//
//  Created by xjbeta on 1/3/22.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    var scene: SKScene = {
        let s = DanmakuScene(size: .init(width: 720, height: 480))
        return s
    }()
    
    var body: some View {
        VStack {
            SpriteView(scene: scene).padding()
            Button("Pause") {
                scene.isPaused = !scene.isPaused
            }
        }
        
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
