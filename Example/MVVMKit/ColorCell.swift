/*
 ColorCell.swift
 
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

struct ColorCellViewModel: ReusableViewViewModel {
    var identifier: String = ColorCell.identifier
    let title: String
    let color: UIColor
    let isEditable: Bool
}

protocol ColorCellDelegate: class {
    func didTapInvertButton(sender colorCell: ColorCell)
}

class ColorCell: UITableViewCell, CustomBinder, CustomDelegator {
    typealias ViewModelType = ColorCellViewModel
    typealias Delegate = ColorCellDelegate
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var colorView: CircularView!
    @IBOutlet private weak var editButton: UIButton!
    
    private var viewModel: ColorCellViewModel?
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        guard let viewModel = viewModel else { return }
        colorView.backgroundColor = viewModel.color
    }
    
    func bind(viewModel: ColorCellViewModel) {
        titleLabel.text = viewModel.title
        colorView.backgroundColor = viewModel.color
        editButton.isHidden = !viewModel.isEditable
        self.viewModel = viewModel
    }
    
    @IBAction func invertDidTap(_ sender: UIButton) {
        delegate?.didTapInvertButton(sender: self)
    }
}

class CircularView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width/2
    }
}
