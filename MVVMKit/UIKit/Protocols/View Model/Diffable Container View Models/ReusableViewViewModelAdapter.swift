/*
ReusableViewViewModelAdapter.swift

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

/**
 The `ReusableViewViewModelAdapter` is intended to be used as `ItemIdentifierType` of diffable data sources.
 In this way we can deal with heterogeneous collection of `ReusableViewViewModel` in our data sources.
 The `hashable` instance of the adapter should be part of your model (your source of truth) and is used by the diffable data sources to compute the diffing.
 */
@available(iOS 13.0, *)
public struct ReusableViewViewModelAdapter: Hashable {
    private let hashable: AnyHashable
    public let reusableViewViewModel: ReusableViewViewModel

    public init<H: Hashable>(hashable: H, reusableViewViewModel: ReusableViewViewModel) {
        self.hashable = AnyHashable(hashable)
        self.reusableViewViewModel = reusableViewViewModel
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.hashable == rhs.hashable
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(hashable)
    }
}

@available(iOS 13.0, *)
public extension ReusableViewViewModel {
    func adapted<H: Hashable>(hashable: H) -> ReusableViewViewModelAdapter {
        .init(hashable: hashable, reusableViewViewModel: self)
    }
}

@available(iOS 13.0, *)
public extension ReusableViewViewModel where Self: Hashable {
    func adapted() -> ReusableViewViewModelAdapter {
        .init(hashable: self, reusableViewViewModel: self)
    }
}
