/*
 BasicViewModel.swift
 
 Copyright (c) 2021 Alfonso Grillo
 
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

import MVVMKit
import UIKit
import Combine

struct BasicModel {
    var value: Float
    var state: State

    enum State {
        case on
        case off
    }
}

class BasicViewModel: ViewModel {
    private let updateSubject: PassthroughSubject<Void, Never> = .init()

    init(model: BasicModel) {
        self.model = .init(model)
    }

    // MARK: Model
    private let model: CurrentValueSubject<BasicModel, Never>

    var isDarkModeOn: AnyPublisher<Bool, Never> {
        model.map { model in
            switch model.state {
            case .on:
                return true
            case .off:
                return false
            }
        }.eraseToAnyPublisher()
    }

    var backgroundColor: AnyPublisher<UIColor, Never> {
        model.map { model in
            switch model.state {
            case .on:
                let component: CGFloat = CGFloat(model.value) / CGFloat(Constants.maximumValue)
                return UIColor(red: component, green: component, blue: component, alpha: 1)
            case .off:
                return .white
            }
        }.eraseToAnyPublisher()
    }

    var textColor: AnyPublisher<UIColor, Never> {
        model.map { model in
            switch model.state {
            case .on:
                let component: CGFloat = 1 - CGFloat(model.value) / CGFloat(Constants.maximumValue)
                return UIColor(red: component, green: component, blue: component, alpha: 1)
            case .off:
                return .black
            }
        }.eraseToAnyPublisher()
    }

    var sliderTintColor: AnyPublisher<UIColor, Never> {
        model.map { model in
            switch model.state {
            case .on:
                return .orange
            case .off:
                return .cyan
            }
        }.eraseToAnyPublisher()
    }

    var isSliderEnabled: AnyPublisher<Bool, Never> {
        model.map { $0.state == .on }.eraseToAnyPublisher()
    }

    var value: AnyPublisher<Float, Never> {
        model.map { $0.value }.eraseToAnyPublisher()
    }

    func sliderValueDidChange(value: Float) {
        model.value.value = value
    }

    func switchStateDidChange(isOn: Bool) {
        model.value.state = isOn ? .on : .off
    }

    var labelText: AnyPublisher<String, Never> {
        model.map { model in
            "Value \(Int(model.value))"
        }
        .eraseToAnyPublisher()
    }

    enum Constants {
        static let maximumValue: CGFloat = 20
    }
}

