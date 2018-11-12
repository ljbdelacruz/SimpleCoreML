//
//  ViewInfoViewController.swift
//  SimpleAIVideoRecognition
//
//  Created by Lainel John Dela Cruz on 11/11/2018.
//  Copyright © 2018 Lainel John Dela Cruz. All rights reserved.
//

import UIKit

class ViewInfoViewController: UIViewController {

    
    @IBOutlet weak var UIInfoImage: UIImageView!
    @IBOutlet weak var UIDescription: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.UIDescription.delegate=self;
    }
}

extension ViewInfoViewController:UITextViewDelegate{
}
