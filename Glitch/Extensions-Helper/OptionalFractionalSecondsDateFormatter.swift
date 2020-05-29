//
//  OptionalFractionalSecondsDateFormatter.swift
//  Glitch
//
//  Created by Jordan Bryant on 5/7/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import Foundation

class OptionalFractionalSecondsDateFormatter: DateFormatter {

    static let withoutSeconds: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXX"
        return formatter
    }()

    func setup() {
        self.calendar = Calendar(identifier: .iso8601)
        self.locale = Locale(identifier: "en_US_POSIX")
        self.timeZone = TimeZone(identifier: "UTC")
        self.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSXXX"
    }

    override init() {
        super.init()
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override func date(from string: String) -> Date? {
        if let result = super.date(from: string) {
            return result
        }
        return OptionalFractionalSecondsDateFormatter.withoutSeconds.date(from: string)
    }
}

extension DateFormatter {
    static let iso8601 = OptionalFractionalSecondsDateFormatter()
}
