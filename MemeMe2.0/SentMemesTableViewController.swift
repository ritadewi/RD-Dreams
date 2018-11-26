//
//  SentMemesTableViewController2TableViewController.swift
//  MemeMe2.0
//
//  Created by Rita Dewi on 14/11/2018.
//  Copyright © 2018 RitaDewi. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController {

    var memesInTableView = [Meme]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memesInTableView = appDelegate.memes
        tableView.reloadData()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memesInTableView.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemesCell", for: indexPath) as! SentMemesTableViewCell
        let memes = memesInTableView[(indexPath as NSIndexPath).row]
        
        cell.customMemesImageView?.image = memes.memedImage!
        cell.customMemesImageView?.layer.borderColor = UIColor.black.cgColor
        cell.customMemesImageView?.layer.borderWidth = 2.0
        cell.customMemesImageView?.layer.cornerRadius = 5.0
        
        let labelDynamicLabel = UILabel()
        labelDynamicLabel.text = memes.topText! + " " + memes.bottomText!
        labelDynamicLabel.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(labelDynamicLabel)
        
        let leadingSpaceConstraint: NSLayoutConstraint = NSLayoutConstraint(item: labelDynamicLabel, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: cell.customMemesImageView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 5)
        
        let yConstraint: NSLayoutConstraint = NSLayoutConstraint(item: labelDynamicLabel, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: cell.contentView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
        
        cell.contentView.addConstraint(leadingSpaceConstraint)
        cell.contentView.addConstraint(yConstraint)
       
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.memesInDetailView = memesInTableView[(indexPath as NSIndexPath).row]
        navigationController?.pushViewController(detailController, animated: true)
    }
}


class SentMemesTableViewCell: UITableViewCell {
    @IBOutlet weak var customMemesImageView: UIImageView!
}
