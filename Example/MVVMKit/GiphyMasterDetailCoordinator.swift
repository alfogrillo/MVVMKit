/*
 GiphyMasterDetailCoordinator.swift
 
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

class GiphyMasterDetailCoordinator: EmbedderCoordinator {
    typealias ViewController = GiphyMasterDetailViewController
    typealias ContainerViewKind = ViewController.ViewKind
    
    private var children: [ContainerViewKind: UIViewController] = .init()
    
    let weakViewController: WeakReference<GiphyMasterDetailViewController>
    
    init(sourceViewController viewController: GiphyMasterDetailViewController) {
        weakViewController = .init(viewController)
    }
    
    func showMasterViewController(in view: ContainerViewKind) -> GiphyViewModel {
        cleanup(in: view)
        let viewController = GiphyViewController.instantiate(storyboardName: "Main")
        let viewModel = GiphyViewModel()
        viewController.viewModel = viewModel
        embed(child: viewController, in: view)
        return viewModel
    }
    
    func showDetailViewController(in view: ContainerViewKind, with result: GiphyResult) {
        cleanup(in: view)
        let viewController = GiphyDetailViewController.instantiate(storyboardName: "Main")
        let viewModel = GiphyDetailViewModel(model: result)
        viewController.viewModel = viewModel
        embed(child: viewController, in: view)
    }
    
    private func cleanup(in view: ContainerViewKind) {
        children.removeValue(forKey: view)?.removeEmbeddingFromParent()
    }
    
    private func embed(child: UIViewController, in view: ContainerViewKind) {
        guard let containerView = viewController?.view(for: view) else {
            return
        }
        viewController?.embed(child: child, in: containerView)
        children[view] = child
    }
}
