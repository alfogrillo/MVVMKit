/*
 CollectionViewViewModel.swift
 
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

import Foundation
import UIKit

/**
 The view model for a UICollectionView
 */
public protocol CollectionViewViewModel: DelegatingViewModel {
    associatedtype BinderType: CollectionViewBinder = AnyCollectionViewBinder<Self>
    var sections: [SectionViewModel] { get }
}

/**
 A `CollectionViewBinder` is responsible to bind the view models of reusable view (cells, headers, footers).
 */
public protocol CollectionViewBinder: CustomBinder where CustomViewModel: CollectionViewViewModel {
    func bind(viewModel: CustomViewModel, update: CollectionViewUpdate)
}

/// An enum describing what should be updated inside a collection view
public enum CollectionViewUpdate {
    case reloadData
    case insertItems([IndexPath])
    case insertSections(IndexSet)
    case deleteItems([IndexPath])
    case deleteSections(IndexSet)
    case moveItem(at: IndexPath, to: IndexPath)
    case moveSection(at: Int, to: Int)
    case reloadItems([IndexPath])
    case reloadSections(IndexSet)
    case custom((UICollectionView?) -> Void)
}

public extension CollectionViewBinder where Self: CollectionViewViewModelOwner {
    func bind(viewModel: CustomViewModel, update: CollectionViewUpdate) {
        handle(update: update, with: collectionView)
        bind(viewModel: viewModel)
    }
}

private func handle(update: CollectionViewUpdate, with collectionView: UICollectionView?) {
    switch update {
    case .reloadData:
        collectionView?.reloadData()
    case .insertItems(let indicies):
        collectionView?.insertItems(at: indicies)
    case .insertSections(let sections):
        collectionView?.insertSections(sections)
    case .deleteItems(let indicies):
        collectionView?.deleteItems(at: indicies)
    case .deleteSections(let sections):
        collectionView?.deleteSections(sections)
    case .moveItem(let at, let to):
        collectionView?.moveItem(at: at, to: to)
    case .moveSection(let at, let to):
        collectionView?.moveSection(at, toSection: to)
    case .reloadItems(let indicies):
        collectionView?.reloadItems(at: indicies)
    case .reloadSections(let sections):
        collectionView?.reloadSections(sections)
    case .custom(let updateClosure):
        updateClosure(collectionView)
    }
}
