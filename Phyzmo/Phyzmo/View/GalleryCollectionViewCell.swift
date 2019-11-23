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
                //videoThumbnail.image = thumbnail
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

    /*override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }*/
    
    func initCellFrom(size: CGSize) {
        
        /*eventImage = UIImageView(frame: CGRect(x: 0, y: 10, width: size.width, height: size.height-30))
        eventImage.contentMode = .scaleToFill
        eventImage.layer.cornerRadius = 10
        eventImage.layer.masksToBounds = true
        eventImage.alpha = 1.0
        contentView.addSubview(eventImage)*/

        
        
        videoThumbnail = UIImageView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        //videoThumbnail.contentMode = .scaleAspectFit
        //videoThumbnail = UIImageView()
        
        contentView.addSubview(videoThumbnail)
        
        imageTint = UIView()
        imageTint.backgroundColor = UIColor(white: 0, alpha: 0.4)
        imageTint.frame = videoThumbnail.frame
        imageTint.isHidden = true
        contentView.addSubview(imageTint)
        
        checkMark = CheckMarkView(frame: CGRect(x: size.width-30, y: size.height-30, width: 30, height: 30))
        checkMark.checked = false
        checkMark.style = .nothing
        checkMark.contentMode = .scaleAspectFit
        checkMark.backgroundColor = .clear
        //checkMark.style = .openCircle
        contentView.addSubview(checkMark)
        
        /*eventCreator = UILabel(frame: CGRect(x: 20, y: eventTitle.frame.maxY-70, width: size.width-20, height: 30))
        eventCreator.text = ""
        eventCreator.numberOfLines = 1
        eventCreator.adjustsFontSizeToFitWidth = true
        eventCreator.minimumScaleFactor = 0.3
        eventCreator.font = UIFont(name: "Helvetica-SemiBold", size: 25)
        eventCreator.textColor = .white
        eventCreator.textAlignment = .left
        contentView.addSubview(eventCreator)
        
        icon = UIImageView(frame: CGRect(x: size.width-45, y: 22, width: 30, height: 30))
        icon.contentMode = .scaleAspectFit
        icon.image = UIImage(systemName: "person")
        icon.tintColor = .white
        contentView.addSubview(icon)
        
        attendeeNumber = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        attendeeNumber.center = CGPoint(x: icon.frame.midX, y: icon.frame.maxY + 20)
        attendeeNumber.adjustsFontSizeToFitWidth = true
        attendeeNumber.minimumScaleFactor = 0.3
        attendeeNumber.font = UIFont(name: "Helvetica-Medium", size: 26)
        attendeeNumber.textColor = .white
        attendeeNumber.textAlignment = .center
        contentView.addSubview(attendeeNumber)*/
    }
    /*override public func delete(_ sender: Any?) {
        checkMark.removeFromSuperview()
        checkMark.style = .nothing
        checkMark = nil
    }*/
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
