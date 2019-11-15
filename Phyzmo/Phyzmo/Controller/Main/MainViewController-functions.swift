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
      //cell.backgroundColor = .black
      // Configure the cell
        
        /*var index = indexPath[1]
        let cell = tableView.dequeueReusableCell(withIdentifier: "objectCell", for: indexPath) as! ObjectTableViewCell
        cell.checkMark = nil
        cell.awakeFromNib()
        let size = CGSize(width: tableView.frame.width, height: height(for: indexPath))
        cell.initCellFrom(size: size)
        cell.object = (self.tabBarController as! DataViewController).video!.objects_detected![indexPath.row]
        cell.objects_detected = (self.tabBarController as! DataViewController).video!.objects_detected!
        cell.objects_selected = (self.tabBarController as! DataViewController).video!.objects_selected
        
        cell.selectionStyle = .none
        
        return cell*/
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
            
        }
        else{
            self.video = videos[indexPath.item]
            self.video?.contruct(completion: {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "MainToVideo", sender: self)
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
