/*
Publisher+.swift

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

import Foundation
import Combine

extension Publisher where Failure == Never {
    func assignWeakly<T: AnyObject>(to keyPath: ReferenceWritableKeyPath<T, Output?>, on object: T) -> AnyCancellable {
        sink { [weak object] in
            object?[keyPath: keyPath] = $0
        }
    }

    func assignWeakly<T: AnyObject>(to keyPath: ReferenceWritableKeyPath<T, Output>, on object: T) -> AnyCancellable {
        sink { [weak object] in
            object?[keyPath: keyPath] = $0
        }
    }

    func enumerated() -> AnyPublisher<(Int, Output), Failure> {
        scan(nil) { (tuple, output) -> (Int, Output)? in
            let nextIndex = tuple.map { $0.0 + 1 } ?? 0
            return (nextIndex, output)
        }
        .compactMap { $0 }
        .eraseToAnyPublisher()
    }
}