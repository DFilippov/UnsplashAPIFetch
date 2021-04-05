//
//  CellImageView.swift
//  UnsplashAPIFetch
//
//  Created by Ayu Filippova on 20/01/2020.
//  Copyright © 2020 Dmitry Filippov. All rights reserved.
//

import UIKit

class CellImageView: UIImageView {
    
//    private var downloadProgress: Float = 0.0
    
    var imageLoader = ImageLoader()
    
    func setupView(url: URL) {
        self.image = UIImage(named: "defaultImage")
        DispatchQueue.main.async {
            self.layer.cornerRadius = 20
            self.layer.masksToBounds = true
//            self.contentMode = .scaleToFill
            self.contentMode = .scaleAspectFill
        }
        self.frame.size = CGSize(width: 10, height: 10)
        self.animateImage()
        
//        contentMode = .scaleAspectFill
//        layer.cornerRadius = 10
//        layer.masksToBounds = true
        imageLoader.loadImage(for: self, urlAtStart: url, urlBetterQuality: nil)
    }
    
    private func animateImage() {
        UIView.animate(
            withDuration: 0.5,
            delay: 0.05,
            usingSpringWithDamping: 0.55,
            initialSpringVelocity: 0.5,
            options: [.curveEaseOut],
            animations: {
                guard let superviewFrame = self.superview?.frame else {
                    print(#line, #function, "imageView's superview is nil")
                    return
                }
                self.frame = superviewFrame
                self.frame.size = CGSize(width: superviewFrame.width / 2 - 10, height: superviewFrame.height - 8)
                self.frame.origin = CGPoint(x: superviewFrame.origin.x + 8, y: superviewFrame.origin.y + 4)
        },
            completion: nil)
    }
}

//extension CellImageView: URLSessionDownloadDelegate {
//    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
//
//    }
//    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
//        downloadProgress = Float (totalBytesWritten / totalBytesExpectedToWrite)
//        print("Download progress for image", downloadProgress)
//
//    }
//
//
//}
