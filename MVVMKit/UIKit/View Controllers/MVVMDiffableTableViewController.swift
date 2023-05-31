/*
 MVVMDiffableTableViewController.swift
 
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
 A convenience class for a view controller handling a UITableView.
 The class fully implements the data source of the UITableView using a UICollectionViewDiffableDataSource.
 */
@available(iOS 13.0, *)
open class MVVMDiffableTableViewController<ViewModelType: DiffableTableViewViewModel>: UIViewController, ViewModelOwner, UITableViewDelegate {
    public typealias ViewModelType = ViewModelType
    
    @IBOutlet public weak var tableView: UITableView! {
        didSet { tableView.delegate = self }
    }
    public var viewModel: ViewModelType! {
        didSet { bindIfViewLoaded() }
    }
    public private(set) var dataSource: MVVMTableViewDiffableDataSource<ViewModelType.SectionType>!
    
    /// The type of the instanciated `MVVMTableViewDiffableDataSource`. A custom data source can be provided overriding this property.
    open class var dataSourceType: MVVMTableViewDiffableDataSource<ViewModelType.SectionType>.Type {
        MVVMTableViewDiffableDataSource<ViewModelType.SectionType>.self
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
        dataSource = Self.dataSourceType.init(tableView: tableView) { [weak self] (collectionView, indexPath, adapter) -> UITableViewCell? in
            guard let self = self else { return nil }
            let cell = collectionView.dequeueReusableCell(withIdentifier: adapter.reusableViewViewModel.identifier, for: indexPath)
            self.configureDelegate(of: cell)
            self.configure(view: cell, with: adapter.reusableViewViewModel)
            return cell
        }
    }
    
    // MARK: - UITableViewDelegate
    
    // Display customization
    
    open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    open func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
    }
    
    open func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        
    }
    
    open func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    open func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        
    }
    
    open func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
        
    }
    
    // Variable height support
    
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
    
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.sectionHeaderHeight
    }
    
    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return tableView.sectionFooterHeight
    }
    
    open func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.estimatedRowHeight
    }
    
    open func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return tableView.estimatedSectionHeaderHeight
    }
    
    open func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return tableView.estimatedSectionFooterHeight
    }
    
    // Section header & footer information
    
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionInstance = self.dataSource.snapshot().sectionIdentifiers[section]
        guard
            let headerViewModel = viewModel?.headerViewModel(for: sectionInstance, at: section),
            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerViewModel.identifier)
            else { return nil }
        
        configureDelegate(of: view)
        configure(view: view, with: headerViewModel)
        return view
    }
    
    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let sectionInstance = self.dataSource.snapshot().sectionIdentifiers[section]
        guard
            let footerViewModel = viewModel?.footerViewModel(for: sectionInstance, at: section),
            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: footerViewModel.identifier)
            else { return nil }
        
        configureDelegate(of: view)
        configure(view: view, with: footerViewModel)
        return view
    }
    
    // Accessories
    
    open func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
    }
    
    // Selection
    
    open func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    open func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        
    }
    
    open func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        
    }
    
    open func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath
    }
    
    open func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath
    }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    open func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    
    // MARK: - Swipe Actions
    
    open func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return nil
    }
    
    open func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return nil
    }
    
    // MARK: - Editing
    
    open func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    open func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // MARK: - UIScrollViewDelegate
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    open func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
    }

    open func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {

    }
    
    open func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
    }
    
    open func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
    }
    
    open func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        
    }
    
    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
    
    open func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
    }
    
    open func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return nil
    }
    
    open func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        
    }
    
    open func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        
    }
    
    open func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return true
    }
    
    open func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        
    }
    
    open func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        
    }
}

#endif
