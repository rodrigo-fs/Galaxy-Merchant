//
//  FileOperationsManager.swift
//  Galaxy Merchant
//
//  Created by Rodrigo França on 28/04/20.
//  Copyright © 2020 RFS. All rights reserved.
//

import Foundation

class FileOperationsManager{
    enum FileType: String{
        case input = "input.txt"
        case output = "output.txt"
    }
    //TODO: Create texts file
    let inputText = """
glob is I
prok is V
pish is X
tegj is L
glob glob Silver is 34 Credits
glob prok Gold is 57800 Credits
pish pish Iron is 3910 Credits
quanto vale pish tegj glob glob ?
quantos créditos são glob prok Silver ?
quantos créditos são glob prok Gold ?
quantos créditos são glob prok Iron ?
quanto vale wood could woodchuck mood ?
"""
    static var sharedInstance = FileOperationsManager()
    
    private init(){
        saveFile(text: inputText,type: .input)
        //Private init turn this class a Singleton.
    }
    
    func saveFile(text: String, type: FileType){
        if let fileURL = getFormattedFileURL(fileName: type.rawValue){
                do{
                    try text.write(to: fileURL , atomically: false, encoding: .utf8)
                }
                catch {
                    print("Can't save file!")
                }
            }
        else{
            print("Can't get file's path!")
        }
    }
    
    
    func loadFile(type: FileType) -> [String]{
        if let fileURL = getFormattedFileURL(fileName: type.rawValue){
            do{
                let text = try String(contentsOf: fileURL, encoding: .utf8)
                return formatReadData(text: text)
            }
            catch {
                print("Can't load file!")
                return []
            }
        }
        else{
            print("Can't get file's path!")
            return []
        }
    }
    
    private func getFormattedFileURL(fileName:String) -> URL? {
        let dirs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        if let dir = dirs.first {
            return dir.appendingPathComponent(fileName)
        }
        return nil
    }
    
    
    private func formatReadData(text: String)-> [String]{
        return text.split { $0.isNewline }.map({String($0)})
    }
}
