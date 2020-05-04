/*
 ColorsViewController.swift
 
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

class ColorsViewController: MVVMTableViewController<ColorsViewModel>, ColorCellDelegate {
    @IBOutlet private weak var selectColorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        navigationItem.setRightBarButton(editButtonItem, animated: false)
        editButtonItem.action = #selector(editDidTap(_:))
        editButtonItem.target = self
        bind()
    }
    
    override func bind(viewModel: ColorsViewModel) {
        UIView.animate(withDuration: 0.2) {
            self.selectColorLabel.layer.backgroundColor = self.viewModel?.headerBackgroundColor.cgColor
        }
        setEditing(viewModel.isEditingEnabled, animated: true)
        selectColorLabel.text = viewModel.headerTitleText
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.didSelectColor(at: indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return viewModel?.shouldSelectColor ?? true
    }
    
    @objc private func editDidTap(_ sender: UIBarButtonItem) {
        guard let viewModel = viewModel else { return }
        viewModel.setEditMode(enabled: !viewModel.isEditingEnabled)
    }
    
    func didTapInvertButton(sender colorCell: ColorCell) {
        guard let index = tableView.indexPath(for: colorCell)?.row else { return }
        viewModel?.invertColor(at: index)
    }
}
