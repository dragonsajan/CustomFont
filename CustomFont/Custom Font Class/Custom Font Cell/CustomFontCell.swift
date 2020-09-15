//
//  CustomFontCell.swift
//  CustomFont
//
//  Created by Dragon on 9/12/20.
//  Copyright © 2020 Dragon. All rights reserved.
//

import UIKit

class CustomFontCell: UITableViewCell {
    
    static let identifier = "CustomFontCell"

    @IBOutlet fileprivate weak var installButton: UIButton!
    
    @IBOutlet fileprivate weak var fontNameLabel: UILabel!
    @IBOutlet fileprivate weak var fontStyleLable: UILabel!
    
    var installPressed: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func installPressed(_ sender: Any) {
        if let installPressed = installPressed {
            installPressed()
        }
    }
    
    
    
    func configureViewWith(font: CFont) {
        self.fontNameLabel.text = "Font Name:  \(font.fontName ?? "")"
        if let url = font.fontUrl {
            self.fontStyleLable.font = Utils.getUIFontFrom(urlPath: url)?.withSize(40)
//            if let font = Utils.getUIFontFrom(urlPath: url) {
//                self.fontStyleLable.font = font.withSize(80)
//            }
        }
//        self.fontStyleLable.font = self.fontStyleLable.font.withSize(80)
        
    }
    
}
