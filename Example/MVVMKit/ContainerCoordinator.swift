/*
 ContainerCoordinator.swift

 Copyright (c) 2021 Alfonso Grillo

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
import UIKit

protocol ContainerCoordinatorProtocol: EmbedderCoordinator where ViewController == ContainerViewController {
    typealias ContainerViewKind = ContainerViewController.ContainerViewKind
    
    func showTableViewController(in view: ContainerViewKind)
    func showCollectionViewController(in view: ContainerViewKind)
}

final class ContainerCoordinator: ContainerCoordinatorProtocol {
    let weakViewController: WeakReference<ContainerViewController>
    private var children: [ContainerViewKind: UIViewController] = .init()
    
    init(viewController: ContainerViewController) {
        weakViewController = .init(viewController)
    }
    
    func showTableViewController(in view: ContainerViewKind) {
        cleanup(in: view)
        let tableViewController = SearchTableViewController.instantiate(storyboardName: "Main")
        tableViewController.viewModel = SearchTableViewModel()
        embed(child: tableViewController, in: view)
    }
    
    func showCollectionViewController(in view: ContainerViewKind) {
        cleanup(in: view)
        let collectionViewController = SearchCollectionViewController.instantiate(storyboardName: "Main")
        collectionViewController.viewModel = SearchCollectionViewModel()
        embed(child: collectionViewController, in: view)
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

private extension ContainerCoordinator {
    func embedViewController(viewController: UIViewController, in view: UIView) {
        guard let parentViewController = self.viewController else { return }
        parentViewController.embed(child: viewController, in: view)
    }
}
