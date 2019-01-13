/*
 URLSession+.swift
 
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

enum Result<Payload> {
    case success(Payload)
    case failure(Error)
}

extension URLSession {
    @discardableResult
    func dataTask<D: Decodable>(url: URL, parameters: [String: String], completion: @escaping (Result<D>) -> Void) -> URLSessionTask? {
        let url = url.url(encodingParameters: parameters)!
        return dataTask(with: url, completionHandler: { (data, _, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                do {
                    let result = try JSONDecoder().decode(D.self, from: data!)
                    DispatchQueue.main.async {
                        completion(.success(result))
                    }
                    
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        })
    }
}

extension URL {
    func url(encodingParameters parameters: [String: String]) -> URL? {
        guard !parameters.isEmpty else { return self }
        var components = URLComponents(url: self, resolvingAgainstBaseURL: false)
        components?.queryItems = parameters.map { (key, value) in URLQueryItem(name: key, value: value) }
        return components?.url
    }
}
