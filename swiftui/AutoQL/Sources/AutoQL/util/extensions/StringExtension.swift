//
//  File.swift
//  
//
//  Created by Vicente Rincon on 15/03/22.
//

import Foundation
extension String {
    func encodingURL() -> String{
        return self.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? ""
    }
}
