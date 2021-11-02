//
//  SecondViewController.swift
//  APIDataPassing
//
//  Created by Mac on 28/09/21.
//

import UIKit

class SecondViewController: UIViewController {
    //
    //MARK: Outlets
    //
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var bodyTextView: UITextView!
    
    var titleData: String?
    var bodyData:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Details Page"
        titleTextView.text = titleData
        bodyTextView.text = bodyData
    }
}
