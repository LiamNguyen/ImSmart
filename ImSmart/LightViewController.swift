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
import SnapKit

class LightViewController: UIViewController {
    
    var lightViewModel: LightViewModel!
    
    @IBOutlet fileprivate weak var lightsTableView                      : UITableView!
    @IBOutlet fileprivate weak var lightsSelectionButton                : UIBarButtonItem!
    @IBOutlet fileprivate weak var bottomConstraintTableViewToSuperview : NSLayoutConstraint!
    
    private var cancelSelectionView: UIView!
    private var cancelButton: UIButton!
    
    fileprivate var mockupLights: Variable<[LightCellViewModel]>!

    fileprivate let disposalBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let _ = self.lightViewModel else {
            print("Light view model not set")
            return
        }
        
        mockupLights = Variable(LightsMockup.lights(lightViewModel: lightViewModel))
        
        customizeAppearance()
        
        bindRxCellForRowAtIndexPath()
        bindRxDidSelectRowAtIndexPath()
        bindRxDidDeselectRowAtIndexPath()
        bindRxAction()
        bindRxObserver()
        
        lightsTableView
            .rx
            .setDelegate(self)
            .addDisposableTo(disposalBag)
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
            .modelSelected(LightCellViewModel.self)
            .debounce(0.2, scheduler: MainScheduler.instance)
            .subscribe(onNext: { selectedLightCellViewModel in
                guard let _ = self.lightsTableView.indexPathForSelectedRow else {
                    return
                }
                
                self.handleCellSelection(
                    selectedLightCellViewModel: selectedLightCellViewModel,
                    selectedRowIndexPath: self.lightsTableView.indexPathForSelectedRow!
                )
            }).addDisposableTo(disposalBag)
    }
    
    private func bindRxDidDeselectRowAtIndexPath() {
        lightsTableView
            .rx
            .modelDeselected(LightCellViewModel.self)
            .debounce(0.2, scheduler: MainScheduler.instance)
            .subscribe(onNext: { deselctedLightCellViewModel in
                self.lightViewModel.selectedLights.value.removeValue(forKey: deselctedLightCellViewModel.area.value)
            }).addDisposableTo(disposalBag)
    }
    
    private func bindRxObserver() {
        lightViewModel.requireCellShake.asObservable()
            .subscribe(onNext: { _ in
                self.lightsTableView.reloadData()
            }).addDisposableTo(disposalBag)
        
        lightViewModel.viewColorObserver
            .subscribe(onNext: { viewBackgroundColor in
                UIView.animate(withDuration: 0.4, animations: { 
                    self.view.backgroundColor = viewBackgroundColor
                })
            }).addDisposableTo(disposalBag)
        
        lightViewModel.tableViewColorObserver
            .subscribe(onNext: { tableViewBackgroundColor in
                UIView.animate(withDuration: 0.4, animations: { 
                    self.lightsTableView.backgroundColor = tableViewBackgroundColor
                })
            }).addDisposableTo(disposalBag)
        
        lightViewModel.tableViewBottomConstraintObserver
            .subscribe(onNext: { constant in
                UIView.animate(withDuration: 0.4, animations: { 
                    self.bottomConstraintTableViewToSuperview.constant = CGFloat(constant)
                })
            }).addDisposableTo(disposalBag)
        
        lightViewModel.cancelSelectionViewOriginYObserver
            .subscribe(onNext: { originY in
                UIView.animate(withDuration: 0.4, animations: { 
                    self.cancelSelectionView.center.y = CGFloat(originY)
                })
            }).addDisposableTo(disposalBag)
    
        lightViewModel.barButtonTitleObserver
            .subscribe(onNext: { title in
                self.lightsSelectionButton.title = title
            }).addDisposableTo(disposalBag)
    }
    
    private func bindRxAction() {
        lightsSelectionButton
            .rx
            .tap
            .subscribe(onNext: { [weak self] in
                self?.handleBarButtonAction()
            }).addDisposableTo(disposalBag)
        
        cancelButton
            .rx
            .tap
            .subscribe(onNext: { [weak self] in
                self?.lightViewModel.requireCellShake.value = false
            }).addDisposableTo(disposalBag)
    }
    
//** Mark: SUPPORT FUNCTIONS
    
    private func handleBarButtonAction() {
        if !lightViewModel.requireCellShake.value {
            self.lightViewModel.requireCellShake.value = true
        } else {
            self.performSegue(withIdentifier: Constants.Lights.SegueIdentifier.toBrightnessVC, sender: self)
        }
    }
    
    private func handleCellSelection(selectedLightCellViewModel: LightCellViewModel, selectedRowIndexPath: IndexPath) {
        if !lightViewModel.requireCellShake.value {
            self.lightsTableView.deselectRow(at: selectedRowIndexPath, animated: true)
            selectedLightCellViewModel.isOn.value = !selectedLightCellViewModel.isOn.value
            self.lightsTableView.reloadRows(at: [selectedRowIndexPath], with: .fade)
        } else {
            lightViewModel.selectedLights.value[selectedLightCellViewModel.area.value] = selectedLightCellViewModel
            self.lightsTableView.selectRow(at: selectedRowIndexPath, animated: true, scrollPosition: .none)
        }
    }
    
    private func customizeAppearance() {
        drawCancelSelectionView()
        drawCancelButton()
    }
    
    
//** Mark: DRAWING CANCEL BUTTON
    
    private func drawCancelButton() {
        let cancelButtonImage    = UIImage(named: Constants.Home.View.cancelButton)?.cgImage
        
        self.cancelButton        = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        self.cancelButton.center = CGPoint(
            x: self.cancelSelectionView.bounds.width / 2,
            y: self.cancelSelectionView.bounds.height / 2
        )
        self.cancelButton.layer.contents = cancelButtonImage
        
        self.cancelSelectionView.addSubview(self.cancelButton)
    }
    
//** Mark: DRAWING CANCEL SELECTION VIEW
    
    private func drawCancelSelectionView() {
        self.cancelSelectionView        = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60))
        
        self.cancelSelectionView.center = CGPoint(
            x: UIScreen.main.bounds.width / 2,
            y: UIScreen.main.bounds.height + CGFloat(30)
        )
        self.cancelSelectionView.backgroundColor = UIColor.gray
        self.cancelSelectionView.alpha           = 0.9
        
        self.view.addSubview(self.cancelSelectionView)
    }
    
//** Mark: SEGUE PREPARATIONS
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Constants.Lights.SegueIdentifier.toBrightnessVC?:
            if let brightnessVC = segue.destination as? BrightnessViewController {
                brightnessVC.lightViewModel = self.lightViewModel
            }
        default:
            return
        }
    }
}

extension LightViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        lightViewModel.cellContentViewColorObserver.asObservable()
            .subscribe(onNext: { cellContentViewBackgroundColor in
                if cell.isSelected {
                    return
                }
                cell.contentView.backgroundColor = cellContentViewBackgroundColor
            }).addDisposableTo(disposalBag)
    }
}

