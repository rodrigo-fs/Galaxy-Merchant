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
    /**
         Method used to process entrys lines from file.
         - Parameters:
             - inputs: inputs from file.
    */
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
    /**
         Method used when  is defined  an value roman numeric to an item from data.
         - Parameters:
             - item: item name.
             - value: roman value.
    */
    private func addValueData(item: String?, value: String?){
        if let item = item{
            if let value = value?.uppercased() {
                valuesData[item] = value
            }
        }
    }
    /**
         Method used to store calculated credit value from item.
         - Parameters:
             - item: item name.
             - value: calculated  value.
    */
    private func addCreditsData(item: String?, value: Float?){
        if let item = item {
            if let value = value {
                creditsData[item] = value
            }
        }
    }
    /**
         Method used to load an specific item value from data.
         - Parameters:
             - item: item name.
         - Returns: Value in roman.
    */
    private func getValueData(item: String) -> String?{
        return valuesData[item]
    }
    
    /**
         Method used to load an specific item credit from data.
         - Parameters:
             - item: item name.
         - Returns: Value in decimal.
    */
    private func getCreditData(item: String?) -> Float? {
        if let item = item {
            return creditsData[item]
        }
        return nil
    }
    
    /**
         Method used to process an credit operation.
         - Parameters:
             - items: items involved in credit operation.
             - value: result involved in credit operation.
    */
    private func processValuesData(items: [String], value: String){
        //TODO: Develop solution for n variables
        do{
            let romanValue = try getFormattedRoman(items: items)
            let firsPart = Float(RomanNumericConverter.sharedInstance.romanToNumeric(roman: romanValue))
            if let secondPart = Float(value){
                let total = secondPart/firsPart
                addCreditsData(item: items.last, value: total)
            }
        }
        catch{
            print("Can't process information")
        }
    }
    
    /**
         Method used to process an response operation.
         - Parameters:
             - question: complete question data.
    */
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
    /**
         Method used to get all response processed data to write in output file.
         - Returns: text formatted to save.
    */
    func getAllResponseFormattedData() -> String{
        responsesData.forEach({print ($0)})
        return responsesData.reduce(""){ $0 + $1 + "/n" }
    }
    
    /**
         Method used to assemble roman's value from credit's data or credit's question.
         - Parameters:
             - items: items involved in operation
         - Throws: `InputManagerError.invalidEntry`
                    if question is invalid.
         - Returns: Roman Value.
    */
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
