//
//  View+Extensions.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 04.12.2022.
//

import Foundation
import SwiftUI

extension View {
    @ViewBuilder
    func hidden(_ shouldHide: Bool) -> some View {
        switch shouldHide {
        case true: hidden()
        case false: self
        }
    }
}
