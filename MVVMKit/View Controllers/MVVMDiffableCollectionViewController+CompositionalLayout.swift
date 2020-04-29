/*
MVVMDiffableCollectionViewController+CompositionalLayout.swift

Copyright (c) 2020 Alfonso Grillo

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

@available(iOS 13.0, *)
public extension MVVMDiffableCollectionViewController where ViewModelType.SectionType: SectionLayoutConvertible {
    /**
     When the `SectionType`s conform to `SectionLayoutConvertible` the class `MVVMDiffableCollectionViewController` provides this method, which
     fully configures the layout of the collection view with an instance of `UICollectionViewCompositionalLayout`.
     - Note: It is responsibility of the subclass of `MVVMDiffableCollectionViewController` to configure the layout when it is needed.
     */
    @discardableResult
    func updateLayout(with viewModel: ViewModelType, animated: Bool = true) -> UICollectionViewCompositionalLayout {
        let layout: UICollectionViewCompositionalLayout = .init { [weak self] (index, environment) -> NSCollectionLayoutSection? in
            self?.dataSource.snapshot().sectionIdentifiers[index].sectionLayout(with: environment)
        }
        collectionView.setCollectionViewLayout(layout, animated: animated)
        return layout
    }
}

#endif
