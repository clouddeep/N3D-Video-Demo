//
//  ViewController.swift
//  Theia Video Demo
//
//  Created by Tuan Shou Cheng on 2017/12/20.
//  Copyright © 2017年 Tuan Shou Cheng. All rights reserved.
//

import UIKit
import AVFoundation

let kDebugMode = false

class MainViewController: UIViewController {
    
    let extensionType = "mp4"
    
    // table view data
    let videoTitleArray = ["Captain American", "Maroon5", "Star Wars"]
    let videoDescriptionArray = ["Ironman comes! Everybody out!",
                                 "what lovers do",
                                 "star war trailer"]
    
    var assetArray = [AVAsset]()
    
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            let nib = UINib(nibName: "TheiaVideoCell", bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: TheiaVideoCell.identifier)
            tableView.tableFooterView = UIView(frame: .zero)
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if kDebugMode == false {
            loadDataAsync()
        }
        
        navigationItem.titleView = UIImageView(image: UIImage(named: "threal_mark"))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(pickVideoOrientation))
    }
    
    @objc func pickVideoOrientation() {
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let rightAction = UIAlertAction(title: "Landscape Right", style: .default) { (action) in
            TVDProfile.shared.deviceLandscapeOrientation = .right
        }
        
        let leftAction = UIAlertAction(title: "Landscape Left", style: .default) { (action) in
            TVDProfile.shared.deviceLandscapeOrientation = .left
        }
        
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        sheet.addAction(cancelAction)
        sheet.addAction(rightAction)
        sheet.addAction(leftAction)
        
        present(sheet, animated: true, completion: nil)
    }
}

extension MainViewController {
    
    // MARK: - Data loading
    
    fileprivate func loadDataAsync() {
        let group = DispatchGroup()
        let groupQueue = DispatchQueue(label: "group queue")
        
        let workItem = DispatchWorkItem { [weak self] in
            self?.didFinishLoading()
        }
        
        loadAllVideos(group: group)
       
        group.notify(queue: groupQueue, work: workItem)
    }
    
    fileprivate func loadAllVideos(group: DispatchGroup) {
        
        if let allPath = Bundle.main.urls(forResourcesWithExtension: extensionType, subdirectory: nil) {
            
            for url in allPath {
                
                group.enter()
                
                let asset = AVAsset(url: url)
                asset.loadValuesAsynchronously(forKeys: ["tracks"], completionHandler: {
                    
                    var trackLoadingError: NSError?
                    
                    do {
                        guard asset.statusOfValue(forKey: "tracks", error: &trackLoadingError) == .loaded else {
                            throw trackLoadingError!
                        }
                        
                        print("duration = \(CMTimeGetSeconds(asset.duration))")
                        
                        DispatchQueue.main.async(execute: { [weak self] in
                            self?.assetArray.append(asset)
                        })
                        
                        group.leave()
                    } catch {
                        print("some loading error")
                    }
                })
            }
            
            
        }
    }
    
    func didFinishLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.assetArray.sort(by: { (a, b) -> Bool in
                return CMTimeGetSeconds(a.duration) > CMTimeGetSeconds(b.duration)
            })
            self?.tableView.reloadData()
        }
    }
}

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = VideoPlayerViewController()
        let nc = AFPNavigationController(rootViewController: vc)
        vc.videoAsset = assetArray[indexPath.row]
        
        present(nc, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Count = \(assetArray.count)")
        return kDebugMode ? 10 : assetArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TheiaVideoCell.identifier, for: indexPath) as? TheiaVideoCell else { fatalError("unexpected cell in table view") }
        
        cell.titleLabel.text = videoTitleArray[indexPath.row]
        cell.descriptionLabel.text = videoDescriptionArray[indexPath.row]
        
        let asset = assetArray[indexPath.row]
        
        cell.setupVideoTime(TimeInterval(CMTimeGetSeconds(asset.duration)))

        let imageGen = AVAssetImageGenerator(asset: asset)
        imageGen.appliesPreferredTrackTransform = true
        
        do {
            var actualTime = kCMTimeZero
            let imageRef = try imageGen.copyCGImage(at: kCMTimeZero, actualTime: &actualTime)
            let image = UIImage(cgImage: imageRef)
            cell.videoThumbnailImageView.image = image
        } catch {
            print("gen image false")
        }
        
        
        return cell
    }
}
