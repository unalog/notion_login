//
//  Date+Extension.swift
//  MyNotion
//
//  Created by una on 2021/10/18.
//

import Foundation

extension Date {
    func stringValue(formatter: String = "yyyy.MM.dd") -> String {
        let dateFor = DateFormatter()
        dateFor.locale = Locale(identifier: "ko_kr")
        dateFor.dateFormat = formatter
        return dateFor.string(from: self)
    }
}
