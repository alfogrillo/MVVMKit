/*
 SnapshotUpdate.swift
 
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

import UIKit

/**
 A container for a NSDiffableDataSourceSnapshot.
 This container describe if the diffing of a snapshot should be animated and provides a diffing completion.
 */
@available(iOS 13.0, *)
public struct SnapshotUpdate<SectionType: Hashable, ItemType: Hashable> {
    public let snapshot: NSDiffableDataSourceSnapshot<SectionType, ItemType>
    public let applyStrategy: ApplyStrategy
    public let completion: (() -> Void)?
    
    public init(
        snapshot: NSDiffableDataSourceSnapshot<SectionType, ItemType> = .init(),
        applyStrategy: ApplyStrategy = .diffing(animated: true),
        completion: (() -> Void)? = nil) {
        
        self.snapshot = snapshot
        self.applyStrategy = applyStrategy
        self.completion = completion
    }

    public enum ApplyStrategy {
        case diffing(animated: Bool)

        @available(iOS 15, *)
        case reloadData
    }
}

@available(iOS 13.0, *)
public extension NSDiffableDataSourceSnapshot {
    func adapted(applyStrategy: SnapshotUpdate<SectionIdentifierType, ItemIdentifierType>.ApplyStrategy = .diffing(animated: true),
                 completion: (() -> Void)? = nil) -> SnapshotUpdate<SectionIdentifierType, ItemIdentifierType> {
        .init(snapshot: self, applyStrategy: applyStrategy, completion: completion)
    }
}
