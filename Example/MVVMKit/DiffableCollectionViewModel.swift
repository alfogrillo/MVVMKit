/*
 DiffableCollectionViewModel.swift
 
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

class DiffableCollectionViewModel: DiffableCollectionViewViewModel {
    typealias SectionType = Section
    
    let snapshotPublisher: PassthroughSubject<SnapshotAdapter, Never> = .init()
    
    struct ModelEntry {
        let id: UUID = .init()
        let text: String
    }
    
    private let model = [
        (1...20).map { _ in ModelEntry(text: .random(length: 10)) },
        (1...20).map { _ in ModelEntry(text: .random(length: 10)) }
    ]
    private var searchText: String = ""
    
    func loadData() {
        updateSnapshot()
    }
    
    func searchTextDidChange(searchText: String) {
        self.searchText = searchText
        updateSnapshot()
    }
    
    private func updateSnapshot() {
        var snapshot = Snapshot()
        
        let items1 = model[0].filter(searchKey: searchText).map { SimpleCellViewModel(text: $0.text).adapted(id: $0.id) }
        if !items1.isEmpty {
            snapshot.appendSections([.main])
            snapshot.appendItems(items1, toSection: .main)
        }
        
        let items2 = model[1].filter(searchKey: searchText).map { SimpleCellViewModel(text: $0.text).adapted(id: $0.id) }
        if !items2.isEmpty {
            snapshot.appendSections([.second])
            snapshot.appendItems(items2, toSection: .second)
        }
        
        snapshotPublisher.send(snapshot.adapted())
    }
    
    enum Section: DiffableCollectionViewSection {
        case main
        case second
        
        var supplementaryViewViewModels: [SupplementaryViewKind: ReusableViewViewModel] {
            switch self {
            case .main:
                return [
                    .header: HeaderFooterReusableViewViewModel(text: "Main Header"),
                    .footer: HeaderFooterReusableViewViewModel(text: "Main Footer")
                ]
            case .second:
                return [
                    .header: HeaderFooterReusableViewViewModel(text: "Second Header"),
                    .footer: HeaderFooterReusableViewViewModel(text: "Second Footer")
                ]
            }
        }
    }
}

enum SupplementaryViewKind: String {
    case header
    case footer
}

private extension Array where Element == DiffableCollectionViewModel.ModelEntry {
    func filter(searchKey: String) -> [DiffableCollectionViewModel.ModelEntry] {
        guard !searchKey.isEmpty else { return self }
        return filter { $0.text.containsIgnoringCase(text: searchKey) }
    }
}
