//
//  AppError.swift
//  MyMusic
//
//  Created by Tarun Kaushik on 07/11/20.
//

import Foundation

enum AppError: Error{
    case invalidInput
    case invalidSelection
    case misc(String)
}

extension AppError: LocalizedError {
    
    public var errorDescription: String? {
        switch  self {
        case .invalidInput:
            return "The input provided in the field is invalid"
            
        case .invalidSelection:
            return "The selected item description does not exists"
            
        case .misc(let value):
            return value
        }
    }
}
