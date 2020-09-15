//
//  Utils.swift
//  CustomFont
//
//  Created by Dragon on 9/12/20.
//  Copyright © 2020 Dragon. All rights reserved.
//

import UIKit

struct Utils {
    
    
    static func getAllInstalledCustomFonts() -> [String] {
        var customFontArray:[String] = []
        let familyNames = UIFont.familyNames
        for family in familyNames {
            let fontNames = UIFont.fontNames(forFamilyName: family)
            for font in fontNames {
                if !SystemFontsList.contains(font) {
                    customFontArray.append(font)
                }
            }
        }
        return customFontArray
        
    }
    
    
    /// To get url of document dirctory fo app sandbox environment
    /// - Returns: Returns url of document dirctory fo app sandbox environment
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    
    
    /// Helper function to get UIFont by passing url which is saved previously in document directory
    /// - Parameter urlPath: url string of location of save font
    /// - Returns: UIFont
    static func getUIFontFrom(urlPath: String) -> UIFont? {
        
        if let url = URL.init(string: urlPath) {
            
            let data = NSData(contentsOf: Utils.getDocumentsDirectory().appendingPathComponent(url.lastPathComponent))
            guard let dataFile = data, let ctFontDescriptor = CTFontManagerCreateFontDescriptorFromData(dataFile as CFData) else {
                return nil
            }
            return CTFontCreateWithFontDescriptor(ctFontDescriptor, 0.0, nil) as UIFont
        }
        return nil
    }
    
    
    
    /// Function to add fonts to list of custom font and save in userdefualts
    ///
    /// - Parameter font: CFont class object - Custom font
    static func addFont(font: CFont) {
        
        var fonts: [CFont] = []
        // get old all fonts
        if let tempFonts = Utils.getFonts() {
            fonts = tempFonts
        }
        var fontFound = false
        //Check if font already added
        for tempFont in fonts {
            if tempFont.fontName?.lowercased() == font.fontName?.lowercased() {
                fontFound = true
                break
            }
        }
        
        // if font not added add to list and userdefaults
        if !fontFound {
            if let url = URL.init(string: font.fontUrl ?? "") {
                let data = NSData(contentsOf:url)
                let newUrl = Utils.getDocumentsDirectory().appendingPathComponent(url.lastPathComponent)
                do {
                    try data?.write(to: newUrl, options: .atomic)
                    fonts.append(font)
                    
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        
        Utils.saveFonts(fonts: fonts)
    }
    
    
    
    /// Function to add urls to userdefaults, high level function to be called for viewcontrollers
    /// - Parameter urls: array of urls
    static func addURLFont(urls: [URL]) {
        
        for url in urls {
            let componets = url.lastPathComponent
            let newFonts = CFont.init(name: componets, url: url.absoluteString)
            Utils.addFont(font: newFonts)
        }

    }
    
    
    
    /// Helper function to save fontslist to userdefaults
    /// - Parameter fonts: CFont array
    static func saveFonts(fonts: [CFont]?) {
        if let fonts = fonts {
            let data: NSData? = NSKeyedArchiver.archivedData(withRootObject: fonts) as NSData
            UserDefaults.standard.setValue(data, forKey: "FontKey")
        } else {
            UserDefaults.standard.setValue(nil, forKey: "FontKey")
        }
        UserDefaults.standard.synchronize()
    }
    
    
    /// Helper function to get fontslist from userdefaults
    /// - Returns: CFont array
    static func getFonts() -> [CFont]? {
        if let data = UserDefaults.standard.value(forKey: "FontKey") as? NSData {
            return NSKeyedUnarchiver.unarchiveObject(with: data as Data) as? [CFont]
        } else {
            return nil
        }
    }
    
}
