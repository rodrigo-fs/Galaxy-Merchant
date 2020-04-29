//
//  RomanNumericConverter.swift
//  Galaxy Merchant
//
//  Created by Rodrigo França on 28/04/20.
//  Copyright © 2020 RFS. All rights reserved.
//

import Foundation

class RomanNumericConverter{
    static var sharedInstance = RomanNumericConverter()
    private let romanNumeral = ["I":1,"V":5, "X":10, "L":50, "C": 100, "D": 500, "M" : 1000]

    private init() {
        //Private init turn this class a Singleton.
    }
    ///Convert roman string to decimal Integer
    ///- Returns: Value in decimal.
    func romanToNumeric(roman: String) -> Int{
        if validateRoman(roman: roman.uppercased()){
            let reversedRoman = String(roman.reversed()).uppercased()
            var decimal = 0
            var lastNumber = 0
            reversedRoman.forEach{
                let value = romanNumeral["\($0)"]
                if let value = value{
                    decimal = processDecimal(decimal: value, lastNumber: lastNumber, lastDecimal: decimal)
                    lastNumber = value
                }
            }
            return decimal
        }
        //TODO: Throw an error to invalid roman
        return -1
    }
    ///Inner Logic to help romanToNumeric
    private func processDecimal (decimal: Int, lastNumber: Int, lastDecimal: Int) -> Int{
        return lastNumber > decimal ? lastDecimal - decimal : lastDecimal + decimal
    }
    
    ///Method that validate an roman String.
    private func validateRoman(roman:String) -> Bool{
        let regex = "^M{0,3}(CM|CD|D?C{0,3})(XC|XL|L?X{0,3})(IX|IV|V?I{0,3})$"
        return roman.range(of: regex, options: .regularExpression) != nil
    }
}
