/*
 ViewModel+UIView.swift
 
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
 The view model for a section of a UITableView or UICollectionView
 */
public struct SectionViewModel: ViewModel, ExpressibleByArrayLiteral {
    public var cellViewModels: [ReusableViewViewModel]
    public var headerViewModel: ReusableViewViewModel?
    public var footerViewModel: ReusableViewViewModel?
    
    public init(
        cellViewModels: [ReusableViewViewModel],
        headerViewModel: ReusableViewViewModel? = nil,
        footerViewModel: ReusableViewViewModel? = nil
    ) {
        self.cellViewModels = cellViewModels
        self.headerViewModel = headerViewModel
        self.footerViewModel = footerViewModel
    }
    
    // ExpressibleByArrayLiteral conformance
    public typealias ArrayLiteralElement = ReusableViewViewModel
    
    public init(arrayLiteral elements: ReusableViewViewModel...) {
        self.init(cellViewModels: elements)
    }
}

public extension SectionViewModel {
    var count: Int {
        return cellViewModels.count
    }
    
    subscript (_ index: Int) -> ReusableViewViewModel {
        get { return cellViewModels[index] }
        set { cellViewModels[index] = newValue }
    }
}

/**
 The view model for a UITableView or UICollectionView
 */
public protocol TableViewViewModel: RootViewModel where BinderType == TableViewBinder {
    var sections: [SectionViewModel] { get set }
}

public extension TableViewViewModel {
    subscript(cellViewModelAt indexPath: IndexPath) -> ReusableViewViewModel {
        return sections[indexPath.section][indexPath.row]
    }
    
    subscript(headerViewModelAt index: Int) -> ReusableViewViewModel? {
        return sections[index].headerViewModel
    }
    
    subscript(footerViewModelAt index: Int) -> ReusableViewViewModel? {
        return sections[index].footerViewModel
    }
}

/// An enum describing what should be updated inside a table view or a collection view
public enum ViewChange {
    case all
    case insertItems([IndexPath])
    case insertSections(IndexSet)
    case deleteItems([IndexPath])
    case moveItem(at: IndexPath, to: IndexPath)
    case moveSection(at: Int, to: Int)
    case reloadItems([IndexPath])
    case reloadSections(IndexSet)
}

public extension TableViewBinder where Self: TableViewViewModelOwner {
    func viewModel(_ viewModel: ViewModel, didChange viewChange: ViewChange?) {
        defer { bind(viewModel: viewModel) }
        
        guard let change = viewChange else {
            return
        }
        
        switch change {
        case .all:
            tableView?.reloadData()
        case .insertItems(let indicies):
            tableView?.insertRows(at: indicies, with: .automatic)
        case .insertSections(let sections):
            tableView?.insertSections(sections, with: .automatic)
        case .deleteItems(let indicies):
            tableView?.deleteRows(at: indicies, with: .automatic)
        case .moveItem(let at, let to):
            tableView?.moveRow(at: at, to: to)
        case .moveSection(let at, let to):
            tableView?.moveSection(at, toSection: to)
        case .reloadItems(let indicies):
            tableView?.reloadRows(at: indicies, with: .automatic)
        case .reloadSections(let sections):
            tableView?.reloadSections(sections, with: .automatic)
        }
    }
}

public typealias CollectionViewViewModel = TableViewViewModel

public extension CollectionViewBinder where Self: CollectionViewViewModelOwner {
    func viewModel(_ viewModel: ViewModel, didChange viewChange: ViewChange?) {
        defer { bind(viewModel: viewModel) }
        
        guard let change = viewChange else {
            return
        }
        
        switch change {
        case .all:
            collectionView?.reloadData()
        case .insertItems(let indicies):
            collectionView.insertItems(at: indicies)
        case .insertSections(let sections):
            collectionView.insertSections(sections)
        case .deleteItems(let indicies):
            collectionView.deleteItems(at: indicies)
        case .moveItem(let at, let to):
            collectionView.moveItem(at: at, to: to)
        case .moveSection(let at, let to):
            collectionView.moveSection(at, toSection: to)
        case .reloadItems(let indicies):
            collectionView.reloadItems(at: indicies)
        case .reloadSections(let sections):
            collectionView.reloadSections(sections)
        }
    }
}
