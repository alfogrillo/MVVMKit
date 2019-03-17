/*
 RootModel.swift
 
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

/// A stub for the application state
class RootModel {
    var basicModel = BasicViewModel.Model(value: 5, state: .on)
    var colorsModel = ColorsViewModel.Model(colors: Color.colors, selectedColor: nil)
}

private extension Color {
    static let colors: [Color] = [
        Color(name: "Red", values: (r: 1, g: 0, b: 0)),
        Color(name: "Green", values: (r: 0, g: 1, b: 0)),
        Color(name: "Blue", values: (r: 0, g: 0, b: 1)),
        Color(name: "Purple", values: (r: 1, g: 0, b: 1))
    ]
}

