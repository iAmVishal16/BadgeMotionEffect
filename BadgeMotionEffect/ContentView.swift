//
//  ContentView.swift
//  Experiments
//
//  Created by Vishal Paliwal on 06/07/23.
//

import SwiftUI
import CoreMotion
import SpriteKit

class MotionManager: ObservableObject {
    let motionManager = CMMotionManager()
    @Published var x = 0.0
    @Published var y = 0.0
    
    init() {
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] data, error in

            guard let motion = data?.attitude else { return }
            self?.x = motion.roll
            self?.y = motion.pitch
        }
    }
}

struct ContentView: View {
    
    @State private var isShadow = true
    
    @State var backDegree = 90.0
    @State var frontDegree = 0.0
    @State var isFlipped = false

    let durationAndDelay : CGFloat = 0.3
        
    var body: some View {
        ZStack {
            Image("bg")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            ZStack {
                BadgeFront(degree: $frontDegree)
                BadgeBack(degree: $backDegree)
            }.onTapGesture {
                flipCard ()
            }
            
        }
    }
    
    //MARK: Flip Card Function
        func flipCard () {
            isFlipped = !isFlipped
            if isFlipped {
                withAnimation(.linear(duration: durationAndDelay)) {
                    backDegree = 90
                }
                withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)){
                    frontDegree = 0
                }
            } else {
                withAnimation(.linear(duration: durationAndDelay)) {
                    frontDegree = -90
                }
                withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)){
                    backDegree = 0
                }
            }
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct BadgeFront : View {
    @Binding var degree : Double
    
    @State private var isShadow = true
    @State private var onAppeared = false

    @StateObject private var motion = MotionManager()

//    private var magnitude = 50.0

    private var scene: SKScene {
        let scene = MagicScene()
        scene.scaleMode = .resizeFill
        scene.backgroundColor = .clear
        return scene
    }
    
    var BadgeNumberText: some View {
        Text("1")
            .font(.custom("Caprasimo-Regular", size: 160)).bold()
            .fontWeight(.black)
            .foregroundColor(Color(red: 252 / 255, green: 232 / 255, blue: 82 / 255))
            .offset(y: -20)
    }
    
    var BadgeLevelUp: some View {
        Text("LEVEL UP")
            .font(.custom("Caprasimo-Regular", size: 30)).bold()
            .fontWeight(.black)
            .foregroundColor(.white)
            .offset(y: -40)
    }

    var body: some View {
        ZStack {
            
            if onAppeared {
                SpriteView(scene: scene, options: [.allowsTransparency])
            }

            
            BadgeBackground(isShadow: $isShadow)
                .overlay(content: {
                    ZStack {
                        LinearGradient(colors: [.red, .red, .orange], startPoint: .leading, endPoint: .trailing)
                            .mask {
                                BadgeBackground(isShadow: .constant(false))
                                    .frame(width: 380, height: 400, alignment: .center)
                            }
                        
                        Image("bg1")
                            .resizable()
                            .scaledToFill()
                            .offset(x: CGFloat(motion.x * Double(50)), y: CGFloat(motion.y * 50))
                            .mask {
                                BadgeBackground(isShadow: .constant(false))
                                    .frame(width: 360, height: 380, alignment: .center)
                            }
                            .rotation3DEffect(.degrees(motion.x * 25), axis: (x: 0, y: 1, z: 0))
                            .rotation3DEffect(.degrees(motion.y * 25), axis: (x: -1, y: 0, z: 0))
                        
                        VStack(spacing: 0) {
                            BadgeNumberText
                                .offset(y: motion.y * 5)
                                .hueRotation(.degrees(motion.y * 360))
                                .rotation3DEffect(.degrees(motion.x * 5), axis: (x: 0, y: 1, z: 0))
                                .rotation3DEffect(.degrees(motion.y * 5), axis: (x: -1, y: 0, z: 0))
                                .overlay(BadgeNumberText.blendMode(.hue))
                                .overlay(BadgeNumberText.foregroundColor(.black).blendMode(.overlay))
                            
                            BadgeLevelUp
                                .hueRotation(.degrees(motion.x * 360))
                                .overlay(BadgeLevelUp.blendMode(.hue))
                                .overlay(BadgeLevelUp.foregroundColor(.black).blendMode(.overlay))
                            
                        }
                        
                    }
                    })
                .rotation3DEffect(.degrees(motion.x * 5), axis: (x: 0, y: 1, z: 0))
                .rotation3DEffect(.degrees(motion.y * 5), axis: (x: -1, y: 0, z: 0))
                .offset(x: CGFloat(motion.x * Double(50)), y: CGFloat(motion.y * 50))

            HStack (spacing: -16) {
                Image("star")
                    .resizable()
                    .frame(width: 60, height: 60)
                Image("star")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .offset(y: 20)
                Image("star")
                    .resizable()
                    .frame(width: 60, height: 60)
            }
            .offset(y: 120)
            .rotation3DEffect(.degrees(motion.x * 5), axis: (x: 0, y: 1, z: 0))
            .rotation3DEffect(.degrees(motion.y * 5), axis: (x: -1, y: 0, z: 0))

            
        }.rotation3DEffect(Angle(degrees: degree), axis: (x: 0, y: 1, z: 0))
            .onAppear {
                onAppeared = true
            }
            .onDisappear {
                onAppeared = false
            }
    }
}

struct BadgeBack : View {
    @Binding var degree : Double
    @State private var isShadow = true

    var body: some View {
        ZStack {
            
            BadgeBackground(isShadow: $isShadow)
                .overlay(content: {
                    ZStack {
                        LinearGradient(colors: [.black, .black, .gray], startPoint: .top, endPoint: .bottom)
                            .mask {
                                BadgeBackground(isShadow: .constant(false))
                                    .frame(width: 380, height: 400, alignment: .center)
                            }
                        
                        VStack (alignment: .center, spacing: 32) {
                            Text("Earned this Badge for Going extra mile!")
                                .frame(width: 300)
                                .font(.subheadline).bold()
                                .fontWeight(.thin)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white.opacity(0.8))

                            Text("iamvishal16 © 2023")
                                .font(.caption).bold()
                                .fontWeight(.black)
                                .foregroundColor(.white.opacity(0.4))
                        }
                        .padding()
                    }
                })
        }.rotation3DEffect(Angle(degrees: degree), axis: (x: 0, y: 1, z: 0))
    }
}
