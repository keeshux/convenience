//
//  String+L10n.swift
//  Convenience
//
//  Created by Davide De Rosa on 9/12/19.
//  Copyright © 2019 Davide De Rosa. All rights reserved.
//

import Foundation

public extension String {
    static func localizedCountry(_ code: String) -> String {
        return Locale.current.localizedString(forRegionCode: code) ?? code
    }

    static func localizedLanguage(_ code: String) -> String {
        return Locale.current.localizedString(forLanguageCode: code)?.capitalized ?? code
    }
}
