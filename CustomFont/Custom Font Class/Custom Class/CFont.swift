//
//  Font.swift
//  CustomFont
//
//  Created by Dragon on 9/12/20.
//  Copyright © 2020 Dragon. All rights reserved.
//

import UIKit

class CFont: NSObject, Codable, NSCoding {
    
    var fontName:       String?
    var fontUrl:        String?
    var isInstalled:    Bool?
    
    var getInstallFontURL: URL? {
        if let url = URL.init(string: fontUrl ?? "") {
            return Utils.getDocumentsDirectory().appendingPathComponent(url.lastPathComponent)
        }
        return nil
    }
    
    //
    override init() {}
    
    init(name: String, url: String) {
        self.fontName = name
        self.fontUrl = url
    }
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(fontName, forKey: Keys.fontName)
        aCoder.encode(fontUrl, forKey: Keys.fontUrl)
        aCoder.encode(isInstalled, forKey: Keys.isInstalled)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fontName        = aDecoder.decodeObject(forKey: Keys.fontName) as? String
        fontUrl         = aDecoder.decodeObject(forKey: Keys.fontUrl) as? String
        isInstalled     = aDecoder.decodeObject(forKey: Keys.isInstalled) as? Bool
    }
    
    // Mapping Keys
    struct Keys {
        static let fontName         = "fontName"
        static let fontUrl          = "fontUrl"
        static let isInstalled      = "isInstalled"
    }
}



