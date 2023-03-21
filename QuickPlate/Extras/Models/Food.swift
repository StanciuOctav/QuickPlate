//
//  Food.swift
//  QuickPlate
//
//  Created by Ioan-Octavian Stanciu on 01.03.2023.
//

import Firebase
import FirebaseFirestoreSwift
import Foundation

struct Food: Codable, Identifiable {
    @DocumentID var id: String?
    var foodName: String = ""
    var ingredients: [String] = []
    var price: Double = 0.0
    var stock: Int = 0
    var ingredientsString: String {
        var str = ""
        for index in 0 ..< ingredients.count - 1 {
            str += ingredients[index] + ", "
        }
        return str + ingredients[ingredients.count - 1]
    }
}
