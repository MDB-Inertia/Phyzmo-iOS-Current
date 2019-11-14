//
//  GalleryCollectionViewCell.swift
//  Phyzmo
//
//  Created by Anik Gupta on 11/13/19.
//  Copyright © 2019 Athena. All rights reserved.
//

import Foundation
import UIKit
class GalleryCollectionViewCell : UICollectionViewCell {
    var thumbnail: UIImage? {
        didSet {
            if let thumbnail = thumbnail {
                videoThumbnail.image = thumbnail
            }
        }
    }
    var videoThumbnail: UIImageView!
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
        contentView.addSubview(eventImage)

        
        let imageTint = UIView()
        imageTint.backgroundColor = UIColor(white: 0, alpha: 0.4)
        imageTint.frame = eventImage.frame
        imageTint.layer.cornerRadius = 10
        contentView.addSubview(imageTint)*/
        videoThumbnail = UIImageView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        contentView.addSubview(videoThumbnail)
        
        /*checkMark = CheckMarkView(frame: CGRect(x: size.width-50, y: size.height-45, width: 30, height: 30))
        checkMark.checked = true
        checkMark.style = .openCircle
        checkMark.contentMode = .scaleAspectFit
        checkMark.backgroundColor = .clear
        //checkMark.style = .openCircle
        contentView.addSubview(checkMark)*/
        
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
        //checkMark.removeFromSuperview()
        videoThumbnail.removeFromSuperview()
    }
}
