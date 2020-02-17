/*
 AnyTableViewBinder.swift
 
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

private class AnyTableViewBinderBase<V: TableViewViewModel>: TableViewBinder {
    func bind(viewModel: V) { }
    func bind(viewModel: V, update: TableViewUpdate) { }
}

private final class AnyTableViewBinderBox<B: TableViewBinder>: AnyTableViewBinderBase<B.CustomViewModel> {
    weak var base: B?
    
    init(_ base: B) {
        self.base = base
    }
    
    override func bind(viewModel: B.CustomViewModel) {
        base?.bind(viewModel: viewModel)
    }
    
    override func bind(viewModel: B.CustomViewModel, update: TableViewUpdate) {
        base?.bind(viewModel: viewModel, update: update)
    }
}

/**
The type erasure of `TableViewBinder`.
- Attention: To avoid memory leak `AnyTableViewBinder` has a weak reference to the embedded `TableViewBinder`
*/
public final class AnyTableViewBinder<V: TableViewViewModel>: TableViewBinder {
    private let box: AnyTableViewBinderBase<V>
    
    public init<B: TableViewBinder>(_ binder: B) where B.CustomViewModel == V {
        box = AnyTableViewBinderBox(binder)
    }
    
    public func bind(viewModel: V) {
        box.bind(viewModel: viewModel)
    }
    
    public func bind(viewModel: V, update: TableViewUpdate) {
        box.bind(viewModel: viewModel, update: update)
    }
}
