//
//  Animation.swift
//  MarvelComics
//
//  Created by Artem Umanets on 12/08/2018.
//  Copyright © 2018 Seedrop. All rights reserved.
//

import UIKit

typealias AnimationCallback = () -> Void

private struct AnimationData {
    
    var duration: Double
    var delay: Double
    var options: UIViewAnimationOptions
    var animation: AnimationCallback
    var completion: AnimationCallback
    
    var totalDuration: Double { return self.delay + self.duration }
}

protocol AnimationAction {
    
    var duration: Double { get }
    
    @discardableResult func start(animated: Bool, onCompletion: @escaping AnimationCallback) -> AnimationAction
    
    func stopAnimation()
}

class ActionAnimation: AnimationAction {

    private var animationData: AnimationData
    private var completionCallback: AnimationCallback?
    var duration: Double { return self.animationData.totalDuration }
    
    init(duration: TimeInterval = 0.0, delay: TimeInterval = 0.0, options: UIViewAnimationOptions = [], animation: @escaping AnimationCallback = {}, completion: @escaping AnimationCallback = {}) {
        self.animationData = AnimationData(duration: duration, delay: delay, options: options, animation: animation, completion: completion)
    }
    
    @discardableResult
    func start(animated: Bool = true, onCompletion: @escaping AnimationCallback = {}) -> AnimationAction{
        self.completionCallback = onCompletion
        if animated {
            UIView.animate(withDuration: self.animationData.duration, delay: self.animationData.delay, options: self.animationData.options, animations: self.animationData.animation, completion: { (finished) in
                self.animationData.completion()
                if finished { onCompletion() }
            })
        } else {
            self.animationData.animation()
            self.animationData.completion()
            onCompletion()
        }
        return self
    }
    
    func stopAnimation() { }
}

class ActionSequence: AnimationAction {
    
    private var animations = [AnimationAction]()
    
    var duration: Double { return self.animations.compactMap { $0.duration }.reduce(0.0, +) }
    
    @discardableResult
    func append(_ action: AnimationAction) -> ActionSequence {

        self.animations.append(action)
        return self
    }
    
    @discardableResult
    func start(animated: Bool = true, onCompletion: @escaping AnimationCallback = {}) -> AnimationAction{
    
        guard self.animations.count > 0 else {
            onCompletion()
            return self
        }
        
        let animation = self.animations.removeFirst()
        
        animation.start(animated: animated, onCompletion: {
            self.start(animated: animated, onCompletion: onCompletion)
        })
        return self
    }
    
    func stopAnimation() { self.animations.removeAll() }
}

class ActionGroup: AnimationAction {
    
    private var animations = [AnimationAction]()
    
    var duration: Double { return self.animations.compactMap { $0.duration }.max() ?? 0.0 }
    
    @discardableResult
    func append(_ action: AnimationAction) -> ActionGroup {
        self.animations.append(action)
        return self
    }
    
    @discardableResult
    func start(animated: Bool = true, onCompletion: @escaping AnimationCallback = {}) -> AnimationAction{
        
        guard self.animations.count > 0 else {
            onCompletion()
            return self
        }
        
        var sortedAnimations = self.animations.sorted { $0.duration < $1.duration }

        let lastAnimation = sortedAnimations.removeLast()
        
        sortedAnimations.forEach { $0.start(animated: animated, onCompletion: {}) }
        lastAnimation.start(animated: animated, onCompletion: onCompletion)
        return self
    }
    
    func stopAnimation() { }
}

// MARK: Animation Bounce Scale Up & Bounce Scale Down
extension ActionAnimation {
    
    static func bounceScaleDown(element: UIView, onCompletion: @escaping AnimationCallback = {}) -> ActionSequence {
        
        return ActionSequence()
            .append(ActionAnimation(duration: UI.Animation.normal, options: [.curveEaseInOut, .beginFromCurrentState], animation: { element.transform = CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1) }))
            .append(ActionAnimation(duration: UI.Animation.normal / 1.5, options: .curveEaseInOut, animation: { element.transform = CGAffineTransform.minimumScale }, completion: onCompletion))
    }
    
    static func bounceScaleUp(element: UIView, onCompletion: @escaping AnimationCallback = {}) -> ActionSequence {
        
        return ActionSequence()
            .append(ActionAnimation(duration: UI.Animation.normal / 1.5, delay: 0.0, options: .curveEaseInOut, animation: { element.transform = CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1) }))
            .append(ActionAnimation(duration: UI.Animation.normal / 2.0, options: .curveEaseInOut, animation: { element.transform = CGAffineTransform.identity.scaledBy(x: 0.95, y: 0.95) }))
            .append(ActionAnimation(duration: UI.Animation.normal / 2.0, options: .curveEaseInOut, animation: { element.transform = CGAffineTransform.identity }, completion: onCompletion))
    }
    
    static func bounceScale(element: UIView, onTransition: @escaping AnimationCallback = {}, onCompletion: @escaping AnimationCallback = {}) -> ActionSequence {
        
        return ActionSequence()
            .append(ActionAnimation.bounceScaleDown(element: element, onCompletion: onTransition))
            .append(ActionAnimation.bounceScaleUp(element: element, onCompletion: onCompletion))
    }
}

extension CGAffineTransform {
    
    static var minimumScale: CGAffineTransform { return CGAffineTransform.identity.scaledBy(x: 0.000001, y: 0.00001) }
}
