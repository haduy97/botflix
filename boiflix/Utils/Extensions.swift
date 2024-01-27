//
//  Extensions.swift
//  boiflix
//
//  Created by Duy Ha on 20/12/2023.
//

import Foundation
import UIKit
import Toast

fileprivate var spinnerView: UIView?
fileprivate let boiflixLogo: UIImage? = {
    var image = UIImage(named: "boiflixLogo")
    image = image?.withRenderingMode(.alwaysOriginal)
    
    return image
}()

extension String {
    //Auto capital first letter in character
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}

extension UIColor {
    // add hex code color
    public convenience init(hex:String) {
        var r = 0, g = 0, b = 0, a = 255

        let hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let offset = hexString.hasPrefix("#") ? 1 : 0
        let ch = hexString.map{$0}
        
        switch(ch.count - offset) {
        case 8:
            a = 16 * (ch[offset+6].hexDigitValue ?? 0) + (ch[offset+7].hexDigitValue ?? 0)
            fallthrough
        case 6:
            r = 16 * (ch[offset+0].hexDigitValue ?? 0) + (ch[offset+1].hexDigitValue ?? 0)
            g = 16 * (ch[offset+2].hexDigitValue ?? 0) + (ch[offset+3].hexDigitValue ?? 0)
            b = 16 * (ch[offset+4].hexDigitValue ?? 0) + (ch[offset+5].hexDigitValue ?? 0)
            break
        case 4:
            a = 16 * (ch[offset+3].hexDigitValue ?? 0) + (ch[offset+3].hexDigitValue ?? 0)
            fallthrough
        case 3:  // Three digit #0D3 is the same as six digit #00DD33
            r = 16 * (ch[offset+0].hexDigitValue ?? 0) + (ch[offset+0].hexDigitValue ?? 0)
            g = 16 * (ch[offset+1].hexDigitValue ?? 0) + (ch[offset+1].hexDigitValue ?? 0)
            b = 16 * (ch[offset+2].hexDigitValue ?? 0) + (ch[offset+2].hexDigitValue ?? 0)
            break
        default:
            a = 0
            break
        }
        self.init(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: CGFloat(a)/255)
    }
}

extension UIViewController {
    public func showLoading() {
        spinnerView = UIView(frame: self.view.bounds)
        spinnerView?.backgroundColor = .black.withAlphaComponent(0.7)
        
        let iv = UIImageView(image: boiflixLogo)
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        spinnerView?.addSubview(iv)
        
        applyConstraints(for: iv, in: spinnerView!)
        
        UIView.transition(with: self.view, duration: 0.4, options: .transitionCrossDissolve) { [weak self] in
            self?.view.addSubview(spinnerView!)
        }
        
        animatedFadeInOutImage(iv)
    }
    
    public func hideLoading() {
        UIView.transition(with: self.view, duration: 0.4, options: .transitionCrossDissolve) {
            spinnerView?.removeFromSuperview()
            spinnerView = nil
        }
    }
    
    public func popUpToast(title main: String, subTitle sub: String, dismissTime dismiss: CGFloat = 4.0) -> Toast? {
        guard main.count > 0 else { return nil }
        
        let config = ToastConfiguration(
            direction: .bottom,
            dismissBy: [.time(time: dismiss), .tap],
            animationTime: 0.2
        )
        
        let toast = Toast.text(main, subtitle: sub, config: config)
        
        return toast
    }
    
    public func popUpToastFailed() {
        popUpToast(title: "Failed", subTitle: "Something when wrong please try again later", dismissTime: 2.3)?.show()
    }
    
    private func applyConstraints(for view: UIView, in superview: UIView){
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: superview.centerYAnchor),
            view.widthAnchor.constraint(equalTo: superview.widthAnchor, multiplier: 0.15),
            view.heightAnchor.constraint(equalTo: superview.heightAnchor, multiplier: 0.15)
        ])
    }
    
    private func animatedSkakeLogo(_ imageView: UIImageView) {
        let shakeAnimation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        shakeAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        shakeAnimation.values = [-7, 7, -7, 7, -5, 5, -5, 5, 0]
        shakeAnimation.duration = 1.1
        shakeAnimation.repeatCount = .infinity

        imageView.layer.add(shakeAnimation, forKey: "shake")
    }
    
    private func animatedFadeInOutImage(_ imageView: UIImageView) {
        UIView.animate(withDuration: 0.5, delay: 0, options: [.repeat, .autoreverse]) {
            imageView.alpha = 0.1
        }
    }
    
}

extension UITableViewCell {
    public func popUpToast(title main: String, subTitle sub: String, dismissTime dismiss: CGFloat = 4.0) -> Toast? {
        guard main.count > 0 else { return nil }
        
        let config = ToastConfiguration(
            direction: .bottom,
            dismissBy: [.time(time: dismiss), .tap],
            animationTime: 0.2
        )
        
        let toast = Toast.text(main, subtitle: sub, config: config)
        
        return toast
    }
}
