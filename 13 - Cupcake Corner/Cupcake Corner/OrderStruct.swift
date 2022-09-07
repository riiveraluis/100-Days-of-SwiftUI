//
//  OrderStruct.swift
//  Cupcake Corner
//
//  Created by Luis Rivera Rivera on 3/17/22.
//

import Foundation

struct OrderStruct: Codable, Equatable {
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    var type = 0
    var quantity = 3
    
    var specialRequestEnabled = false {
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
            
        }
    }
    
    var extraFrosting = false
    var addSprinkles = false
    
    var name = ""
    var streetAddress = ""
    var city = ""
    var zip = ""
    
    var hasValidAddress: Bool {
        if name.trimmingCharacters(in: .whitespaces).isEmpty || streetAddress.isEmpty || streetAddress.trimmingCharacters(in: .whitespaces) == "" || city.isEmpty || zip.isEmpty {
            return false
        }
        return true
    }
    
    var priceForTypeSelected: Double {
        switch type {
        case 0:
            return 2.00 + (Double(type) / 2)
        case 1:
            return 2.00 + (Double(type) / 2)
        case 2:
            return 2.00 + (Double(type) / 2)
        case 3:
            return 2.00 + (Double(type) / 2)
            
        default:
            fatalError()
        }
    }
    
    var cost: Double {
        // $2 per cake
        var cost = Double(quantity) * 2
        
        //complicated cakes cost more (Note author don't specify if is per cake. Will include per cake.)
        cost += (Double(type) / 2) * Double(quantity)
        
        // $1/cake for extra frosting
        if extraFrosting {
            cost += Double(quantity)
        }
        
        //$0.50/cake for sprinkles
        if addSprinkles {
            cost += Double(quantity) / 2
        }
        
        return cost
    }
}
