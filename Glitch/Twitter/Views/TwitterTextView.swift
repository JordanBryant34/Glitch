//
//  TwitterTextView.swift
//  Glitch
//
//  Created by Jordan Bryant on 3/14/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

class TwitterTextView: UITextView, UITextViewDelegate {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let pos = closestPosition(to: point) else { return false }
        guard let range = tokenizer.rangeEnclosingPosition(pos, with: .character, inDirection: .layout(.left)) else { return false }

        let startIndex = offset(from: beginningOfDocument, to: range.start)

        return attributedText.attribute(.link, at: startIndex, effectiveRange: nil) != nil
    }
}
