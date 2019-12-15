/*
 UIImageView+.swift
 
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

import UIKit

extension UIImageView {
    @discardableResult
    func setGifImage(withUrl url: URL, completion: ((Result<Void, Error>) -> Void)? = nil) -> URLSessionTask? {
        image = nil
        task?.cancel()
        task = URLSession.imageSession.dataTask(with: URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)) { (data, _, error) in
            if let error = error {
                guard (error as NSError).code != NSURLErrorCancelled else { return }
                DispatchQueue.main.async {
                    completion?(.failure(error))
                }
            } else {
                let image = UIImage.gifImage(withData: data!)
                DispatchQueue.main.async {
                    self.image = image
                    completion?(.success(()))
                }
            }
        }
        task?.resume()
        return task
    }
    
    private var task: URLSessionTask? {
        get { return objc_getAssociatedObject(self, &Keys.task) as? URLSessionTask }
        set { objc_setAssociatedObject(self, &Keys.task, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    private struct Keys {
        static var task: String = "task"
    }
}

private extension URLSession {
    static let imageSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = URLCache(memoryCapacity: (1<<20) * 100, diskCapacity: (1<<20) * 200, diskPath: nil)
        return URLSession(configuration: configuration)
    }()
}
