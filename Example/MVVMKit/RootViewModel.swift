//
//  RootViewModel.swift
//  MVVMKit_Example
//
//  Created by Alfonso Grillo on 13/03/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import MVVMKit
import UIKit

class RootViewModel: CoordinatedBaseViewModel {
    typealias CoordinatorType = RootCoordinator
    var weakBinder: WeakReference<Binder>?
    var coordinator: RootCoordinator
    
    private let model: RootModel
    
    init(model: RootModel, coordinator: RootCoordinator) {
        self.coordinator = coordinator
        self.model = model
    }
    
    func didSelectBasicViewController() {
        coordinator.didSelectBasicViewController()
    }
    
    func didSelectTableViewController() {
        coordinator.didSelectTableViewController()
    }
    
    func didSelectCollectionViewController() {
        coordinator.didSelectCollectionViewController()
    }
    
    func didSelectEmbeddedViewController() {
        coordinator.didSelectEmbeddedViewController()
    }
}
