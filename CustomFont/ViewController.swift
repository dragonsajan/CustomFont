//
//  ViewController.swift
//  CustomFont
//
//  Created by Dragon on 9/8/20.
//  Copyright © 2020 Dragon. All rights reserved.
//

import UIKit
import MobileCoreServices

class ViewController: UIViewController, UIDocumentPickerDelegate {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var selectedFontLabel: UILabel!
    @IBOutlet weak var testLable: UILabel!
    @IBOutlet weak var testTextView: UITextView!
    
    @IBOutlet weak var tableView: UITableView!
    
    // Array for tableview datasource
    var fontArray: [CFont] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    
    func configureView() {
        fontArray = Utils.getFonts() ?? []
        configureTableview()
        tableView.reloadData()
        tableView.keyboardDismissMode = .onDrag
    }
    
    //MARK: - Button Pressed Events
    @IBAction func downloadFont(_ sender: Any) {
        
        let types = [String("public.truetype-ttf-font"),
                     "com.google.ttf"]

        let picker = UIDocumentPickerViewController(documentTypes: types, in: .import)
        picker.delegate = self
        picker.modalPresentationStyle = .fullScreen
        picker.allowsMultipleSelection = true
        present(picker, animated: true)
    }
    
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {

        //
        // Install Mainbundle font
        /*
        let fontUrl = Bundle.main.url(forResource: "Someone", withExtension: "ttf")
        CTFontManagerRegisterFontURLs([fontUrl] as CFArray, .user, true) { (errors, done) -> Bool in
            if(done) {
                print("Done")
            }
            print(errors as Array)
            let familyNames = UIFont.familyNames
                for family in familyNames {
                    print("Family name " + family)
                    let fontNames = UIFont.fontNames(forFamilyName: family)
                    for font in fontNames {
                        print("    Font name: " + font)
                    }
                }
                            
            print("ok")
            return true
        }
        */
        
        
        //Install fonts to document directory after downloading
        Utils.addURLFont(urls: urls)
        fontArray = Utils.getFonts() ?? []
        tableView.reloadData()
    }
    
}




extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func configureTableview() {
        tableView.register(UINib.init(nibName: CustomFontCell.identifier, bundle: nil), forCellReuseIdentifier:  CustomFontCell.identifier)
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.dataSource =  self
        tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fontArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomFontCell.identifier) as!  CustomFontCell
        cell.configureViewWith(font: fontArray[indexPath.row])
        cell.installPressed = {
            
            //
            //Install Not working
            // Error fonts must be in mainbundle
            print("Install Pressed")
            if let fontUrl = self.fontArray[indexPath.row].getInstallFontURL {
                CTFontManagerRegisterFontURLs([fontUrl] as CFArray, .persistent, true) { (errors, done) -> Bool in
                    if(done) {
                        print("Done")
                    }
                    print(errors as Array)
                    return true
                }
            }
            //
            
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let fontURL = fontArray[indexPath.row].fontUrl, let uifont = Utils.getUIFontFrom(urlPath: fontURL) {
            self.testLable.font = uifont.withSize(40)
            self.testTextView.font = uifont.withSize(40)
            self.selectedFontLabel.text = uifont.fontName
            self.testLable.layoutIfNeeded()
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
}

