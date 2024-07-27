//
//  ParticleEffect.swift
//  GhiPhatBieu
//
//  Created by Quyen DanG on 10/07/2024.
//

import SwiftUI
import AVFAudio

struct Particle: Identifiable {
    var id: UUID = .init()
    var randomX: CGFloat = 0
    var randomY: CGFloat = 0
    var scale: CGFloat = 1
    var opacity: CGFloat = 1
    
    
    mutating func reset() {
        randomX = 0
        randomY = 0
        scale = 1
        opacity = 1
    }
}

struct ParticleModifier: ViewModifier {
    var systemImage: String
    var status: Bool
    var activeTint: Color
    var inActiveTint: Color
    var isSound: Bool = true
    @State private var particles: [Particle] = []
    
   
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .top) {
                ZStack{
                    ForEach(particles) { particle in
                        Image(systemName: systemImage)
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(status ? [activeTint, .white].randomElement(): inActiveTint)
                            .scaleEffect(particle.scale)
                            .offset(x: particle.randomX, y: particle.randomY)
                            .opacity(particle.opacity)
                            .opacity(status ? 1: 0)
                            .animation(.none, value: status)
                    }
                }
                .onAppear{
                    if particles.isEmpty {
                        for _ in 1...15 {
                            var particle = Particle()
                            particles.append(particle)
                        }
                    }
                }
                .onChange(of: status) { newValue in
                    if !newValue {
                        for index in particles.indices {
                            particles[index].reset()
                        }
                    } else {
                        if isSound {
                            Helpers.shared.upStar()
                        } else
                        {}
                        for index in particles.indices {
                            let total: CGFloat = CGFloat (particles.count)
                            let progress: CGFloat = CGFloat(index) / total
                            let maxX: CGFloat = (progress > 0.5) ? 200 : -200 // default 100
                            let maxY: CGFloat = 200 // default 60
                            let randomX: CGFloat = ((progress > 0.5 ? progress - 0.5 : progress) * maxX)
                            let randomY: CGFloat = ((progress > 0.5 ? progress - 0.5 : progress) * maxY) + 35
                            
                            let randomScale: CGFloat = .random(in: 0.35...1)
                            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                                let extraRandomX: CGFloat = (progress < 0.5 ? .random(in: 0...10) : .random(in: -10...0))
                                let extraRandomY: CGFloat = .random(in: 0...30)
                                particles[index].randomX = randomX + extraRandomX
                                particles[index].randomY = -randomY - extraRandomY
                            }
                            
                            withAnimation(.easeOut(duration: 0.3)) {
                                particles[index].scale = randomScale
                            }
                            
                            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7).delay(0.25 + Double(index) * 0.005)) {
                                particles[index].scale = 0.001
                            }
                        }
                    }
                }
            }
    }
}
