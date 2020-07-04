//
//  Languages.swift
//  Spy Hunter
//
//  Created by Roman Kavinskyi on 08.06.2020.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit

class Languages: NSObject {
    
    /// Language code to show in application to choese
    fileprivate(set) static var languages: [Language] = {
        
        var languages: [Language] = []
        languages.append(Language(languageCode: "en", language: "English"))
        languages.append(Language(languageCode: "uk", language: "Українська"))
        languages.append(Language(languageCode: "ru", language: "Русский"))
        languages.append(Language(languageCode: "vi", language: "Tiếng Việt"))
        return languages
    }()

    // Find a Language Available for Application or not
    //
    // - Parameter code: Language code, exe. en
    // - Returns: true/false
    class func isLanguageAvailable(_ code: String) -> Bool {
        for language in languages {
            if  code == language.languageCode {
                return true
            }
        }
        return false
    }

    // Find a Language based on it's Language code
    //
    // - Parameter code: Language code, exe. en
    // - Returns: Language
    class func languageFromLanguageCode(_ code: String) -> Language {
        for language in languages {
            if  code == language.languageCode {
                return language
            }
        }
        return Language.emptyLanguage
    }
    // Find a Language based on it's Language Name
    //
    // - Parameter languageName: languageName, exe. english
    // - Returns: Language
    class func languageFromLanguageName(_ languageName: String) -> Language {
        for language in languages {
            if languageName == language.language {
                return language
            }
        }
        return Language.emptyLanguage
    }
    
}

