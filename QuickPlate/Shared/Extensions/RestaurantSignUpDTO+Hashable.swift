//
//  RestaurantSignUpDTO.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 11.12.2022.
//

import Foundation

extension RestaurantSignUpDTO: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: RestaurantSignUpDTO, rhs: RestaurantSignUpDTO) -> Bool {
        return lhs.id == rhs.id
    }
}
