//
//  LightViewController.swift
//  ImSmart
//
//  Created by Cao Do Nguyen on /03/04/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LightViewController: UIViewController {
    
    @IBOutlet private weak var lightsTableView: UITableView!
    
    fileprivate let mockupLights: Variable<[LightViewModel]> = Variable(LightsMockup.lights())
    
    fileprivate let disposalBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindRxCellForRowAtIndexPath()
        bindRxDidSelectRowAtIndexPath()
        
        lightsTableView.separatorColor = UIColor.clear
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationItem.title = Constants.Lights.View.title
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        UIFunctionality.applySmoothAnimation(elementToBeSmooth: lightsTableView)
    }
    
    private func bindRxCellForRowAtIndexPath() {
//        The same as cellForRowAtIndexPath
        mockupLights.asObservable()
            .bindTo(
                lightsTableView
                    .rx
                    .items(
                        cellIdentifier: LightsTableViewCell.cellIdentifier,
                        cellType: LightsTableViewCell.self
                    )
            ) { (index, viewModel, cell) in
                cell.viewModel = viewModel
        }.addDisposableTo(disposalBag)
    }
    
    private func bindRxDidSelectRowAtIndexPath() {
//        The same as didSelectRowAtIndexPath
        lightsTableView
            .rx
            .modelSelected(LightViewModel.self)
            .debounce(0.2, scheduler: MainScheduler.instance)
            .subscribe(onNext: { selectedLightViewModel in
                selectedLightViewModel.isOn.value = !selectedLightViewModel.isOn.value
                if let selectedRowIndexPath = self.lightsTableView.indexPathForSelectedRow {
                    self.lightsTableView.deselectRow(at: selectedRowIndexPath, animated: true)
                    self.lightsTableView.reloadRows(at: [selectedRowIndexPath], with: UITableViewRowAnimation.fade)
                }
            }).addDisposableTo(disposalBag)
    }
}

