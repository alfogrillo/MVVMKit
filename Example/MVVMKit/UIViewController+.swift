//
//  UIViewController+.swift
//  MVVMKit_Example
//
//  Created by Alfonso Grillo on 13/03/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

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
