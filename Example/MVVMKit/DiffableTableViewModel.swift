/*
 DiffableTableViewModel.swift
 
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
import Combine

class DiffableTableViewModel: DiffableTableViewViewModel {
    typealias SectionType = Section
    
    let snapshotPublisher: PassthroughSubject<SnapshotAdapter, Never> = .init()
    private var searchText: String = ""
    private var model = (1...50).map {_ in String.random(length: 10) }
    
    func loadData() {
        updateSnapshot()
    }
    
    private func updateSnapshot() {
        var snapshot = Snapshot()
    
        let filteredModels = model
            .filter { searchText.isEmpty || $0.containsIgnoringCase(text: searchText) }
            .map { TextCellViewModel(text: $0).adapted(id: $0) }
        
        if !filteredModels.isEmpty {
            snapshot.appendSections([.main])
            snapshot.appendItems(filteredModels, toSection: .main)
        }
        
        snapshotPublisher.send(snapshot.adapted())
    }
    
    func searchTextDidChange(searchText: String) {
        self.searchText = searchText
        updateSnapshot()
    }
    
    func headerViewModel(for section: Section, at sectionIndex: Int) -> ReusableViewViewModel? {
        TableHeaderViewModel(text: "Header \(section)")
    }
    
    func footerViewModel(for section: Section, at sectionIndex: Int) -> ReusableViewViewModel? {
        TableHeaderViewModel(text: "Footer \(section)")
    }
    
    enum Section {
        case main
    }
}
