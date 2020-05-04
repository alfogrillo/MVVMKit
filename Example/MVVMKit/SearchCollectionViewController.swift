/*
 SearchCollectionViewController.swift
 
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

class SearchCollectionViewController: MVVMDiffableCollectionViewController<SearchCollectionViewModel> {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        updateLayout()
    }
    
    private func setupCollectionView() {
        collectionView.register(SimpleCell.nib, forCellWithReuseIdentifier: SimpleCell.identifier)
        
        collectionView.register(
            HeaderFooterReusableView.nib,
            forSupplementaryViewOfKind: SupplementaryViewKind.header.rawValue,
            withReuseIdentifier: HeaderFooterReusableView.identifier)
        
        collectionView.register(
            HeaderFooterReusableView.nib,
            forSupplementaryViewOfKind: SupplementaryViewKind.footer.rawValue,
            withReuseIdentifier: HeaderFooterReusableView.identifier)
        
        collectionView.register(
            BadgeReusableView.nib,
            forSupplementaryViewOfKind: SupplementaryViewKind.badge.rawValue,
            withReuseIdentifier: BadgeReusableView.identifier)
    }
}

extension SearchCollectionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.searchTextDidChange(searchText: searchText)
    }
}

private extension NSCollectionLayoutSection {
    static func listSection(columns: Int = 1) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        
        // Item supplementary view
        let itemSupplementarySize = NSCollectionLayoutSize(widthDimension: .absolute(30), heightDimension: .absolute(30))
        let itemSupplementaryView = NSCollectionLayoutSupplementaryItem(
            layoutSize: itemSupplementarySize,
            elementKind: SupplementaryViewKind.badge.rawValue,
            containerAnchor: .init(edges: [.top, .trailing], absoluteOffset: .init(x: -4, y: 4)))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize, supplementaryItems: [itemSupplementaryView])
        
        let insetValue: CGFloat = 3
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(44))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns)
        group.interItemSpacing = .fixed(insetValue)
        group.contentInsets = .init(top: 0, leading: insetValue, bottom: 0, trailing: insetValue)
        
        let section = NSCollectionLayoutSection(group: group)
        
        // Supplementary views
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44)),
            elementKind: SupplementaryViewKind.header.rawValue,
            alignment: .top)
        
        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44)),
            elementKind: SupplementaryViewKind.footer.rawValue,
            alignment: .bottom)
        
        sectionHeader.pinToVisibleBounds = true
        sectionHeader.zIndex = 2
        section.boundarySupplementaryItems = [sectionHeader, sectionFooter]
        section.interGroupSpacing = insetValue
        section.contentInsets = .init(top: insetValue, leading: 0, bottom: insetValue, trailing: 0)
        return section
    }
}

// MARK: Layout

extension SearchCollectionViewModel.Section {
    func sectionLayout(with environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? {
        switch self {
        case .main:
            return .listSection(columns: 1)
        case .second:
            return .listSection(columns: 2)
        }
    }
}
