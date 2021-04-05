//
//  ItemCell.swift
//  UnsplashAPIFetch
//
//  Created by Ayu Filippova on 02/12/2019.
//  Copyright © 2019 Dmitry Filippov. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    
    static let cellId = "ItemCell"
    
    let detailVC = DetailViewController()
    let searchVC = SearchVC()
    
    @IBOutlet var mainDescription: UILabel!
    @IBOutlet var altDescription: UILabel!
    @IBOutlet var authorName: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var itemImageView: CellImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
//        addGesture(view: itemImageView)
        setWidth()

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

    }
    
    private func setWidth() {
        guard let width = contentView.superview?.frame.width else {
            print("CONTENTVIEW'S SUPERVIEW is nil")
            return }
        contentView.frame.size.width = width
    }
    
//    private func addGesture(view: UIView) {
//        print("GESTURE HAS BEEN ADDED")
////        let controller = searchVC.navigationItem.searchController
////        print("CONTROLLER", controller)
//
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentVC))
//        view.addGestureRecognizer(tapGesture)
//    }
//
//    @objc func presentVC() {
//        print("TAP GESTURE REACT")
//
//        searchVC.present(detailVC, animated: true, completion: nil)
//    }
    
    func setupCell(item: UnsplashItem) {
//        contentView.backgroundColor = .gray
        
        setupAuthorLabel(item: item)
        setupDescriptionLabels(item: item)
        setupDateLabel(item: item)
        setupItemImageView(item: item)
        
    }
    
    func setupItemImageView(item: UnsplashItem) {

        itemImageView.setupView(url: URL(string: item.urls.thumb)!)
//        itemImageView.loadImage(url: URL(string: item.urls.small)!)
//        itemImageView.contentMode = .scaleToFill
//        itemImageView.layer.cornerRadius = 10
//        itemImageView.layer.masksToBounds = true
//        itemImageView.clipsToBounds = true
        
    }
    
    func setupAuthorLabel(item: UnsplashItem) {
        authorName.text = item.user.name
        authorName.textAlignment = .center
        authorName.layer.cornerRadius = authorName.frame.height / 2
        authorName.clipsToBounds = true
        authorName.backgroundColor = .systemTeal
        authorName.textColor = .systemPink
    }
    
    func setupDescriptionLabels(item: UnsplashItem) {
        mainDescription.text = item.description
        mainDescription.numberOfLines = 0
        mainDescription.adjustsFontSizeToFitWidth = true
        
        altDescription.text = item.alt_description
        altDescription.numberOfLines = 0
        altDescription.adjustsFontSizeToFitWidth = true
    }
    
    func setupDateLabel(item: UnsplashItem) {
        let dateInfo = getDateIso8601(string: item.created_at)
        date.text = getStringIso8601(date: dateInfo)
        date.textColor = .gray
        date.font = .italicSystemFont(ofSize: CGFloat(17))
    }
    
    private func getDateIso8601(string: String) -> Date? {
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: string)
    }
    
    private func getStringIso8601(date: Date?) -> String {
        guard let date = date else { return ""}
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withYear, .withMonth, .withDay, .withDashSeparatorInDate]
        let stringFromDate = formatter.string(from: date)
        return stringFromDate
    }
}
