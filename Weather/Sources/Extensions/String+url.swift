//
//  String+url.swift
//  Weather
//
//  Created by 오현식 on 3/25/24.
//

import Foundation

extension String {
    
    /// urlQueryAllowed: ! $ & ' ( ) * + , - . / : ; = ? @ _ ~
    var stringByAddingPercentEncoding: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? self
    }
}
