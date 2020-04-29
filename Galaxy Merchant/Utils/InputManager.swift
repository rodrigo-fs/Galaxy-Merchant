//
//  InputManager.swift
//  Galaxy Merchant
//
//  Created by Rodrigo França on 28/04/20.
//  Copyright © 2020 RFS. All rights reserved.
//

import Foundation

class InputManager{
    //Singleton
    static var sharedInstance = InputManager()
    private var responsesData: [String] = []
    private var valuesData: [String: String] = [:]
    private var creditsData: [String: Float] = [:]
    private init() {
        //Private init turn this class a Singleton.
    }
    
    func formatEntrys(inputs:[String]){
        inputs.forEach({
            let text = $0.lowercased()
            if text.contains("?"){
                let splittedText = text.split(separator: " ").map({return String($0)})
                processResponseData(question: splittedText)
            }
            else if text.contains("is"){
                var splittedText = text.split(separator: " ").map({return String($0)})
                if splittedText.count <= 3{
                    addValueData(item: splittedText.first, value: splittedText.last)
                }
                else{
                    //TODO: Change it to regex
                    splittedText.removeAll(where: { $0 == "is" || $0 == "credits" })
                    let value = splittedText.removeLast()
                    processValuesData(items: splittedText, value: value)
                }
            }
        })
    }
    
    private func addValueData(item: String?, value: String?){
        if let item = item{
            if let value = value?.uppercased() {
                valuesData[item] = value
            }
        }
    }
    
    private func addCreditsData(item: String?, value: Float?){
        if let item = item {
            if let value = value {
                creditsData[item] = value
            }
        }
    }
    
    private func getValueData(item: String) -> String?{
        return valuesData[item]
    }
    
    private func getCreditData(item: String?) -> Float? {
        if let item = item {
            return creditsData[item]
        }
        return nil
    }

    
    private func processValuesData(items: [String], value: String){
        //TODO: Develop solution for n variables
        do{
            let romanValue = try getFormattedRoman(items: items)
            let firsPart = Float(RomanNumericConverter.sharedInstance.romanToNumeric(roman: romanValue))
            if let secondPart = Float(value){
                let total = secondPart/firsPart
                addCreditData(item: items.last, value: total)
            }
        }
        catch{
            print("Can't process information")
        }
    }
    
    private func addCreditData(item: String?, value: Float){
        if let item = item{
            creditsData[item] = value
        }
    }
    
    private func processResponseData(question:[String]){
        let isCredit = question.contains("créditos")
        var isValid = true
        var products = question
        var resultText = isCredit ? "is %d Credits" : "is %d"
        var result: Float = 0
        //TODO: Change it to regex
        products.removeAll{ $0 == "quanto" || $0 == "vale" || $0 == "?" || $0 == "quantos" || $0 == "créditos" || $0 == "são" }
        do{
            if isCredit {
                let romanValue = try getFormattedRoman(items: products)
                let firstPart = Float(RomanNumericConverter.sharedInstance.romanToNumeric(roman: romanValue))
                if let secondPart = getCreditData(item: products.last){
                    result = firstPart * secondPart
                }
            }
            else {
                let romanValue = try getFormattedRoman(items: products)
                result = Float(RomanNumericConverter.sharedInstance.romanToNumeric(roman: romanValue))
            }
        }
        catch{
            isValid = false
        }
        resultText = isValid ? String(format: resultText, Int(result)) : "I have no idea what you are talking about."
        resultText = isValid ? products.reduce("", {return $0 + $1 + " "}) + resultText : resultText
        responsesData.append(resultText)
    }
    
    func getAllResponseFormattedData() -> String{
        responsesData.forEach({print ($0)})
        return responsesData.reduce(""){ $0 + $1 + "/n" }
    }
    
    private func getFormattedRoman(items: [String]) throws -> String {
        var romanValue = ""
        for item in items {
            if !valuesData.keys.contains(where: {$0 == item}){
                break
            }
            if let itemValue = getValueData(item: item){
                romanValue += itemValue
            }
        }
        if romanValue.isEmpty{
            throw InputManagerError.invalidEntry
        }
        return romanValue
    }
}
