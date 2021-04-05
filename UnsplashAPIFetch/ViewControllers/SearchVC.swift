//
//  SearchVC.swift
//  UnsplashAPIFetch
//
//  Created by Ayu Filippova on 22/11/2019.
//  Copyright © 2019 Dmitry Filippov. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {
    
    //MARK: - Properties
    var items = [UnsplashItem]()
    let rowHeight = CGFloat(200)
    let networkService = NetworkService()
    let footerView = FooterView()
    var cellImageView = UIView()
    
    // MARK: - Outlets
    @IBOutlet var table: UITableView!
    
    // MARK: - ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setSearchBar()
    }
    
    
    // MARK: - Methods
    private func textPercentage(progress: Float) -> String {
        let percentage = "( \(Int(progress) * 100)%"
        return percentage
    }
    
    // TODO: replace loadingAnimation to new Service
    func loadingAnimation(progress: Float) {
        print("ANIMATION")
        let duration: CFTimeInterval = 3
        
        let  shapeLayer = CAShapeLayer()
        let radius: CGFloat = 100
//        let circular = UIBezierPath(arcCenter: view.center, radius: radius, startAngle: -.pi/2, endAngle: .pi * 2, clockwise: true)
        let circular = UIBezierPath(arcCenter: view.center, radius: radius, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        
        shapeLayer.path = circular.cgPath
        
        shapeLayer.lineWidth = radius / 10
        shapeLayer.lineCap = .round
        shapeLayer.fillColor = UIColor.clear.cgColor
        
        //        let roundedRect = UIBezierPath(roundedRect: CGRect(x: 50, y: 50, width: 100, height: 200), cornerRadius: 20)
        //        shapeLayer.path = roundedRect.cgPath
        //        roundedRect.lineCapStyle = .round
        //        roundedRect.lineWidth = 10
        
        
        let strokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeAnimation.fromValue = 0
        strokeAnimation.toValue = progress
        strokeAnimation.duration = duration
        shapeLayer.add(strokeAnimation, forKey: "roundStroke")
        
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 0.2
        opacityAnimation.toValue = 1
//        opacityAnimation.duration = duration
        shapeLayer.add(opacityAnimation, forKey: "opacityAnimation")
        
        
        let strokeColorAnimation = CABasicAnimation(keyPath: "strokeColor")
        strokeColorAnimation.fromValue = UIColor.gray.cgColor
        strokeColorAnimation.toValue = UIColor.green.cgColor
//        strokeColorAnimation.duration = duration
        shapeLayer.add(strokeColorAnimation, forKey: "strokeColorAnimation")
        
        
        //        let fillColorAnimation = CABasicAnimation(keyPath: "fillColor")
        //        fillColorAnimation.fromValue = UIColor.clear.cgColor
        //        fillColorAnimation.toValue = UIColor.green.cgColor
        //        fillColorAnimation.duration = duration
        //        shapeLayer.add(fillColorAnimation, forKey: "fillColorAnimation")
        
        view.layer.addSublayer(shapeLayer)
    }
    
    
    private func setupTableView() {
        let nib = UINib(nibName: ItemCell.cellId, bundle: nil)
        table.register(nib, forCellReuseIdentifier: ItemCell.cellId)

        table.separatorStyle = .none
        
        table.delegate = self
        table.dataSource = self
        
        table.backgroundColor = .cyan
        setTableConstraints()
//        footerView.frame.size.height = 400
        table.tableFooterView = footerView
    }
    
    private func setTableConstraints() {
        table.translatesAutoresizingMaskIntoConstraints = false

        table.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true

        table.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        table.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        table.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: 0).isActive = true
    }
    
    private func setSearchBar() {
        navigationItem.searchController = UISearchController(searchResultsController: nil)
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController?.searchBar.delegate = self
        navigationItem.searchController?.obscuresBackgroundDuringPresentation = false
    }
    
}

// MARK: - TableView Delegate & Data Source
extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        let cell: ItemCell = table.dequeueReusableCell()

        cell.setupCell(item: item)
        tableView.rowHeight = rowHeight
        return cell
    }

    
    // MARK: TODO: - Implement leading Swipe Action
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let like = UIContextualAction(style: .normal, title: nil) { (action, view, nil) in
            print("Marking as read")
            action.backgroundColor = .orange
            action.image = UIImage(named: "like")
            
//            let label = UILabel(frame: view.frame)
//            label.text = "Like it!"
//            label.font = .boldSystemFont(ofSize: 40)
//            label.backgroundColor = .green
//            label.textColor = .magenta
//            DispatchQueue.main.async {
//                view.addSubview(label)
//                label.translatesAutoresizingMaskIntoConstraints = false
//                label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
//            }

//            completion(true)
        }
        
        let save = UIContextualAction(style: .normal, title: "Save") { (action, view, completion) in
            print("Saved")
            print("view in save contextualAction", view)
//            action.backgroundColor = .green
//            action.image = UIImage(named: "save")
            view.backgroundColor = .green
//            view.largeContentImage = UIImage(named: "save")
        }
        return UISwipeActionsConfiguration(actions: [like, save])
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailViewController()
        guard let itemImageView = table.cellForRow(at: indexPath)?.contentView.subviews.first?.subviews.first(where: { (view) -> Bool in
            return view is CellImageView
        }) as? CellImageView else { return }
        
        // Creating snapshot for transitioning animation (when presenting Detail ViewController)
        let snapshot = itemImageView.snapshotView(afterScreenUpdates: true)!
        cellImageView = snapshot
        cellImageView.frame = itemImageView.convert(itemImageView.frame, to: nil)

        let pictureView = UIImageView(image: itemImageView.image)
        pictureView.frame = itemImageView.frame
        pictureView.layer.cornerRadius = 0.0
        
        // Passing info for initializing DetailVC before presenting it
        detailVC.imageView = pictureView
        let index = indexPath.row
        detailVC.item = items[index]
        detailVC.modalPresentationStyle = .overFullScreen
        detailVC.transitioningDelegate = self
        present(detailVC, animated: true, completion: nil)
    }
}

//MARK: - SearchBarDelegate
extension SearchVC: UISearchBarDelegate {
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
                
//        self.networkService.completionDownloadProgress = { [weak self] progress in
//            //            DispatchQueue.main.async {
//            print(#line, #function, "networkService.completionDownloadProgress")
//            self?.loadingAnimation(progress: progress)
//            //            }
//        }
        print(#line, #function, "networkService", networkService)
        
        guard !searchBar.text!.isEmpty else {
             searchBar.placeholder = "Please enter text for Unsplashing"
            return
        }

        footerView.indicateActivity(text: searchBar.text ?? "")
        let query = searchBar.text
        navigationItem.title = query
        
        networkService.getURLComponents(searchText: searchBar.text!)
        
        DispatchQueue.global().async { [weak self] in
            guard let self = self else {return}
            
            self.networkService.fetch { objects in
                
                
                self.items = objects?.results ?? []

                if self.items.isEmpty == true {
                    DispatchQueue.main.async {
                        self.items = []
                        self.table.reloadData()
                        self.footerView.displayNoMatchesResult(text: searchBar.text!)
                    }
                    
                } else {
                    DispatchQueue.main.async{
                        self.items.forEach { $0.searchQuery = query }
                        self.table.reloadData()
                        self.footerView.stopActivityIndicator()
                        self.table.scrollToRow(at: IndexPath(row: 0, section: 0), at: .none, animated: true)
                    }
                }
            }
        }
    }
}

//MARK: - UIViewControllerTransitioningDelegate
extension SearchVC: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        return VCAnimatedTransitioning(isPresented: true, view: cellImageView)
    }

    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        return VCAnimatedTransitioning(isPresented: false, view: cellImageView)
    }
}
