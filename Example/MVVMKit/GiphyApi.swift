/*
 GiphyApi.swift
 
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

enum GiphyApi {
    static let apiKey = "INSERT YOUR GIPHY API KEY HERE"
    case search(keyword: String)
}

extension GiphyApi {
    @discardableResult
    func request<D: Decodable>(completion: @escaping (Result<D, Error>) -> Void) -> URLSessionTask? {
        let url: URL = URL(string: "https://api.giphy.com/v1/gifs/search")!
        var urlParameters: [String: String] = ["api_key": GiphyApi.apiKey]
        switch self {
        case .search(let keyword):
            urlParameters["q"] = keyword
        }
        let task = URLSession.shared.dataTask(url: url, parameters: urlParameters, completion: completion)
        task?.resume()
        return task
    }
}
