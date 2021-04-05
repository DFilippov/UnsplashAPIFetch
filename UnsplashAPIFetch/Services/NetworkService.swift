//
//  NetworkService.swift
//  UnsplashAPIFetch
//
//  Created by Ayu Filippova on 24/11/2019.
//  Copyright © 2019 Dmitry Filippov. All rights reserved.
//

import UIKit

class NetworkService: NSObject {
    
    // https://api.unsplash.com/search/photos/?query=boston&client_id=6d25fd738ba0a7648cf82d61e02c1df44cc3c233ecef7f9c019b9ca484ac8277
    
    var completionDownloadProgress: ((Float) -> ())?
    
    let accessKey = "6d25fd738ba0a7648cf82d61e02c1df44cc3c233ecef7f9c019b9ca484ac8277"
    let secretKey = "ea60e7e775fb259260d63056434e8e05c67a04ca30722ad34a7322003f7d0776"
    
    var queries = ["query": "", "client_id": ""]
    
    var urlComponents = URLComponents()
    
    deinit {
        print(#line, #function, "NetworkService  =====  DEINITIALIZED ")
    }
    
    func getURLComponents(searchText: String) {
        queries["query"] = searchText
        queries["client_id"] = accessKey
        queries["per_page"] = "200"         // TODO: DELETE
        
        urlComponents.scheme = "https"
        urlComponents.host = "api.unsplash.com"
        urlComponents.path = "/search/photos"
        urlComponents.setQueries(with: queries)
    }
    
    func fetch(completion: @escaping (UnsplashParseObject?) -> Void) {
        let url = urlComponents.url!
        
        let configuration = URLSessionConfiguration.default
        
        let urlCache = URLCache.shared
        let request = URLRequest(url: url)
        
        if let data = urlCache.cachedResponse(for: request)?.data {
            let object = self.decodeJSON(from: data)
            completion(object)
            print("=== RESPONSE from CACHE")
        } else {
            
            let session = URLSession(configuration: configuration)
            let dataTask = session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print(#line, #function, error)
                    completion(nil)
                }
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    print("Bad http response status code")
                    return }
                
                let object = self.decodeJSON(from: data!)
                completion(object)
                let cashedResponse = CachedURLResponse(response: httpResponse, data: data!)
                urlCache.storeCachedResponse(cashedResponse, for: request)
                
            }
            dataTask.resume()
            
        }
        
    }
    
    private func decodeJSON(from data: Data?) -> UnsplashParseObject? {
        guard let data = data else {
            print ("No data for decoding")
            return nil
        }
        let jsonDecoder = JSONDecoder()
        do {
            let object =  try jsonDecoder.decode(UnsplashParseObject.self, from: data)
            return object
        } catch {
            print("ERROR", error)
            return nil
        }
    }
}

//extension NetworkService: URLSessionDownloadDelegate {
//
//    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
//        print("FINISHED DOWNLOADING")
//    }
//    
//    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
//        
//        let downloadProgress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
//        
//        print(#line, #function, "==== downloadProgress", downloadProgress)
//        
//        if completionDownloadProgress != nil {
//            completionDownloadProgress?(downloadProgress)
//        }
//    }
//}
