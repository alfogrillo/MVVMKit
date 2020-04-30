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
    let weakViewController: WeakReference<UIViewController>
    
    init(sourceViewController viewController: UIViewController) {
        weakViewController = .init(viewController)
    }
    
    func didSelectBasicViewController(model: BasicModel) {
        let viewController = BasicViewController.instantiate(storyboardName: "Main")
        viewController.viewModel = BasicViewModel(model: model)
        self.viewController?.show(viewController, sender: nil)
    }
    
    func didSelectTableViewController(model: ColorsModel) {
        let viewController = ColorsViewController.instantiate(storyboardName: "Main")
        viewController.viewModel = ColorsViewModel(model: model)
        self.viewController?.show(viewController, sender: nil)
    }
    
    func didSelectCollectionViewController() {
        let viewController = GiphyViewController.instantiate(storyboardName: "Main")
        viewController.viewModel = GiphyViewModel()
        self.viewController?.show(viewController, sender: nil)
    }
    
    func didSelectEmbeddedViewController() {
        let viewController = GiphyMasterDetailViewController.instantiate(storyboardName: "Main")
        let coordinator = GiphyMasterDetailCoordinator(sourceViewController: viewController)
        viewController.viewModel = GiphyMasterDetailViewModel(coordinator: coordinator)
        self.viewController?.show(viewController, sender: nil)
    }
    
    func didSelectDiffableCollectionViewController() {
        let viewController = SearchCollectionViewController.instantiate(storyboardName: "Main")
        viewController.viewModel = SearchCollectionViewModel()
        self.viewController?.show(viewController, sender: nil)
    }
    
    func didSelectDiffableTableViewController() {
        let viewController = SearchTableViewController.instantiate(storyboardName: "Main")
        viewController.viewModel = SearchTableViewModel()
        self.viewController?.show(viewController, sender: nil)
    }
}
