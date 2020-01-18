/*
 GiphyViewModel.swift
 
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

protocol GiphyViewModelDelegate: class {
    func giphyViewModel(_ giphyViewModel: GiphyViewModel, didSelectGif gif: GiphyResult)
}

class GiphyViewModel: CollectionViewViewModel {
    var binder: AnyCollectionViewBinder<GiphyViewModel>?
    weak var delegate: GiphyViewModelDelegate?
    var sections: [SectionViewModel] = []
    
    struct Model {
        var gifs: [GiphyResult]
        var isFetching: Bool = false
        
        init(gifs: [GiphyResult] = []) {
            self.gifs = gifs
        }
    }
    
    private var model: Model {
        didSet { updateSections() }
    }
    
    init(model: Model = Model()) {
        self.model = model
    }
    
    @discardableResult
    func fetchGiphyResults(keyword: String, completion: ((Result<Void, Error>) -> Void)? = nil) -> URLSessionTask? {
        startFetch()
        return GiphyApi.search(keyword: keyword).request { [weak self] (result: Result<GiphySearchResponse, Error>) in
            guard let `self` = self else { return }
            switch result {
            case .success(let response):
                self.model.gifs = response.data
                completion?(.success(()))
            case .failure(let error):
                completion?(.failure(error))
            }
            self.endFetch()
        }
    }
    
    func didSelectGif(at index: Int) {
        delegate?.giphyViewModel(self, didSelectGif: model.gifs[index])
    }
    
    var hasContent: Bool {
        return !model.gifs.isEmpty
    }
    
    var isFetching: Bool {
        return model.isFetching
    }
    
    private func startFetch() {
        model.isFetching = true
        model.gifs = []
        binder?.bind(viewModel: self, update: .reloadData)
    }
    
    private func endFetch() {
        model.isFetching = false
        self.binder?.bind(viewModel: self, update: .reloadData)
    }
    
    private func updateSections() {
        let section = SectionViewModel(cellViewModels: model.gifs.map { GiphyCellViewModel(url: $0.images.fixedWidth.url) })
        sections = [section]
    }
}
