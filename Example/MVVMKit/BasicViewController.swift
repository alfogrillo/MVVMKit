/*
 BasicViewController.swift
 
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

final class BasicViewController: UIViewController, ViewModelOwner {
    typealias CustomViewModel = BasicViewModel

    @IBOutlet private weak var darkModelLabel: UILabel!
    @IBOutlet private weak var sliderLabel: UILabel!
    @IBOutlet private weak var slider: UISlider!
    @IBOutlet private weak var uiswitch: UISwitch!
    private var subscriptions: Set<AnyCancellable> = .init()
    var viewModel: BasicViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = String(describing: type(of: self))
        bind()
    }

    func bind(viewModel: BasicViewModel) {
        slider.maximumValue = Float(BasicViewModel.Constants.maximumValue)

        viewModel.backgroundColor
            .assignWeakly(to: \.backgroundColor, on: view)
            .store(in: &subscriptions)

        viewModel.textColor
            .assignWeakly(to: \.textColor, on: sliderLabel)
        .store(in: &subscriptions)

        viewModel.textColor
            .assignWeakly(to: \.textColor, on: darkModelLabel)
        .store(in: &subscriptions)

        viewModel.labelText
            .assignWeakly(to: \.text, on: sliderLabel)
            .store(in: &subscriptions)

        viewModel.isDarkModeOn
            .sink { [weak self] isOn in
                self?.uiswitch.setOn(isOn, animated: true)
            }
            .store(in: &subscriptions)

        viewModel.value
            .assignWeakly(to: \.value, on: slider)
            .store(in: &subscriptions)

        viewModel.sliderTintColor
            .assignWeakly(to: \.tintColor, on: slider)
            .store(in: &subscriptions)

        viewModel.isSliderEnabled
            .assignWeakly(to: \.isEnabled, on: slider)
            .store(in: &subscriptions)
    }

    // MARK: - Actions
    @IBAction func sliderValueDidChange(_ sender: UISlider) {
        viewModel.sliderValueDidChange(value: sender.value)
    }

    @IBAction func switchDidChange(_ sender: UISwitch) {
        viewModel.switchStateDidChange(isOn: sender.isOn)
    }
}
