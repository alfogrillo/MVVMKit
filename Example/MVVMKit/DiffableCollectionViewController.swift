/*
 DiffableCollectionViewController.swift
 
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

class DiffableCollectionViewController: MVVMDiffableCollectionViewController<DiffableCollectionViewModel> {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        viewModel?.loadData()
    }
    
    func bind(viewModel: ViewModel) {
        super.bind(viewModel: viewModel)
        setupCollectionView()
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
        
        
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, _) -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case 0:
                return self.listSection(columns: 1)
            case 1:
                return self.listSection(columns: 2)
            default:
                return nil
            }
        }
        
        collectionView.setCollectionViewLayout(layout, animated: false)
    }
}

extension DiffableCollectionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.searchTextDidChange(searchText: searchText)
    }
}

private extension DiffableCollectionViewController {
    func listSection(columns: Int = 1) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(44))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns)
        
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
        return section
    }
}
