//
//  Error+CustomError.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 02.01.2023.
//

import Foundation

enum StartupError: Error {
    case signInError
    case anonymousUser
}
