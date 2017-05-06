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

    @IBOutlet fileprivate weak var lightImageView: UIImageView!
    @IBOutlet fileprivate weak var areaLabel: UILabel!
    @IBOutlet fileprivate weak var brightnessLabel: UILabel!
    @IBOutlet fileprivate weak var cellBackground: UIView!
    
    fileprivate let disposalBag = DisposeBag()
    
    var viewModel: LightCellViewModel? {
        didSet {
            guard let lightCellViewModel = viewModel else {
                return
            }
            
            lightCellViewModel.area.asObservable()
                .bindTo(areaLabel.rx.text)
                .addDisposableTo(disposalBag)
            
            lightCellViewModel.brightness.asObservable()
                .map({ String($0) })
                .bindTo(brightnessLabel.rx.text)
                .addDisposableTo(disposalBag)
            
            lightCellViewModel.cellMustShake.asObservable()
                .subscribe(onNext: { [weak self] cellMustShake in
                    if cellMustShake {
                        UIFunctionality.applyShakyAnimation((self?.cellBackground)!, duration: 0.15)
                    } else {
                        self?.cellBackground.layer.removeAllAnimations()
                    }
                }).addDisposableTo(disposalBag)
            
            lightImageView.image = lightCellViewModel.isOn.value ? UIImage(named: Constants.Lights.View.lightOn) : UIImage(named: Constants.Lights.View.lightOff)
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
