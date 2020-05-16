//
//  GalleryCollectionViewCell.swift
//  Phyzmo
//
//  Created by Anik Gupta on 11/13/19.
//  Copyright © 2019 Athena. All rights reserved.
//

import Foundation
import UIKit
import CheckMarkView
class GalleryCollectionViewCell : UICollectionViewCell {
    var thumbnail: UIImage? {
        didSet {
            if let thumbnail = thumbnail {
                videoThumbnail.image = thumbnail.scaleImageToSize(newSize: CGSize(width: self.frame.size.width * 5, height: self.frame.size.height * 5))
            }
        }
    }
    var isSelectionMode : Bool? {
        didSet {
            if let isSelection = isSelectionMode {
                if isSelection {
                    checkMark.style = .openCircle
                }
            }
            else{
                checkMark.style = .nothing
            }
        }
    }
    var isSelectedCell: Bool? {
        didSet {
            if let selected = isSelectedCell {
                checkMark.checked = selected
                imageTint.isHidden = !selected
            }
        }
    }
    var videoThumbnail: UIImageView!
    var checkMark : CheckMarkView!
    var imageTint : UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func initCellFrom(size: CGSize) {
        
        videoThumbnail = UIImageView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        videoThumbnail.layer.cornerRadius = 7
        videoThumbnail.layer.masksToBounds = true

        contentView.addSubview(videoThumbnail)
        
        imageTint = UIView()
        imageTint.backgroundColor = UIColor(white: 0, alpha: 0.4)
        imageTint.frame = videoThumbnail.frame
        imageTint.isHidden = true
        imageTint.layer.cornerRadius = 7
        imageTint.layer.masksToBounds = true
        contentView.addSubview(imageTint)
        
        checkMark = CheckMarkView(frame: CGRect(x: size.width-30, y: size.height-30, width: 30, height: 30))
        checkMark.checked = false
        checkMark.style = .nothing
        checkMark.contentMode = .scaleAspectFit
        checkMark.backgroundColor = .clear
        //checkMark.style = .openCircle
        contentView.addSubview(checkMark)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        checkMark.removeFromSuperview()
        videoThumbnail.removeFromSuperview()
    }
}
extension UIImage {

    /// Scales an image to fit within a bounds with a size governed by the passed size. Also keeps the aspect ratio.
    /// Switch MIN to MAX for aspect fill instead of fit.
    ///
    /// - parameter newSize: newSize the size of the bounds the image must fit within.
    ///
    /// - returns: a new scaled image.
    func scaleImageToSize(newSize: CGSize) -> UIImage {
        var scaledImageRect = CGRect.zero

        let aspectWidth = newSize.width/size.width
        let aspectheight = newSize.height/size.height

        let aspectRatio = max(aspectWidth, aspectheight)

        scaledImageRect.size.width = size.width * aspectRatio;
        scaledImageRect.size.height = size.height * aspectRatio;
        scaledImageRect.origin.x = (newSize.width - scaledImageRect.size.width) / 2.0;
        scaledImageRect.origin.y = (newSize.height - scaledImageRect.size.height) / 2.0;

        UIGraphicsBeginImageContext(newSize)
        draw(in: scaledImageRect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return scaledImage!
    }
}
