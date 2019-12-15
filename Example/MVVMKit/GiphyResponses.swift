/*
 GiphyResponses.swift
 
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

struct GiphySearchResponse: Codable {
    let data: [GiphyResult]
    let pagination: Pagination
    let meta: Meta
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case pagination = "pagination"
        case meta = "meta"
    }
}

struct GiphyResult: Codable {
    let id: String
    let url: String
    let username: String
    let source: String
    let contentURL: String
    let images: Images
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case url = "url"
        case username = "username"
        case source = "source"
        case contentURL = "content_url"
        case images = "images"
        case title = "title"
    }
}

struct Images: Codable {
    let fixedWidth: FixedHeight
    let fixedHeightDownsampled: FixedHeight
    let fixedHeightSmall: FixedHeight
    let fixedWidthDownsampled: FixedHeight
    let original: FixedHeight
    let fixedHeight: FixedHeight
    
    enum CodingKeys: String, CodingKey {
        case fixedWidth = "fixed_width"
        case fixedHeightDownsampled = "fixed_height_downsampled"
        case fixedHeightSmall = "fixed_height_small"
        case fixedWidthDownsampled = "fixed_width_downsampled"
        case original = "original"
        case fixedHeight = "fixed_height"
    }
}

struct FixedHeight: Codable {
    let url: String
    let width: String
    let height: String
    let size: String
    let mp4: String?
    let mp4Size: String?
    let webp: String
    let webpSize: String
    let frames: String?
    let hash: String?
    
    enum CodingKeys: String, CodingKey {
        case url = "url"
        case width = "width"
        case height = "height"
        case size = "size"
        case mp4 = "mp4"
        case mp4Size = "mp4_size"
        case webp = "webp"
        case webpSize = "webp_size"
        case frames = "frames"
        case hash = "hash"
    }
}

struct Meta: Codable {
    let status: Int
    let msg: String
    let responseID: String
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case msg = "msg"
        case responseID = "response_id"
    }
}

struct Pagination: Codable {
    let totalCount: Int
    let count: Int
    let offset: Int
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case count = "count"
        case offset = "offset"
    }
}
