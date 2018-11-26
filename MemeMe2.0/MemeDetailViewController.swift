//
//  MemeDetailViewController.swift
//  MemeMe2.0
//
//  Created by Rita Dewi on 15/11/2018.
//  Copyright © 2018 RitaDewi. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    var memesInDetailView = Meme()
    
    @IBOutlet weak var memedImage: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        
        memedImage.image = memesInDetailView.memedImage
        memedImage.contentMode = .scaleAspectFit
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }


}
