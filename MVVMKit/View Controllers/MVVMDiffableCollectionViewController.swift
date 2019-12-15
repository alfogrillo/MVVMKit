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

import UIKit
import Combine

/**
 A convenience class for a view controller handling a UICollectionView.
 The class fully implements the data source of the UICollectionView using a UICollectionViewDiffableDataSource.
 */
@available(iOS 13.0, *)
open class MVVMDiffableCollectionViewController<Model: DiffableCollectionViewViewModel>: UIViewController, ViewModelOwner {
    public typealias CustomViewModel = Model
    
    @IBOutlet public weak var collectionView: UICollectionView!
    public var viewModel: Model?
    public private(set) var dataSource: UICollectionViewDiffableDataSource<Model.SectionType, ReusableViewViewModelAdapter>!
    
    private var dataSourceSubscription: AnyCancellable?
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        setupDataSource()
    }
    
    open func bind(viewModel: Model) {
        dataSourceSubscription = viewModel.snapshotPublisher.sink { [weak self] snapshotAdapter in
            guard let self = self else { return }
            self.dataSource.apply(snapshotAdapter.snapshot, animatingDifferences: snapshotAdapter.animated, completion: snapshotAdapter.completion)
        }
    }
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { [weak self] (collectionView, indexPath, adapter) -> UICollectionViewCell? in
            guard let self = self else { return nil }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: adapter.reusableViewViewModel.identifier, for: indexPath)
            self.configureDelegate(of: cell)
            self.configure(view: cell, with: adapter.reusableViewViewModel)
            return cell
        }
        
        dataSource.supplementaryViewProvider = { [weak self] (collectionView, kind, indexPath) -> UICollectionReusableView? in
            guard let self = self else { return nil }
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            if let viewModel = section.supplementaryViewViewModels[kind] {
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