//
//  String+Search.swift
//  NAB
//
//  Created by Trung Luân on 8/23/20.
//  Copyright © 2020 LuanLT. All rights reserved.
//

import Foundation

extension String {
    
    func searchKey() -> String? {
        let searchText = self.folding.alphanumberic
        if searchText.isEmpty {
            return nil
        }
        return searchText
    }
    
    var folding: String {
        return folding(options: [.diacriticInsensitive, .widthInsensitive, .caseInsensitive], locale: nil)
            /// diacriticInsensitive doesn't work with "đ" character
            .replacingOccurrences(of: "đ", with: "d")
    }
    
    var alphanumberic: String {
        let nonAlphaNumeric = CharacterSet.alphanumerics.inverted
        return components(separatedBy: nonAlphaNumeric).joined()
    }
}
