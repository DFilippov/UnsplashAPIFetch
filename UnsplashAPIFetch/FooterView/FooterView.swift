//
//  FooterView.swift
//  UnsplashAPIFetch
//
//  Created by Ayu Filippova on 06/12/2019.
//  Copyright © 2019 Dmitry Filippov. All rights reserved.
//

import UIKit

class FooterView: UIView {
    
    // MARK: - Properties
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    let loadingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica", size: 35)
        label.shadowOffset = CGSize(width: 10, height: 10)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    func setupElements() {

        addSubview(activityIndicator)
        addSubview(loadingLabel)
        
        activityIndicator.topAnchor.constraint(equalTo: topAnchor, constant: 80).isActive = true
        activityIndicator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        activityIndicator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        
        loadingLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 8).isActive = true
        loadingLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
    }
    
    func indicateActivity(text: String) {
        loadingLabel.text = "\(text) is loading..."
        activityIndicator.startAnimating()
    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
        loadingLabel.text = ""
    }
    
    func displayNoMatchesResult(text: String) {
        activityIndicator.stopAnimating()
        loadingLabel.text = "No matches for \n' \(text) ' \nPlease try another text"
    }
}
