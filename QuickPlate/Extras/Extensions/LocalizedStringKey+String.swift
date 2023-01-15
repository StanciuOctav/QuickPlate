//
//  LocalizedStringKey+Hashable.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 02.01.2023.
//

import Foundation
import SwiftUI

extension LocalizedStringKey {
    var stringKey: String? {
        Mirror(reflecting: self).children.first(where: { $0.label == "key" })?.value as? String
    }
    
    func stringValue(locale: Locale = .current) -> String {
        return .localizedString(for: stringKey ?? "", locale: locale)
    }
}

extension String {
    static func localizedString(for key: String,
                                locale: Locale = .current) -> String {
        let language = locale.language.languageCode?.identifier
        let path = Bundle.main.path(forResource: language, ofType: "lproj")!
        let bundle = Bundle(path: path)!
        let localizedString = NSLocalizedString(key, bundle: bundle, comment: "")

        return localizedString
    }
}
