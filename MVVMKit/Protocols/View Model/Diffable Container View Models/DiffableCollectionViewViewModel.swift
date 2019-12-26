/*
 DiffableCollectionViewViewModel.swift
 
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
 A protocol describing a view model publishing snapshots feeding a UICollectionViewDiffableDataSource
 */
@available(iOS 13.0, *)
public protocol DiffableCollectionViewViewModel: ReferenceViewModel {
    associatedtype SectionType: DiffableCollectionViewSection
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<SectionType, ReusableViewViewModelAdapter>
    typealias SnapshotAdapter = SnapshotUpdate<SectionType, ReusableViewViewModelAdapter>
    
    var snapshotPublisher: PassthroughSubject<SnapshotAdapter, Never> { get }
}

// MARK: - Section

/**
 A protocol describing a section suitable with a UICollectionViewDiffableDataSource
 */
@available(iOS 13.0, *)
public protocol DiffableCollectionViewSection: Hashable {
    associatedtype SupplementaryViewKind: RawRepresentable & Hashable = Never where SupplementaryViewKind.RawValue == String
    
    var supplementaryViewViewModels: [SupplementaryViewKind: ReusableViewViewModel] { get }
}

@available(iOS 13.0, *)
public extension DiffableCollectionViewSection where SupplementaryViewKind == Never {
    var supplementaryViewViewModels: [SupplementaryViewKind: ReusableViewViewModel] {
        [:]
    }
}

extension Never: RawRepresentable {
    public typealias RawValue = String
    public init?(rawValue: Self.RawValue) {
        nil
    }
    public var rawValue: String {
        String(describing: self)
    }
}

#endif
