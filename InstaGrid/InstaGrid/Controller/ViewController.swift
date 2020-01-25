//
//  ViewController.swift
//  InstaGrid
//
//  Created by Yohan W. Dunon on 30/11/2019.
//  Copyright © 2019 Yohan W. Dunon. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Properties
    
    // MARK: - Add picture buttons outlets
    @IBOutlet weak var addPictureBtn1: UIButton!
    @IBOutlet weak var addPictureBtn2: UIButton!
    @IBOutlet weak var addPictureBtn3: UIButton!
    @IBOutlet weak var addPictureBtn4: UIButton!
    // MARK: Layout buttons outlets
    @IBOutlet weak var layoutBtn1: UIButton!
    @IBOutlet weak var layoutBtn2: UIButton!
    @IBOutlet weak var layoutBtn3: UIButton!
    // MARK: Layout photo view
    @IBOutlet weak var viewLandscape: UIView!
    // MARK: App view
    @IBOutlet var mainView: UIView!
    
    var button: UIButton?
    
    // MARK: - Main
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: Set up default layout configuration
        setUpDefaultLayoutConfiguration()
        // MARK: Check device orientation
        checkDeviceOrientation()
    }
    
    // MARK: - Actions
    
    // MARK: - Add picture buttons
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
    
    // MARK: Select layouts buttons
    @IBAction func layoutBtn1WasPressed(_ sender: UIButton) {
        setUpSelectedLayout(layout: sender)
    }
    
    @IBAction func layoutBtn2WasPressed(_ sender: UIButton) {
        setUpSelectedLayout(layout: sender)
    }
    
    @IBAction func layoutBtn3WasPressed(_ sender: UIButton) {
        setUpSelectedLayout(layout: sender)
    }
    
    // MARK: Refresh button
    @IBAction func refreshBtnWasPressed(_ sender: UIButton) {
        cleanUpLayout()
    }
    
    // MARK: Handle swipe gestures
    // TODO: Look for handle multi-gestures
    @IBAction func swipeLeftForShare(_ sender: UIPanGestureRecognizer) {
        if sender.state == .ended {
            prepareImage()
        }
    }
    
    @IBAction func swipeUpForShare(_ sender: UIPanGestureRecognizer) {
        if sender.state == .ended {
            prepareImage()
        }
    }
    
    // MARK: - Helper Methods
    // MARK: - Set up notifications obeserver for device orientation
    @objc func checkDeviceOrientation(){
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(orientationChanged), name: UIDevice.orientationDidChangeNotification, object: nil)
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
    }
    
    // MARK: Actions to do when device orientation changed
    @objc func orientationChanged() {
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            setUpDefaultLayoutConfiguration()
            let swipeLeftForShare = UIPanGestureRecognizer(target: self, action: #selector(self.swipeLeftForShare(_:)))
            self.mainView.addGestureRecognizer(swipeLeftForShare)
        case .portrait:
            setUpDefaultLayoutConfiguration()
            let swipeUpForShare = UIPanGestureRecognizer(target: self, action: #selector(self.swipeUpForShare(_:)))
            self.mainView.addGestureRecognizer(swipeUpForShare)
        default:
            return
        }
    }
    
    // MARK: Clean up the layout and properties
    private func cleanUpLayout(){
        for button in [ addPictureBtn1, addPictureBtn2, addPictureBtn3, addPictureBtn4] {
            button!.setImage(UIImage(named: "Plus.png"), for: .normal)
        }
    }
    
    // MARK: Set up default layout configuration
    private func setUpDefaultLayoutConfiguration() {
        layoutBtn1.imageView?.isHidden = false
        layoutBtn2.imageView?.isHidden = true
        layoutBtn3.imageView?.isHidden = true
        addPictureBtn2.isHidden = true
    }
    
    // MARK: Update selected layout methods.
    private func setUpSelectedLayout(layout: UIButton){
        layoutBtn1.imageView?.isHidden = layout !== layoutBtn1
        layoutBtn2.imageView?.isHidden = layout !== layoutBtn2
        layoutBtn3.imageView?.isHidden = layout !== layoutBtn3
        addPictureBtn1.isHidden = false
        addPictureBtn2.isHidden = layout == layoutBtn1
        addPictureBtn3.isHidden = false
        addPictureBtn4.isHidden = layout == layoutBtn2
    }
    
    // MARK: Present UIImage Picker Controller
    private func presentUIImagePicker(sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        picker.modalPresentationStyle = .currentContext
        present(picker, animated: true, completion: nil)
    }
    
    // MARK: Allow user to choose an image and set the layout
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
    
    // MARK: Assign image uploaded to button image
    private func assignImageUploadToButton(button: UIButton, image: UIImage) {
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
    }
    
    // MARK: Prepare image for sharing or saving
    private func prepareImage() {
        // MARK: Transform layout into image
        let renderer = UIGraphicsImageRenderer(size: viewLandscape.bounds.size)
        let image = renderer.image { ctx in
            viewLandscape.drawHierarchy(in: viewLandscape.bounds, afterScreenUpdates: true)
        }
        // MARK: Share or save image controller
        let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    // MARK: Sharing final image
    private func shareImage(image: UIImageView) {
        let items = [image]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: [])
        present(ac, animated: true)
    }
    
    // MARK: Action when the user canceled call to image picker
    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
