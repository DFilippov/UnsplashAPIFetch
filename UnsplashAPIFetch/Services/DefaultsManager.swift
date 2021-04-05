//
//  DefaultsManager.swift
//  UnsplashAPIFetch
//
//  Created by Ayu Filippova on 18/03/2020.
//  Copyright © 2020 Dmitry Filippov. All rights reserved.
//

import Foundation

//enum ImageQualityKey: String {
//    case raw
//    case full
//    case regular
//    case small
//    case thumb
//}

class DefaultsManager {
    static let galleryThumbImageURLs = "galleryThumbImageURLs"
    static let galleryBigImageURLs = "galleryBigImageURLs"
    
    private var imageURLs = [URL]()
    
    let userDefaults = UserDefaults(suiteName: DefaultsManager.galleryThumbImageURLs)
    
    func saveWholeGalleryURLs(urls: [URL]) {
        imageURLs = urls
        if let data = archiveData(object: imageURLs) as NSData? {
            userDefaults?.set(data, forKey: DefaultsManager.galleryThumbImageURLs)
        }
    }
    
    func saveImageURL(url: URL) {
        if let urls = getImageURLs() {
            imageURLs = urls
            imageURLs.append(url)
            
            if let data = archiveData(object: imageURLs) as NSData? {
                userDefaults?.set(data, forKey: DefaultsManager.galleryThumbImageURLs)
            }
            
        } else {
            imageURLs.append(url)
            
            if let data = archiveData(object: imageURLs) as NSData? {
                userDefaults?.set(data, forKey: DefaultsManager.galleryThumbImageURLs)
            }
        }
//        print(#line, "DEFAULTS MANAGER SAVED URLs", imageURLs.count)
    }
    
    func getImageURLs() -> [URL]? {
        guard let data = userDefaults?.object(forKey: DefaultsManager.galleryThumbImageURLs) as? Data else { // Data /  NSData
            print(#line, "No data for key \(DefaultsManager.galleryThumbImageURLs)")
            return nil
        }
        let urls = unarchiveData(data: data)
//        print(#line, "DEFAULTS MANAGER GOT URLs", urls?.count)
        return urls
    }
    
    private func archiveData(object: Any) -> Data? {
        guard let data = try? NSKeyedArchiver.archivedData(withRootObject: object, requiringSecureCoding: false) else {
            print(#line, "Could not archive Data")
            return nil
        }
        
        // TODO: DELETE print
//        print(#line, "ARCHIVED")
        
        return data
    }
    
    private func unarchiveData(data: Data) -> [URL]? {
        do {
            let urls = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [URL]
            
            // TODO: DELETE print
//            print(#line, "UNARCHIVED")
            
            return urls
        } catch {
            print(#line, "Could not unarchive Data to [URL]")

            return nil
        }
    }
}
