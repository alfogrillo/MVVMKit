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
import UIKit
import Combine

struct ColorsModel {
    var colors: [Color]
    var selectedColor: Color?
    var state: State
    
    enum State {
        case normal
        case edit
        
        mutating func toogle() {
            self = self == .normal ? .edit : .normal
        }
    }
}

struct Color {
    let name: String
    let values: (r: CGFloat, g: CGFloat, b: CGFloat)
}

class ColorsViewModel: DiffableTableViewViewModel {
    typealias SectionType = Section
    
    var snapshot: AnyPublisher<SnapshotAdapter, Never> {
        $model.map(snapshot(with:)).eraseToAnyPublisher()
    }
    
    @Published private var model: ColorsModel
    
    init(model: ColorsModel) {
        self.model = model
    }
    
    private func snapshot(with model: ColorsModel) -> SnapshotAdapter {
        var snapshot: NSDiffableDataSourceSnapshot<Section, ReusableViewViewModelAdapter> = .init()
        snapshot.appendSections([.main])
        let items = model.colors.map { vm -> ReusableViewViewModelAdapter in
            let viewModel = ColorCellViewModel(title: vm.name, color: vm.asUIColor, isEditable: model.state == .edit)
            return viewModel.adapted()
        }
        snapshot.appendItems(items, toSection: .main)
        return SnapshotAdapter(snapshot: snapshot, applyStrategy: .diffing(animated: true), completion: nil)
    }
    
    func didSelectColor(at index: Int) {
        model.selectedColor = model.colors[index]
    }
    
    func invertColor(at index: Int) {
        model.colors[index] = model.colors[index].inverted
    }
    
    func toggleEditMode() {
        model.state.toogle()
        model.selectedColor = nil
    }
    
    // MARK - Read only prorperties
    
    var isEditingEnabled: AnyPublisher<Bool, Never> {
        $model.map { $0.state == .edit }.eraseToAnyPublisher()
    }
    
    var headerBackgroundColor: AnyPublisher<Color?, Never> {
        $model.map { $0.selectedColor }.eraseToAnyPublisher()
    }
    
    var shouldSelectColor: Bool {
        model.state == .normal
    }
    
    var styleRightBarButtonItem: UIBarButtonItem.SystemItem {
        model.state == .edit ? .edit : .done
    }
    
    var headerTitleText: AnyPublisher<String, Never> {
        $model.map {
            $0.selectedColor == nil ? "Select a color!" : "You selected \($0.selectedColor!.name)"
        }
        .eraseToAnyPublisher()
    }
    
    enum Section {
        case main
    }
}

extension Color {
    var inverted: Color {
        let (r, g, b) = values
        return Color(name: name, values: (r: abs(1 - r), g: abs(1 - g), b: abs(1 - b)))
    }
    
    var asUIColor: UIColor {
        let (r, g, b) = values
        return UIColor(red: r, green: g, blue: b, alpha: 1)
    }
}
