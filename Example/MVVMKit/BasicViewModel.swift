/*
 BasicViewModel.swift
 
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

import MVVMKit

struct BasicModel {
    var value: Float
    var state: State
    
    enum State {
        case on
        case off
    }
}

class BasicViewModel: BaseDelegatingViewModel {
    var binder: AnyBinder<BasicViewModel>?
    
    init(model: BasicModel) {
        self.model = model
    }
    
    // MARK: Model
    private var model: BasicModel {
        didSet { binder?.bind(viewModel: self) }
    }
    
    var isDarkModeOn: Bool {
        switch model.state {
        case .on:
            return true
        case .off:
            return false
        }
    }
    
    var backgroundColor: UIColor {
        switch model.state {
        case .on:
            let component: CGFloat = CGFloat(model.value) / CGFloat(maximumValue)
            return UIColor(red: component, green: component, blue: component, alpha: 1)
        case .off:
            return .white
        }
    }
    
    var textColor: UIColor {
        switch model.state {
        case .on:
            let component: CGFloat = 1 - CGFloat(model.value) / CGFloat(maximumValue)
            return UIColor(red: component, green: component, blue: component, alpha: 1)
        case .off:
            return .black
        }
    }
    
    var sliderTintColor: UIColor {
        switch model.state {
        case .on:
            return .orange
        case .off:
            return .cyan
        }
    }
    
    var maximumValue: Float {
        return 20
    }
    
    var value: Float {
        return model.value
    }
    
    func set(value: Float) {
        model.value = value
    }
    
    func set(state: BasicModel.State) {
        model.state = state
    }
    
    var labelText: String {
        return "Value \(Int(model.value))"
    }
}
