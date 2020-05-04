/*
 UIViewController+.swift
 
 Copyright (c) 2019 Alfonso Grillo
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

import UIKit

@objc public protocol StoryboardLoadable where Self: UIViewController { }

extension StoryboardLoadable {
    static public func instantiate(storyboardName: String, storyboardIdentifier: String? = Self.storyboardIdentifier, bundle: Bundle? = Bundle(for: Self.self)) -> Self {
        let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
        
        if let storyboardIdentifier = storyboardIdentifier {
            return storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as! Self
        } else {
            return storyboard.instantiateInitialViewController() as! Self
        }
    }
}

@objc extension UIViewController: StoryboardLoadable {
    /// The default Storyboard identifer for a UIViewController
    public static var storyboardIdentifier: String {
        return String(describing: self)
    }
}

internal extension UIViewController {
    func embed(child: UIViewController, in view: UIView) {
        child.willMove(toParent: self)
        view.addSubview(child.view)
        addChild(child)
        child.view.frame = view.bounds
        child.didMove(toParent: self)
    }
    
    func removeEmbeddingFromParent() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
        didMove(toParent: nil)
    }
}
