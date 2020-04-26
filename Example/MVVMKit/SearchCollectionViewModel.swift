/*
 SearchCollectionViewModel.swift
 
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

class SearchCollectionViewModel: DiffableCollectionViewViewModel {
    typealias SectionType = Section
    
    var snapshot: AnyPublisher<SnapshotAdapter, Never> {
        searchText.map(snapshot(searchText:)).eraseToAnyPublisher()
    }
    
    private let snapshotSubject: PassthroughSubject<SnapshotAdapter, Never> = .init()
    
    struct ModelEntry: Hashable {
        let id: UUID = .init()
        let text: String
    }
    
    private struct ModelEntryAdapter: Hashable {
        let entry: ModelEntry
        let searchText: String
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(entry)
        }
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.entry == rhs.entry && lhs.searchText  == rhs.searchText
        }
    }
    
    private let model = [
        (1...20).map { _ in ModelEntry(text: .random(length: 12)) },
        (1...20).map { _ in ModelEntry(text: .random(length: 12)) }
    ]
    
    private var filteredModel: [[ModelEntry]] {
        model.map { $0.filter(searchKey: searchText.value) }
    }
    
    private let searchText: CurrentValueSubject<String, Never> = .init("")
    
    func searchTextDidChange(searchText: String) {
        self.searchText.value = searchText
    }
    
    private func snapshot(searchText: String) -> SnapshotAdapter {
        var snapshot = Snapshot()
        let filteredModel = self.filteredModel
        
        for section in Section.allCases {
            let items = filteredModel[section.rawValue].map {
                SimpleCellViewModel(text: $0.text)
                    .adapted(hashable: ModelEntryAdapter(entry: $0, searchText: searchText) )
            }
            snapshot.appendSections([section])
            snapshot.appendItems(items, toSection: section)
        }
        
        return snapshot.adapted()
    }
    
    func supplementaryViewViewModel(for section: Section, forKind kind: String, at indexPath: IndexPath) -> ReusableViewViewModel? {
        let headerText = "Header \(section)"
        let footerText = "Footer \(section)"
        let modelItem = filteredModel[safe: indexPath.section]?[safe: indexPath.row]
        let badgeCount = modelItem?.text.numberOfOccurences(of: searchText.value) ?? 0

        switch kind {
        case SupplementaryViewKind.header.rawValue:
            return HeaderFooterReusableViewViewModel(text: headerText)
        case SupplementaryViewKind.footer.rawValue:
            return HeaderFooterReusableViewViewModel(text: footerText)
        case SupplementaryViewKind.badge.rawValue:
            return BadgeReusableViewViewModel(isVisible: badgeCount > 0, text: "\(badgeCount)")
        default:
            return nil
        }
    }
    
    enum Section: Int, CaseIterable, SectionLayoutConvertible {
        case main = 0
        case second = 1
    }
}

enum SupplementaryViewKind: String {
    case header
    case footer
    case badge
}

private extension Array where Element == SearchCollectionViewModel.ModelEntry {
    func filter(searchKey: String) -> [SearchCollectionViewModel.ModelEntry] {
        guard !searchKey.isEmpty else { return self }
        return filter { $0.text.containsIgnoringCase(text: searchKey) }
    }
}

private extension String {
    func numberOfOccurences(of string: String) -> Int {
        lowercased().components(separatedBy: string.lowercased()).count - 1
    }
}
