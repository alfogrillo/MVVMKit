//
//  SnapshotUpdate.swift
//  MVVMKit
//
//  Created by Alfonso Grillo on 15/12/2019.
//

import UIKit

/**
 A container for a NSDiffableDataSourceSnapshot.
 This container describe if the diffing of a snapshot should be animated and provides a diffing completion.
 */
@available(iOS 13.0, *)
public struct SnapshotUpdate<SectionType: Hashable, ItemType: Hashable> {
    public let snapshot: NSDiffableDataSourceSnapshot<SectionType, ItemType>
    public let animated: Bool
    public let completion: (() -> Void)?
    
    public init(
        snapshot: NSDiffableDataSourceSnapshot<SectionType, ItemType> = .init(),
        animated: Bool = true,
        completion: (() -> Void)? = nil) {
        
        self.snapshot = snapshot
        self.animated = animated
        self.completion = completion
    }
}

@available(iOS 13.0, *)
public extension NSDiffableDataSourceSnapshot {
    func adapted(animated: Bool = true, completion: (() -> Void)? = nil) -> SnapshotUpdate<SectionIdentifierType, ItemIdentifierType> {
        .init(snapshot: self, animated: animated, completion: completion)
    }
}
