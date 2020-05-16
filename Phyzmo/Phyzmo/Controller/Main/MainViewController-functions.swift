//
//  MainViewCollectionViewController.swift
//  Phyzmo
//
//  Created by Anik Gupta on 11/13/19.
//  Copyright © 2019 Athena. All rights reserved.
//

import Foundation
import UIKit
extension MainViewController: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1//thumbnails.count
    }
    
    //2
    func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView
        .dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GalleryCollectionViewCell
        cell.awakeFromNib()
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = Int(availableWidth / itemsPerRow)
        let size = CGSize(width: widthPerItem, height: widthPerItem)
        
        cell.initCellFrom(size: size)
        cell.thumbnail = videos[indexPath.row].thumbnail
        cell.isSelectionMode = selectButton.isSelected
        print(selectButton.isSelected)
        cell.isSelectedCell = videosSelected.contains(videos[indexPath.row].id)
    
        return cell
    }
}

extension MainViewController : UICollectionViewDelegateFlowLayout {
  //1
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    //2
    let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
    let availableWidth = view.frame.width - paddingSpace
    let widthPerItem = Int(availableWidth / itemsPerRow)
    
    return CGSize(width: widthPerItem, height: widthPerItem)
  }
  
  //3
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    return sectionInsets
  }
  
  // 4
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return sectionInsets.left
  }

    private func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      maximumLineSpacingForSectionAt section: Int) -> CGFloat {
    return sectionInsets.left
    }
}
extension MainViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        if selectButton.isSelected {
            (collectionView.cellForItem(at: indexPath) as! GalleryCollectionViewCell).checkMark.checked = !(collectionView.cellForItem(at: indexPath) as! GalleryCollectionViewCell).checkMark.checked
            
            (collectionView.cellForItem(at: indexPath) as! GalleryCollectionViewCell).imageTint.isHidden = !(collectionView.cellForItem(at: indexPath) as! GalleryCollectionViewCell).imageTint.isHidden
            if videosSelected.contains(videos[indexPath.row].id){
                videosSelected.remove(at: videosSelected.firstIndex(of: videos[indexPath.row].id)!)
            }
            else{
                videosSelected.append(videos[indexPath.row].id)
            }
            print(videosSelected)
            
        }
        else{
            self.blurEffectView.isHidden = false
            self.video = videos[indexPath.item]
            self.loading.isHidden = false
            self.loading.startAnimating()
            self.toggleEnableAll(false)
            self.video?.construct(completion: {
                DispatchQueue.main.async {
                    self.loading.isHidden = true
                    self.loading.stopAnimating()
                    self.blurEffectView.isHidden = true
                    self.performSegue(withIdentifier: "MainToVideo", sender: self)
                    self.toggleEnableAll(true)
                }
                
            })
            
        }
        if videosSelected.count == 0 {
            trashButton.isEnabled = false
        }
        else{
            trashButton.isEnabled = true
        }
    }
    
    
}
