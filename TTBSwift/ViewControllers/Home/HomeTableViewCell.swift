//
//  HomeTableViewCell.swift
//  TTBSwift
//
//  Created by Mohamed Belfekih on 05/02/2018.
//  Copyright © 2018 Mohamed Belfekih. All rights reserved.
//

import UIKit

protocol HomeTableViewCellDelegate {
    func firstDelegate(string: String)
}

class HomeTableViewCell: UITableViewCell {
    var station : Station!
    var delegate: HomeTableViewCellDelegate?
    @IBOutlet weak var stationName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setStation(station:Station){
        self.station = station
        self.stationName.text = station.streetName        
    }
    
    @IBAction func tapButton(_ sender: Any) {
        delegate?.firstDelegate(string: "3asba l swiden")
    }
}
