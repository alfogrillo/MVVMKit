/*
 ColorsViewModel.swift
 
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

struct ColorsModel {
    var colors: [Color]
    var selectedColor: Color?
}

struct Color {
    let name: String
    let values: (r: CGFloat, g: CGFloat, b: CGFloat)
}

class ColorsViewModel: TableViewViewModel {
    var binder: AnyTableViewBinder<ColorsViewModel>?
    
    var sections: [SectionViewModel] = []
    private var state: State = .normal
    
    private var model: ColorsModel {
        didSet { updateSections() }
    }
    
    init(model: ColorsModel) {
        sections = []
        self.model = model
        updateSections()
    }
    
    private func updateSections() {
        let cellViewModels = model.colors.map {
            return ColorCellViewModel(title: $0.name, color: $0.asUIColor, isEditable: state == .edit)
        }
        sections = [SectionViewModel(cellViewModels: cellViewModels)]
    }
    
    func didSelectColor(at index: Int) {
        model.selectedColor = model.colors[index]
        binder?.bind(viewModel: self)
    }
    
    func invertColor(at index: Int) {
        model.colors[index] = model.colors[index].inverted
        binder?.bind(viewModel: self, update: .reloadRows([IndexPath(row: index, section: 0)], with: .automatic))
    }
    
    func setEditMode(enabled: Bool) {
        state = enabled ? .edit : .normal
        model.selectedColor = nil
        updateSections()
        binder?.bind(viewModel: self, update: .reloadData)
    }
    
    // MARK - Read only prorperties
    
    var isEditingEnabled: Bool {
        return state == .edit
    }
    
    var shouldSelectColor: Bool {
        return state == .normal
    }
    
    var headerBackgroundColor: UIColor {
        return model.selectedColor?.asUIColor ?? .white
    }
    
    var styleRightBarButtonItem: UIBarButtonItem.SystemItem {
        return state == .edit ? .edit : .done
    }
    
    var headerTitleText: String {
        return model.selectedColor == nil ? "Select a color!" : "You selected \(model.selectedColor!.name)"
    }
    
    enum State {
        case normal
        case edit
    }
}

private extension Color {
    var asUIColor: UIColor {
        let (r, g, b) = values
        return UIColor(red: r, green: g, blue: b, alpha: 1)
    }
    
    var inverted: Color {
        let (r, g, b) = values
        return Color(name: name, values: (r: abs(1 - r), g: abs(1 - g), b: abs(1 - b)))
    }
}
