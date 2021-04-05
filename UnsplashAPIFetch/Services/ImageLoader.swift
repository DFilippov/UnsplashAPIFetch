//
//  ImageLoader.swift
//  UnsplashAPIFetch
//
//  Created by Ayu Filippova on 23/01/2020.
//  Copyright © 2020 Dmitry Filippov. All rights reserved.
//

import UIKit

class ImageLoader: NSObject {
    
    var imageURL: URL?
    
//    var completionDownloadProgress: ((Float) -> ())?
    
    deinit {
        print(#line, #function, "===== DEINITIALIZED = ", self)
    }
    
    func loadImage(for imageView: UIImageView, urlAtStart: URL, urlBetterQuality: URL? = nil) {
        imageURL = urlAtStart
        
//        DispatchQueue.main.async {
//            imageView.image = UIImage(named: "defaultImage")
//            imageView.layer.cornerRadius = 20
//            imageView.layer.masksToBounds = true
//        }
        
        switch urlBetterQuality == nil {
        case true:
            loadSmallImage(for: imageView, url: urlAtStart)
        case false:
            loadBigImage(for: imageView, urlAtStart: urlAtStart, urlBetterQuality: urlBetterQuality!)
        }
    }
    
    private func loadSmallImage(for imageView: UIImageView, url: URL) {
        let urlCache = URLCache.shared
        let request = URLRequest(url: url)
        
        if let data = urlCache.cachedResponse(for: request)?.data {
            DispatchQueue.main.async {
                imageView.image = UIImage(data: data)
//                print("IMAGE FROM CACHE 👍 - thumb quality")
            }
        } else {
            fetchImageData(urlCache: urlCache, url: url) { data in
                DispatchQueue.main.async {
                    if self.imageURL == url {
                        imageView.image = UIImage(data: data)
                    }
//                    print("thumb IMAGE FROM NET 🤠")
                }
            }
        }
    }
      
    private func loadBigImage(for imageView: UIImageView, urlAtStart: URL, urlBetterQuality: URL) {
        
        let urlCache = URLCache.shared
        let requestAtStart = URLRequest(url: urlAtStart)
        let requestBetterQuality = URLRequest(url: urlBetterQuality)
        
        if let betterQualityData = urlCache.cachedResponse(for: requestBetterQuality)?.data {
            DispatchQueue.main.async {
                imageView.image = UIImage(data: betterQualityData)
//                print("IMAGE FROM CACHE 👍 - BETTER QUALITY")
            }
            
        } else if let atStartData = urlCache.cachedResponse(for: requestAtStart)?.data {
            DispatchQueue.main.async {
                imageView.image = UIImage(data: atStartData)
//                print("IMAGE FROM CACHE 👍 - thumb quality")
            }

            fetchImageData(urlCache: urlCache, url: urlBetterQuality) { data in
                DispatchQueue.main.async {
                    imageView.image = UIImage(data: data)
//                    print("BIG! IMAGE FROM NET 🤠")
                }
            }
        }
    }
    
    func fetchImageData(urlCache: URLCache, url: URL, completion: @escaping (Data) -> ()) {
        print(#line, #function, "FETCHING IMAGE")
        let request = URLRequest(url: url)
        
//        let session = URLSession(configuration: .default)
//        let queue = OperationQueue.current
        let session = URLSession(configuration: .default)
        
        let task = session.downloadTask(with: request) { location, response, error in
            if let error = error {
                print("ERROR", error)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Bad httpResponse status code")
                return
            }
            
            guard let location = location else {
                print("Could not get url location of data ")
                return
            }

            do {
                let data = try Data(contentsOf: location)
                let cachedResponse = CachedURLResponse(response: httpResponse, data: data)
                urlCache.storeCachedResponse(cachedResponse, for: request)
                completion(data)
                
//                session.invalidateAndCancel()
            } catch {
                print("ERROR while getting data from downloadTask's url", error)
            }
        }
        task.resume()
    }
}


//extension ImageLoader: URLSessionDownloadDelegate {
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
////        if completionDownloadProgress != nil {
////            completionDownloadProgress?(downloadProgress)
////        }
//    }
//}
