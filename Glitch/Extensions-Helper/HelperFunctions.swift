//
//  HelperFunctions.swift
//  Social.ly
//
//  Created by Jordan Bryant on 1/28/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

class HelperFunctions {
    
    static func formatPoints(from: Int) -> String {
        let number = Double(from)
        let thousand = number / 1000
        let million = number / 1000000
        let billion = number / 1000000000

        var roundedString = ""
        if billion >= 1 {
            roundedString = "\(round(billion*10)/10)B"
        } else if million >= 1 {
            roundedString = "\(round(million*10)/10)M"
        } else if thousand >= 1 {
            roundedString = ("\(round(thousand*10/10))K")
        } else {
            roundedString = "\(Int(number))"
        }
        
        return roundedString.replacingOccurrences(of: ".0", with: "")
    }
    
    static func getYoutubeTimeAgo(fromString: String) -> String {
        let publishedAtDate = DateFormatter.iso8601.date(from: fromString) ?? Date()
        
        let currentDate = Date()
        
        let relativeFormatter = RelativeDateTimeFormatter()
        relativeFormatter.dateTimeStyle = .named
        relativeFormatter.unitsStyle = .full
        
        let timeAgo = relativeFormatter.localizedString(for: publishedAtDate, relativeTo: currentDate)
        
        if timeAgo == "yesterday" || timeAgo == "now" {
            return timeAgo.capitalized
        } else if timeAgo == "last month" {
            return "Last month"
        } else if timeAgo == "last week" {
            return "Last Week"
        } else {
            return timeAgo
        }
    }
    
    static func textWithImageBefore(text: String, image: UIImage, yValue: Int, height: Int, width: Int) -> NSMutableAttributedString {
        let attributedText = NSMutableAttributedString(string: "")
        
        let imageAttachment = NSTextAttachment(image: image.withRenderingMode((.alwaysTemplate)))
        imageAttachment.bounds = CGRect(x: 0, y: yValue, width: width, height: height)
        let imageString = NSAttributedString(attachment: imageAttachment)
        
        attributedText.append(imageString)
        attributedText.append(NSMutableAttributedString(string: " \(text)"))
        
        return attributedText
    }
    
    static func textWithImageAfter(text: String, image: UIImage, yValue: Int, height: Int, width: Int) -> NSMutableAttributedString {
        let attributedText = NSMutableAttributedString(string: "")
        
        let imageAttachment = NSTextAttachment(image: image.withRenderingMode((.alwaysTemplate)))
        imageAttachment.bounds = CGRect(x: 0, y: yValue, width: width, height: height)
        let imageString = NSAttributedString(attachment: imageAttachment)
        
        attributedText.append(NSMutableAttributedString(string: "\(text) "))
        attributedText.append(imageString)
        
        return attributedText
    }
    
    static func getTwitterUsernameString(username: String, displayName: String, verified: Bool, fontSize: Int, blueCheckSize: Int) -> NSMutableAttributedString {
        let attributedText = NSMutableAttributedString(string: "")
        let usernameString = NSMutableAttributedString(string: "\(username) ")
        let displayNameString: NSMutableAttributedString!
        
        usernameString.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: CGFloat(fontSize)), range: NSRange(location: 0, length: usernameString.length))
        
        attributedText.append(usernameString)
        
        if verified {
            if let image = UIImage(named: "twitterVerifiedIcon")?.withRenderingMode(.alwaysTemplate) {
                let imageAttachment = NSTextAttachment(image: image)
                imageAttachment.bounds = CGRect(x: 0, y: -2, width: blueCheckSize, height: blueCheckSize)
                let imageString = NSAttributedString(attachment: imageAttachment)
                
                attributedText.append(imageString)
            }
            displayNameString = NSMutableAttributedString(string: " @\(displayName)")
        } else {
            displayNameString = NSMutableAttributedString(string: "@\(displayName)")
        }
        
        displayNameString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.twitterGrayText(), range: NSRange(location: 0, length: displayNameString.length))
        displayNameString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: CGFloat(fontSize)), range: NSRange(location: 0, length: displayNameString.length))
        
        if displayName != "" {
            attributedText.append(displayNameString)
        }
        
        return attributedText
    }
    
    static func getTwitterTimeAgo(fromString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
        let publishedAtDate = dateFormatter.date(from: fromString) ?? Date()
        
        let currentDate = Date()
        
        let relativeFormatter = RelativeDateTimeFormatter()
        relativeFormatter.dateTimeStyle = .named
        relativeFormatter.unitsStyle = .full
        
        let timeAgo = relativeFormatter.localizedString(for: publishedAtDate, relativeTo: currentDate)
        
        if timeAgo == "yesterday" || timeAgo == "now" {
            return timeAgo.capitalized
        } else {
            return timeAgo
        }
    }
    
    static func getTwitterText(text: String) -> NSMutableAttributedString {
        let nsText = NSString(string: text)
        let attributedText = NSMutableAttributedString(string: text)
        
        let words = nsText.components(separatedBy: [" ", "\n", ".", ",", "!", "?", ";", ":", ">", "<", "-", "~", "\"", "'", ")", "(", "+", "=", "|", "/", "&", "%", "^", "$", "*", "{", "}", "\\", "’"])
        
        attributedText.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 15), range: NSRange(location: 0, length: attributedText.length))
        attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: attributedText.length))
        
        for word in words {
            if word.hasPrefix("@") {
                let range = nsText.range(of: word)
                
                attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.twitterLightBlue(), range: range)
                attributedText.addAttribute(.link, value: word, range: range)
            } else if word.hasPrefix("#") {
                let range = nsText.range(of: word)
                
                attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.twitterLightBlue(), range: range)
                attributedText.addAttribute(.link, value: word, range: range)
            }
        }
        
        return attributedText
    }
    
    static func getRandomAlphanumericString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    static func storePngToFile(image: UIImage, pathComponent: String, size: CGSize) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let imageToStore = HelperFunctions.resizeImage(image: image, newSize: size)
        
        if let data = imageToStore.pngData() {
            let fileName = documentsDirectory.appendingPathComponent(pathComponent)
            try? data.write(to: fileName)
        }
    }
    
    static func getImageFromFile(pathComponent: String) -> UIImage? {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let imageUrl = documentsDirectory.appendingPathComponent(pathComponent)
        if FileManager.default.fileExists(atPath: imageUrl.path) {
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image
        } else {
            return nil
        }
    }
    
    static func resizeImage(image: UIImage, newSize: CGSize) -> (UIImage) {
        let newRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height).integral
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return image }

        // Set the quality level to use when rescaling
        context.interpolationQuality = CGInterpolationQuality.high
        let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: newSize.height)

        context.concatenate(flipVertical)
        // Draw into the context; this scales the image
        context.draw(image.cgImage!, in: CGRect(x: 0.0,y: 0.0, width: newRect.width, height: newRect.height))

        guard let newImageRef = context.makeImage() else { return image }
        let newImage = UIImage(cgImage: newImageRef)

        // Get the resized image from the context and a UIImage
        UIGraphicsEndImageContext()

        return newImage
    }
}

