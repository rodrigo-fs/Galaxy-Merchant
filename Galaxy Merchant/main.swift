//
//  main.swift
//  Galaxy Merchant
//
//  Created by Rodrigo França on 28/04/20.
//  Copyright © 2020 RFS. All rights reserved.
//

import Foundation

var inputs = FileOperationsManager.sharedInstance.loadFile(type: .input)
InputManager.sharedInstance.formatEntrys(inputs: inputs)
var outputs = InputManager.sharedInstance.getAllResponseFormattedData()
FileOperationsManager.sharedInstance.saveFile(text: outputs, type: .output)

