//
//  ViewController.swift
//  InstaGrid
//
//  Created by Yohan W. Dunon on 30/11/2019.
//  Copyright © 2019 Yohan W. Dunon. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - PROPERTIES
    
    /// Add picture buttons outlets
    @IBOutlet weak var addPictureBtn1: UIButton!
    @IBOutlet weak var addPictureBtn2: UIButton!
    @IBOutlet weak var addPictureBtn3: UIButton!
    @IBOutlet weak var addPictureBtn4: UIButton!
    /// Layout buttons outlets
    @IBOutlet weak var layoutBtn1: UIButton!
    @IBOutlet weak var layoutBtn2: UIButton!
    @IBOutlet weak var layoutBtn3: UIButton!
    /// Layout photo view
    @IBOutlet weak var viewLandscape: UIView!
    /// App view
    @IBOutlet var mainView: UIView!
    /// Variables
    var button: UIButton?
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var translationTransform: CGAffineTransform!
    
    // MARK: - Main
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: Set up default layout configuration
        setUpDefaultLayoutConfiguration()
        // MARK: Check device orientation
        checkDeviceOrientation()
    }
    
    // MARK: - ACTIONS
    
    /// Add picture buttons
    @IBAction func addPictureBtn1(_ sender: UIButton) {
        self.button = sender
        presentUIImagePicker(sourceType: .photoLibrary)
    }
    
    @IBAction func addPictureBtn2(_ sender: UIButton) {
        self.button = sender
        presentUIImagePicker(sourceType: .photoLibrary)
    }
    
    @IBAction func addPictureBtn3(_ sender: UIButton) {
        self.button = sender
        presentUIImagePicker(sourceType: .photoLibrary)
    }
    
    @IBAction func addPictureBtn4(_ sender: UIButton) {
        self.button = sender
        presentUIImagePicker(sourceType: .photoLibrary)
    }
    
    /// Select layouts buttons
    @IBAction func layoutBtn1WasPressed(_ sender: UIButton) {
        setUpSelectedLayout(layout: sender)
    }
    
    @IBAction func layoutBtn2WasPressed(_ sender: UIButton) {
        setUpSelectedLayout(layout: sender)
    }
    
    @IBAction func layoutBtn3WasPressed(_ sender: UIButton) {
        setUpSelectedLayout(layout: sender)
    }
    
    /// Refresh button
    @IBAction func refreshBtnWasPressed(_ sender: UIButton) {
        cleanUpLayout()
    }
    
    /// Swipe left gesture
    @IBAction func swipeLeftForShare(_ sender: UIPanGestureRecognizer) {
        // MARK: Check if gesture speed is in the right direction == left
        let velocity = sender.velocity(in: mainView)
        if velocity.x < -screenWidth && sender.state == .ended {
            layoutIsReadyToShare()
        }
    }
    
    /// Swipe up gesture
    @IBAction func swipeUpForShare(_ sender: UIPanGestureRecognizer) {
        /// Check if gesture speed is in the right direction == up
        let velocity = sender.velocity(in: mainView)
        if velocity.y < -screenHeight && sender.state == .ended {
            layoutIsReadyToShare()
        }
    }
    
    // MARK: - HELPER METHODS
    
    /// Set up notification observer for device orientation
    @objc func checkDeviceOrientation(){
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(orientationChanged), name: UIDevice.orientationDidChangeNotification, object: nil)
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
    }
    
    /// Actions to do when device orientation changed
    @objc func orientationChanged() {
        setUpDefaultLayoutConfiguration()
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            screenWidth = UIScreen.main.bounds.width
            translationTransform = CGAffineTransform(translationX: -screenWidth, y: 0)
            let swipeLeftForShare = UIPanGestureRecognizer(target: self, action: #selector(swipeLeftForShare(_:)))
            self.mainView.addGestureRecognizer(swipeLeftForShare)
            
        case .portrait, .unknown:
            screenHeight = UIScreen.main.bounds.height
            translationTransform = CGAffineTransform(translationX: 0, y: -screenHeight)
            let swipeUpForShare = UIPanGestureRecognizer(target: self, action: #selector(swipeUpForShare(_:)))
            self.mainView.addGestureRecognizer(swipeUpForShare)
            
        default:
            return
        }
    }
    
    /// Clean up the layout
    private func cleanUpLayout(){
        [addPictureBtn1, addPictureBtn2, addPictureBtn3, addPictureBtn4].forEach { button in
            button?.setImage(UIImage(named: "Plus.png"), for: .normal)
        }
    }
    
    /// Set up default layout configuration
    private func setUpDefaultLayoutConfiguration() {
        layoutBtn1.imageView?.isHidden = false
        layoutBtn2.imageView?.isHidden = true
        layoutBtn3.imageView?.isHidden = true
        addPictureBtn2.isHidden = true
    }
    
    /// Update selected layout
    private func setUpSelectedLayout(layout: UIButton){
        layoutBtn1.imageView?.isHidden = layout !== layoutBtn1
        layoutBtn2.imageView?.isHidden = layout !== layoutBtn2
        layoutBtn3.imageView?.isHidden = layout !== layoutBtn3
        addPictureBtn2.isHidden = layout == layoutBtn1
        addPictureBtn4.isHidden = layout == layoutBtn2
    }
    
    /// Present UIImage Picker Controller
    private func presentUIImagePicker(sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        picker.modalPresentationStyle = .currentContext
        present(picker, animated: true, completion: nil)
    }
    
    /// Allow user to choose an image and set the layout
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let chosenImage = info[.originalImage] as? UIImage else {
            dismiss(animated: true, completion: nil)
            return
        }
        
        switch button?.tag {
        case 1:
            assignImageUploadToButton(button: addPictureBtn1, image: chosenImage)
        case 2:
            assignImageUploadToButton(button: addPictureBtn2, image: chosenImage)
        case 3:
            assignImageUploadToButton(button: addPictureBtn3, image: chosenImage)
        case 4:
            assignImageUploadToButton(button: addPictureBtn4, image: chosenImage)
        default:
            print("Error getting button name")
            return
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    /// Assign image uploaded to button image
    private func assignImageUploadToButton(button: UIButton, image: UIImage) {
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
    }
    
    /// Check if users respects conditions
    private func layoutIsReadyToShare() {
        // MARK: Conditions for allow user to share final picture montage
        let buttonsArray = [addPictureBtn1, addPictureBtn2, addPictureBtn3, addPictureBtn4]
        let layoutHave3Picture = buttonsArray.lastIndex(where: {$0?.currentImage != UIImage(named: "Plus.png")})
        let layoutIsFull = buttonsArray.allSatisfy({$0?.currentImage != UIImage(named: "Plus.png")})
        
        if (layoutHave3Picture == 2 && addPictureBtn4.isHidden == true) || (layoutHave3Picture == 3 && addPictureBtn2.isHidden == true) || layoutIsFull {
            prepareImage()
        } else {
            showAlertIsEmpty()
        }
    }
    
    /// Prepare image for sharing or saving
    private func prepareImage() {
        /// Transform layout into image
        let renderer = UIGraphicsImageRenderer(size: viewLandscape.bounds.size)
        let image = renderer.image { ctx in
            viewLandscape.drawHierarchy(in: viewLandscape.bounds, afterScreenUpdates: true)
        }
        UIView.animate(withDuration: 1, animations: {self.viewLandscape.transform = self.translationTransform}, completion: {(success) in
            if success {
                /// Share or save image controller
                let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
                vc.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
                self.present(vc, animated: true)
                vc.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, arrayReturnedItems: [Any]?, error: Error?) in
                    if !completed {
                        self.viewLandscape.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                        UIView.animate(withDuration: 1, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
                            self.viewLandscape.transform = .identity
                        })
                    }
                    
                    if let shareError = error {
                        print("error while sharing: \(shareError.localizedDescription)")
                    }
                }
            }
        })
        
    }
    
    /// Presenting an alert message if the user did not have at least 3 pictures uploaded in the layout
    private func showAlertIsEmpty(){
        let alertIsEmpty = UIAlertController(title: "Oups 😕", message: "It looks like you haven't added enough images to start sharing.", preferredStyle: UIAlertController.Style.alert)
        alertIsEmpty.addAction(UIAlertAction(title: "Ok got it !", style: .default))
        self.present(alertIsEmpty, animated: true, completion: nil)
    }
}

