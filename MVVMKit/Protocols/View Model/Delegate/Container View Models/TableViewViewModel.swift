/*
 TableViewViewModel.swift
 
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
 The view model for a UITableView
 */
public protocol TableViewViewModel: DelegatingViewModel {
    associatedtype BinderType: TableViewBinder = AnyTableViewBinder<Self>
    var sections: [SectionViewModel] { get }
}

/**
 A `TableViewBinder` is responsible to bind the view models of reusable view (cells, headers, footers).
 */
public protocol TableViewBinder: CustomBinder where CustomViewModel: TableViewViewModel {
    func bind(viewModel: CustomViewModel, update: TableViewUpdate)
}

/// An enum describing what should be updated inside a table view
public enum TableViewUpdate {
    case reloadData
    case insertRows([IndexPath], with: UITableView.RowAnimation)
    case insertSections(IndexSet, with: UITableView.RowAnimation)
    case deleteRows([IndexPath], with: UITableView.RowAnimation)
    case deleteSections(IndexSet, with: UITableView.RowAnimation)
    case moveRow(at: IndexPath, to: IndexPath)
    case moveSection(at: Int, to: Int)
    case reloadRows([IndexPath], with: UITableView.RowAnimation)
    case reloadSections(IndexSet, with: UITableView.RowAnimation)
    case custom((UITableView?) -> Void)
}

public extension TableViewBinder where Self: TableViewViewModelOwner {
    func bind(viewModel: CustomViewModel, update: TableViewUpdate) {
        handle(update: update, with: tableView)
        bind(viewModel: viewModel)
    }
}

private func handle(update: TableViewUpdate, with tableView: UITableView?) {
    switch update {
    case .reloadData:
        tableView?.reloadData()
    case .insertRows(let indicies, let animation):
        tableView?.insertRows(at: indicies, with: animation)
    case .insertSections(let sections, let animation):
        tableView?.insertSections(sections, with: animation)
    case .deleteRows(let indicies, let animation):
        tableView?.deleteRows(at: indicies, with: animation)
    case .deleteSections(let sections, let animation):
        tableView?.deleteSections(sections, with: animation)
    case .moveRow(let at, let to):
        tableView?.moveRow(at: at, to: to)
    case .moveSection(let at, let to):
        tableView?.moveSection(at, toSection: to)
    case .reloadRows(let indicies, let animation):
        tableView?.reloadRows(at: indicies, with: animation)
    case .reloadSections(let sections, let animation):
        tableView?.reloadSections(sections, with: animation)
    case .custom(let updateClosure):
        updateClosure(tableView)
    }
}
