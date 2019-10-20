//
//  ReactiveViewModel.swift
//  MVVMKit
//
//  Created by Alfonso on 20/10/2019.
//

#if canImport(Combine)

/**
 A convenience base protocol for reactive view models
 */
@available(iOS 13.0, *)
public protocol ReactiveViewModel { }

/**
 RootViewModel instances that are reactive don't need the binder reference.
 */
@available(iOS 13.0, *)
public extension RootViewModel where Self: ReactiveViewModel {
    var weakBinder: WeakReference<BinderType>? {
        get { nil }
        //swiftlint:disable:next unused_setter_value
        set { }
    }
}

#endif
