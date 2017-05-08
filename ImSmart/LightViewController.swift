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
import NVActivityIndicatorView

class LightViewController: UIViewController, NVActivityIndicatorViewable {
    
    fileprivate var lightViewModel: LightViewModel!
    
    @IBOutlet fileprivate weak var lightsTableView                      : UITableView!
    @IBOutlet fileprivate weak var lightsSelectionButton                : UIBarButtonItem!
    @IBOutlet fileprivate weak var bottomConstraintTableViewToSuperview : NSLayoutConstraint!
    
    fileprivate var cancelSelectionView : UIView!
    fileprivate var cancelButton        : UIButton!
    fileprivate var refreshButton       : UIButton!
    fileprivate var activityIndicator   : NVActivityIndicatorView!
    
    fileprivate let disposalBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lightViewModel = LightViewModel()
                
        guard let _ = self.lightViewModel else {
            print("Light view model not set")
            return
        }
        
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
    
    deinit {
        print("Light VC -> Dead")
    }
   
    fileprivate func bindRxCellForRowAtIndexPath() {
//        The same as cellForRowAtIndexPath
        lightViewModel.allLights.asObservable()
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
    
    fileprivate func bindRxDidSelectRowAtIndexPath() {
//        The same as didSelectRowAtIndexPath
        lightsTableView
            .rx
            .modelSelected(LightCellViewModel.self)
            .debounce(0.2, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] selectedLightCellViewModel in
                guard let _ = self?.lightsTableView.indexPathForSelectedRow else {
                    return
                }
                
                self?.handleCellSelection(
                    selectedLightCellViewModel,
                    selectedRowIndexPath: (self?.lightsTableView.indexPathForSelectedRow!)!
                )
            }).addDisposableTo(disposalBag)
    }
    
    fileprivate func bindRxDidDeselectRowAtIndexPath() {
        lightsTableView
            .rx
            .modelDeselected(LightCellViewModel.self)
            .debounce(0.2, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] deselctedLightCellViewModel in
                self?.lightViewModel.selectedLights.value.removeValue(forKey: deselctedLightCellViewModel.area.value)
            }).addDisposableTo(disposalBag)
    }
    
    fileprivate func bindRxObserver() {
        
        lightViewModel.isFirstTimeGetLights.asObservable()
            .subscribe(onNext: { [weak self] isFirstTimeGetLights in
                if !isFirstTimeGetLights {
                    UIFunctionality.applySmoothAnimation((self?.lightsTableView)!)
                }
            }).addDisposableTo(disposalBag)
        
        Observable.combineLatest(
            lightViewModel.requireCellShake.asObservable(),
            lightViewModel.allLights.asObservable()
        ).subscribe(onNext: { [weak self] _ in
            DispatchQueue.main.async {
                self?.lightsTableView.reloadData()
            }
        }).addDisposableTo(disposalBag)
        
        lightViewModel.viewColorObserver
            .subscribe(onNext: { [weak self] viewBackgroundColor in
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.4, animations: {
                        self?.view.backgroundColor = viewBackgroundColor
                    })
                }
            }).addDisposableTo(disposalBag)
        
        lightViewModel.tableViewColorObserver
            .subscribe(onNext: { [weak self] tableViewBackgroundColor in
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.4, animations: {
                        self?.lightsTableView.backgroundColor = tableViewBackgroundColor
                    })
                }
            }).addDisposableTo(disposalBag)
        
        lightViewModel.tableViewBottomConstraintObserver
            .subscribe(onNext: { [weak self] constant in
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.4, animations: {
                        self?.bottomConstraintTableViewToSuperview.constant = CGFloat(constant)
                    })
                }
            }).addDisposableTo(disposalBag)
        
        lightViewModel.cancelSelectionViewOriginYObserver
            .subscribe(onNext: { [weak self] originY in
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.4, animations: {
                        self?.cancelSelectionView.center.y = CGFloat(originY)
                    })
                }
            }).addDisposableTo(disposalBag)
    
        lightViewModel.barButtonTitleObserver
            .subscribe(onNext: { [weak self] title in
                DispatchQueue.main.async {
                    self?.lightsSelectionButton.title = title
                }
            }).addDisposableTo(disposalBag)
        
        lightViewModel.barButtonEnableObserver
            .subscribe(onNext: { [weak self] shouldEnable in
                DispatchQueue.main.async {
                    self?.lightsSelectionButton.isEnabled = shouldEnable
                }
            }).addDisposableTo(disposalBag)
        
        lightViewModel.activityIndicatorShouldSpin
            .subscribe(onNext: { [weak self] activityIndicatorShouldSpin in
                DispatchQueue.main.async {
                    activityIndicatorShouldSpin ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
                }
            }).addDisposableTo(disposalBag)
        
        lightViewModel.isHavingServerError.asObservable()
            .subscribe(onNext: { [weak self] isHavingServerError in
                DispatchQueue.main.async {
                    if isHavingServerError {
                        self?.showMessage(
                            Constants.Lights.Message.serverError,
                            type: .error,
                            options: [.autoHide(false), .hideOnTap(false), .textNumberOfLines(Constants.longTextLineNumbers), .height(80.0)]
                        )
                        self?.refreshButton.isHidden = false
                    } else {
                        self?.hideMessage()
                        self?.refreshButton.isHidden = true
                    }
                }
            }).addDisposableTo(disposalBag)
        
        lightViewModel.isFailedToUpdate.asObservable()
            .subscribe(onNext: { [weak self] isFailedToUpdate in
                DispatchQueue.main.async {
                    if isFailedToUpdate {
                        self?.showMessage(
                            Constants.Lights.Message.serverError,
                            type: .error,
                            options: [.textNumberOfLines(Constants.longTextLineNumbers), .height(80.0)]
                        )
                    } else {
                        self?.hideMessage()
                    }
                }
            }).addDisposableTo(disposalBag)
    }
    
    fileprivate func bindRxAction() {
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
        
        refreshButton
            .rx
            .tap
            .subscribe(onNext: { [weak self] in
                self?.lightViewModel.isHavingServerError.value = false
                self?.lightViewModel.getAllLights()
            }).addDisposableTo(disposalBag)
    }
    
//** Mark: SUPPORT FUNCTIONS
    
    fileprivate func handleBarButtonAction() {
        if !lightViewModel.requireCellShake.value {
            self.lightViewModel.requireCellShake.value = true
        } else {
            DispatchQueue.main.async {
                CoreDataLightOperations.sharedInstance.storeLights(self.lightViewModel.allLights.value)
                self.performSegue(withIdentifier: Constants.Lights.SegueIdentifier.toBrightnessVC, sender: self)
            }
        }
    }
    
    fileprivate func handleCellSelection(_ selectedLightCellViewModel: LightCellViewModel, selectedRowIndexPath: IndexPath) {
        DispatchQueue.main.async {
            if !self.lightViewModel.requireCellShake.value {
                CoreDataLightOperations.sharedInstance.storeLights(self.lightViewModel.allLights.value)
                self.lightsTableView.deselectRow(at: selectedRowIndexPath, animated: true)
                selectedLightCellViewModel.isOn.value = !selectedLightCellViewModel.isOn.value
                self.lightsTableView.reloadRows(at: [selectedRowIndexPath], with: .fade)
            } else {
                self.lightViewModel.selectedLights.value[selectedLightCellViewModel.area.value] = selectedLightCellViewModel
                self.lightsTableView.selectRow(at: selectedRowIndexPath, animated: true, scrollPosition: .none)
            }
        }
    }
    
    fileprivate func customizeAppearance() {
        self.navigationItem.title       = Constants.Lights.View.title
        self.lightsTableView.isHidden   = true
        drawCancelSelectionView()
        drawCancelButton()
        drawActivityIndicatorView()
        drawRefreshButton()
    }
    
//** Mark: DRAWING CANCEL BUTTON
    
    fileprivate func drawCancelButton() {
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
    
    fileprivate func drawCancelSelectionView() {
        self.cancelSelectionView        = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60))
        
        self.cancelSelectionView.center = CGPoint(
            x: UIScreen.main.bounds.width / 2,
            y: UIScreen.main.bounds.height + CGFloat(30)
        )
        self.cancelSelectionView.backgroundColor = UIColor.gray
        self.cancelSelectionView.alpha           = 0.9
        
        self.view.addSubview(self.cancelSelectionView)
    }
    
//** Mark: DRAWING ACTIVITY INDICATOR VIEW
    
    fileprivate func drawActivityIndicatorView() {
        let frame = CGRect(x: 0, y: 0, width: 90, height: 90)
        self.activityIndicator = NVActivityIndicatorView(
            frame: frame,
            type: .ballRotateChase,
            color: .red,
            padding: 0
        )
        
        self.view.addSubview(activityIndicator)
        
        activityIndicator.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview()
        }
    }
    
//** Mark: DRAWING REFRESH BUTTON
    
    fileprivate func drawRefreshButton() {
        let refreshButtonImage              = UIImage(named: Constants.Lights.View.refreshIcon)?.cgImage
        
        self.refreshButton                  = UIButton()
        refreshButton.layer.contents        = refreshButtonImage
        
        self.view.addSubview(self.refreshButton)
        
        refreshButton.snp.makeConstraints { maker in
            maker.width.equalTo(40)
            maker.height.equalTo(45)
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview()
        }
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

