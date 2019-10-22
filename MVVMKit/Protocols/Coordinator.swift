/*
 Coordinator.swift
 
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

/**
 A convenience base protocol for coordinators
 */
public protocol Coordinator: class {
    associatedtype ViewController: UIViewController
    var weakSourceViewController: WeakReference<ViewController>? { get set }
}

public extension Coordinator {
    // A convenience property to get and set the source view controller
    var sourceViewController: ViewController? {
        get { return weakSourceViewController?.object }
        set { weakSourceViewController = WeakReference(newValue) }
    }
}

/**
 A protocols identifying a coordinator owner
 */
public protocol CoordinatorOwner: class {
    associatedtype CoordinatorType: Coordinator = EmptyCoordinator
    var coordinator: CoordinatorType { get }
}

/**
 A convenience empty coordinator
 */
public class EmptyCoordinator: Coordinator {
    public typealias ViewController = UIViewController
    
    public var weakSourceViewController: WeakReference<UIViewController>?
    
    init(sourceViewController: ViewController) {
        self.sourceViewController = sourceViewController
    }
}
