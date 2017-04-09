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
    @IBOutlet private weak var brightnessLabel: UILabel!
    @IBOutlet private weak var cellBackground: UIView!
    
    private let disposalBag = DisposeBag()
    
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
                .subscribe(onNext: { cellMustShake in
                    if cellMustShake {
                        UIFunctionality.applyShakyAnimation(elementToBeShake: self.cellBackground, duration: 0.15)
                    } else {
                        self.cellBackground.layer.removeAllAnimations()
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
