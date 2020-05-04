/*
 Binder.swift
 
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
 A `Binder` is responsible to bind a view model on a view.
 */
public protocol Binder: class {
    func bind(viewModel: ViewModel)
}

/**
 A `CustomBinder` is responsible to bind a specific view model type on a view.
 */
public protocol CustomBinder: Binder {
    associatedtype ViewModelType: ViewModel
    func bind(viewModel: ViewModelType)
}

public extension CustomBinder {
    /**
     Default implementation of `Binder` protocol
     */
    func bind(viewModel: ViewModel) {
        precondition(viewModel is ViewModelType)
        bind(viewModel: viewModel as! ViewModelType)
    }
}
