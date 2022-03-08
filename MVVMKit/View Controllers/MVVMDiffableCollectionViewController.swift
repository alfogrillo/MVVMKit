/*
 MVVMDiffableCollectionViewController.swift
 
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

#if canImport(Combine)

import UIKit
import Combine

/**
 A convenience class for a view controller handling a UICollectionView.
 The class fully implements the data source of the UICollectionView using a UICollectionViewDiffableDataSource.
 */
@available(iOS 13.0, *)
open class MVVMDiffableCollectionViewController<ViewModelType: DiffableCollectionViewViewModel>: UIViewController, ViewModelOwner {
    public typealias ViewModelType = ViewModelType
    
    @IBOutlet public weak var collectionView: UICollectionView!
    public var viewModel: ViewModelType! {
        didSet { bindIfViewLoaded() }
    }
    public private(set) var dataSource: MVVMCollectionViewDiffableDataSource<ViewModelType.SectionType>!
    
    /// The type of the instanciated `MVVMCollectionViewDiffableDataSource`. A custom data source can be provided overriding this property.
    open class var dataSourceType: MVVMCollectionViewDiffableDataSource<ViewModelType.SectionType>.Type {
        MVVMCollectionViewDiffableDataSource<ViewModelType.SectionType>.self
    }
    
    private var dataSourceSubscription: AnyCancellable?
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        setupDataSource()
        bind()
    }
    
    open func bind(viewModel: ViewModelType) {
        dataSourceSubscription = viewModel.snapshot
            .receive(on: DispatchQueue.diffingQueue)
            .sink { [weak self] snapshotAdapter in
                self?.dataSource.apply(snapshotUpdate: snapshotAdapter)
            }
    }
    
    private func setupDataSource() {
        dataSource = Self.dataSourceType.init(collectionView: collectionView) { [weak self] (collectionView, indexPath, adapter) in
            guard let self = self else { return nil }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: adapter.reusableViewViewModel.identifier, for: indexPath)
            self.configureDelegate(of: cell)
            self.configure(view: cell, with: adapter.reusableViewViewModel)
            return cell
        }
        
        dataSource.supplementaryViewProvider = { [weak self] (collectionView, kind, indexPath) in
            guard let self = self else { return nil }
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            if let viewModel = self.viewModel?.supplementaryViewViewModel(for: section, forKind: kind, at: indexPath) {
                let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: viewModel.identifier, for: indexPath)
                self.configureDelegate(of: reusableView)
                self.configure(view: reusableView, with: viewModel)
                return reusableView
            } else {
                fatalError("No view model found for the supplementary view of kind \(kind)")
            }
        }
    }
}

#endif
