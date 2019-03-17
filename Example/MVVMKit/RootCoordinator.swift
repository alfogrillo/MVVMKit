/*
 RootCoordinator.swift
 
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

import MVVMKit

class RootCoordinator: Coordinator {
    var weakSourceViewController: WeakReference<UIViewController>?
    private let model: RootModel
    
    init(model: RootModel, sourceViewController viewController: UIViewController) {
        self.model = model
        sourceViewController = viewController
    }
    
    func didSelectBasicViewController() {
        let viewController = BasicViewController.instantiate(storyboardName: "Main")
        viewController.viewModel = BasicViewModel(model: model.basicModel)
        sourceViewController?.show(viewController, sender: nil)
    }
    
    func didSelectTableViewController() {
        let viewController = ColorsViewController.instantiate(storyboardName: "Main")
        viewController.viewModel = ColorsViewModel(model: model.colorsModel)
        sourceViewController?.show(viewController, sender: nil)
    }
    
    func didSelectCollectionViewController() {
        let viewController = GiphyViewController.instantiate(storyboardName: "Main")
        viewController.viewModel = GiphyViewModel()
        sourceViewController?.show(viewController, sender: nil)
    }
    
    func didSelectEmbeddedViewController() {
        let viewController = GiphyMasterDetailViewController.instantiate(storyboardName: "Main")
        let coordinator = GiphyMasterDetailCoordinator(sourceViewController: viewController)
        viewController.viewModel = GiphyMasterDetailViewModel(coordinator: coordinator)
        sourceViewController?.show(viewController, sender: nil)
    }
}
