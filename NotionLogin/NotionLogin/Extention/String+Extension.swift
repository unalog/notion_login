//
//  String+Extension.swift
//  MyNotion
//
//  Created by una on 2021/10/18.
//

import Foundation

extension String {
    func dateValue(formatter: String = "yyyy-MM-dd") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.dateFormat = formatter
        
        return dateFormatter.date(from: self)
    }
}
