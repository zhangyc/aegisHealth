//
//  EnergyBodyLottieView.swift
//  LuluHealth
//
//  Created by Codex on 2026/5/6.
//

import Lottie
import SwiftUI

struct EnergyBodyLottieView: UIViewRepresentable {
    let animationName: String

    init(animationName: String = "energy-body") {
        self.animationName = animationName
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> LottieAnimationView {
        let animationView = LottieAnimationView()
        animationView.animation = .named(animationName)
        animationView.loopMode = .loop
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.contentMode = .scaleAspectFit
        animationView.shouldRasterizeWhenIdle = true
        context.coordinator.loadedAnimationName = animationName
        animationView.play()
        return animationView
    }

    func updateUIView(_ animationView: LottieAnimationView, context: Context) {
        if context.coordinator.loadedAnimationName != animationName {
            animationView.animation = .named(animationName)
            context.coordinator.loadedAnimationName = animationName
            animationView.play()
        } else if !animationView.isAnimationPlaying {
            animationView.play()
        }
    }
}

extension EnergyBodyLottieView {
    final class Coordinator {
        var loadedAnimationName: String?
    }
}
