//
//  LightsTableViewCell.swift
//  ImSmart
//
//  Created by Cao Do Nguyen on /05/04/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import UIKit
import RxSwift

class LightsTableViewCell: UITableViewCell {

    @IBOutlet private weak var lightImageView: UIImageView!
    @IBOutlet private weak var areaLabel: UILabel!
    @IBOutlet private weak var cellBackground: UIView!
    
    private let disposalBag = DisposeBag()
    
    var viewModel: LightViewModel? {
        didSet {
            guard let lightViewModel = viewModel else {
                return
            }
            
            lightViewModel.area.asObservable()
                .bindTo(areaLabel.rx.text)
                .addDisposableTo(disposalBag)
            
            lightImageView.image = lightViewModel.isOn.value ? UIImage(named: Constants.Lights.View.lightOn) : UIImage(named: Constants.Lights.View.lightOff)
        }
    }
    
    static let cellIdentifier = "lightsTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        cellBackground.layer.masksToBounds = false
        cellBackground.layer.cornerRadius  = 4
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
