/*
MVVMCollectionViewDiffableDataSource.swift

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

import UIKit

/**
 `MVVMDiffableCollectionViewController` subclasses can specify a custom subclass for the diffable data source.
 When you have to implement a custom `UICollectionViewDiffableDataSource` you should subclass this class and override the `dataSourceType` in `MVVMDiffableCollectionViewController`
 */
@available(iOS 13.0, *)
open class MVVMCollectionViewDiffableDataSource<SectionIdentifierType: Hashable>: UICollectionViewDiffableDataSource<SectionIdentifierType, ReusableViewViewModelAdapter> {
    public required override init(collectionView: UICollectionView,
                                  cellProvider: @escaping UICollectionViewDiffableDataSource<SectionIdentifierType, ReusableViewViewModelAdapter>.CellProvider) {
        super.init(collectionView: collectionView, cellProvider: cellProvider)
    }
}
