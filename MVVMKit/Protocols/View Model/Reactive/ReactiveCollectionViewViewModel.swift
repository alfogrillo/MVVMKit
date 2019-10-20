/*
ReactiveCollectionViewViewModel.swift

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

import Combine
import UIKit

@available(iOS 13.0, *)
public protocol ReactiveCollectionViewViewModel: CollectionViewViewModel, ReactiveViewModel {
    var publisher: PassthroughSubject<CollectionViewUpdate, Never> { get }
}

// MARK: CollectionViewUpdateSubscriber

@available(iOS 13.0, *)
class CollectionViewUpdateSubscriber: Subscriber, Cancellable {
    typealias Input = CollectionViewUpdate
    typealias Failure = Never
    
    private var subscription: Subscription?
    private weak var collectionView: UICollectionView?
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
    }
    
    func receive(subscription: Subscription) {
        self.subscription = subscription
        self.subscription?.request(.unlimited)
    }
    
    func receive(_ input: CollectionViewUpdate) -> Subscribers.Demand {
        handle(update: input, with: collectionView)
        return .none
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        
    }
    
    func cancel() {
        subscription = nil
    }
}

@available(iOS 13.0, *)
public extension Publisher where Output == CollectionViewUpdate, Failure == Never {
    func subscribe(collectionView: UICollectionView) -> AnyCancellable {
        let subscriber = CollectionViewUpdateSubscriber(collectionView: collectionView)
        subscribe(subscriber)
        return AnyCancellable(subscriber)
    }
}

#endif
