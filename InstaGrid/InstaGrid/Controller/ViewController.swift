//
//  ViewController.swift
//  InstaGrid
//
//  Created by Yohan W. Dunon on 30/11/2019.
//  Copyright © 2019 Yohan W. Dunon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: Outlets
    // MARK: portrait buttons outlet
    @IBOutlet weak var addPictureBtn1: UIButton!
    @IBOutlet weak var addPictureBtn2: UIButton!
    @IBOutlet weak var addPictureBtn3: UIButton!
    @IBOutlet weak var addPictureBtn4: UIButton!
    // MARK: landscqpe buttons outlet
    @IBOutlet weak var addPictureBtn1L: UIButton!
    @IBOutlet weak var addPictureBtn2L: UIButton!
    @IBOutlet weak var addPictureBtn3L: UIButton!
    @IBOutlet weak var addPictureBtn4L: UIButton!
    // MARK: layout buttons outlet
    @IBOutlet weak var layoutBtn1: UIButton!
    @IBOutlet weak var layoutBtn2: UIButton!
    @IBOutlet weak var layoutBtn3: UIButton!
    // MARK: view orientation outlet
    @IBOutlet weak var viewLandscape: UIView!
    @IBOutlet weak var viewPortrait: UIView!
    // MARK: view outlet
    @IBOutlet var mainView: UIView!
    
    // MARK: Properties
    var buttonName: String!
    var picture2: UIImage!
    var picture2isSet: Bool! = false
    var picture2L: UIImage!
    var picture2LisSet: Bool! = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: Check device orientation
        // TODO: Check when it's triggereddevice orientation
        setUpDefaultLayoutConfiguration()
        checkDeviceOrientation()
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { context in
            // TODO: Check device orientation
            // TODO: Check when it's triggereddevice orientation
            // self.checkDeviceOrientation()
        })
    }
    
    // MARK: - Actions
    // MARK: - portrait add picture buttons
    @IBAction func addPictureBtn1WasPressed(_ sender: UIButton) {
        self.buttonName = "button1"
        presentUIImagePicker(sourceType: .photoLibrary)
    }
    
    @IBAction func addPictureBtn2WasPressed(_ sender: UIButton) {
        self.buttonName = "button2"
        presentUIImagePicker(sourceType: .photoLibrary)
    }
    
    @IBAction func addPictureBtn3WasPressed(_ sender: UIButton) {
        self.buttonName = "button3"
        presentUIImagePicker(sourceType: .photoLibrary)
    }
    
    @IBAction func addPictureBtn4WasPressed(_ sender: UIButton) {
        self.buttonName = "button4"
        presentUIImagePicker(sourceType: .photoLibrary)
    }
    
    // MARK: - landscape add picture buttons
    @IBAction func addPictureBtn1LWasPressed(_ sender: UIButton) {
        self.buttonName = "button1L"
        presentUIImagePicker(sourceType: .photoLibrary)
    }
    
    @IBAction func addPictureBtn2LWasPressed(_ sender: UIButton) {
        self.buttonName = "button2L"
        presentUIImagePicker(sourceType: .photoLibrary)
    }
    
    @IBAction func addPictureBtn3LWasPressed(_ sender: UIButton) {
        self.buttonName = "button3L"
        presentUIImagePicker(sourceType: .photoLibrary)
    }
    
    @IBAction func addPictureBtn4LWasPressed(_ sender: UIButton) {
        self.buttonName = "button4L"
        presentUIImagePicker(sourceType: .photoLibrary)
    }
    
    // MARK: - Select layouts buttons
    @IBAction func layoutBtn1WasPressed(_ sender: UIButton) {
        print("layout1")
        setUpSelectedLayout(layout: sender)
    }
    
    @IBAction func layoutBtn2WasPressed(_ sender: UIButton) {
        print("layout2")
        setUpSelectedLayout(layout: sender)
    }
    
    @IBAction func layoutBtn3WasPressed(_ sender: UIButton) {
        print("layout3")
        setUpSelectedLayout(layout: sender)
    }
    
    // MARK: - Refresh button
    @IBAction func refreshBtnWasPressed(_ sender: UIButton) {
        cleanUpLayout()
    }
    
    // MARK: - Swipe gestures
    @IBAction func swipeLeftForShare(_ sender: UIPanGestureRecognizer) {
        print("swipeLeftForShare")
        if sender.state == .ended {
            // Perform action.
            print("gesture finished")
            let renderer = UIGraphicsImageRenderer(size: viewLandscape.bounds.size)
            let image = renderer.image { ctx in
                viewLandscape.drawHierarchy(in: viewLandscape.bounds, afterScreenUpdates: true)
            }
            
            let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
            vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
            present(vc, animated: true)
        }
        
    }
    
    @IBAction func swipeUpForShare(_ sender: UIPanGestureRecognizer) {
        print("swipeUpForShare")
        if sender.state == .ended {
            // Perform action.
            print("gesture finished")
            let renderer = UIGraphicsImageRenderer(size: viewPortrait.bounds.size)
            let image = renderer.image { ctx in
                viewPortrait.drawHierarchy(in: viewPortrait.bounds, afterScreenUpdates: true)
            }
            
            let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
            vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
            present(vc, animated: true)
        }
    }
    
    
    // MARK: - Helper Methods
    
    // MARK: set up notifications obeserver for device orientation
    @objc func checkDeviceOrientation(){
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(orientationChanged), name: UIDevice.orientationDidChangeNotification, object: nil)
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
    }
    
    // MARK: actions to do when device orientation changed
    // TODO: improve this block of code
    @objc func orientationChanged() {
        // FIXME: configure app for all device orientations
        switch UIDevice.current.orientation {
        case .unknown:
            // FIXME: what to do when oriention is unknown ?
            print("Device did rotate and orientation changed to: unknown", UIDevice.current.orientation.rawValue)
        case .faceDown:
            // FIXME: not use device orientation face down
            print("Device did rotate and orientation changed to: faceDown", UIDevice.current.orientation.rawValue)
        case .faceUp:
            // FIXME: default orientation face up
            print("Device did rotate and orientation changed to: faceUp", UIDevice.current.orientation.rawValue)
        case .landscapeLeft, .landscapeRight:
            // FIXME: print twice device orientation
            print("Device did rotate and orientation changed to: landscape")
            setUpDefaultLayoutConfiguration()
            let swipeLeftForShare = UIPanGestureRecognizer(target: self, action: #selector(self.swipeLeftForShare(_:)))
            self.mainView.addGestureRecognizer(swipeLeftForShare)
        case .portrait, .portraitUpsideDown:
            // FIXME: print twice device orientation
            print("Device did rotate and orientation changed to: portrait")
            setUpDefaultLayoutConfiguration()
            let swipeUpForShare = UIPanGestureRecognizer(target: self, action: #selector(self.swipeUpForShare(_:)))
            self.mainView.addGestureRecognizer(swipeUpForShare)
        default:
            return
        }
    }
    
    // MARK: clean up the layout and properties
    private func cleanUpLayout(){
        buttonName = ""
        picture2 = nil
        picture2isSet = false
        picture2L = nil
        picture2LisSet = false
        let buttonsArray = [addPictureBtn1, addPictureBtn2, addPictureBtn3, addPictureBtn4, addPictureBtn1L, addPictureBtn2L, addPictureBtn3L, addPictureBtn4L]
        for button in buttonsArray {
            button!.setImage(UIImage(named: "Plus.png"), for: .normal)
        }
    }
    
    
    // MARK: Set up default layout configuration
    private func setUpDefaultLayoutConfiguration() {
        layoutBtn1.imageView!.isHidden = false
        layoutBtn2.imageView!.isHidden = true
        layoutBtn3.imageView!.isHidden = true
        addPictureBtn2.isHidden = true
        addPictureBtn2L.isHidden = true
    }
    
    // MARK: Update selected layout methods.
    // TODO: need to reduce this block of code
    private func setUpSelectedLayout(layout: UIButton){
        switch layout {
        case layoutBtn1:
            // MARK: layout buttons
            layoutBtn1.imageView?.isHidden = false
            layoutBtn2.imageView?.isHidden = true
            layoutBtn3.imageView?.isHidden = true
            // MARK: portrait buttons
            addPictureBtn1.isHidden = false
            addPictureBtn2.isHidden = true
            addPictureBtn3.isHidden = false
            addPictureBtn4.isHidden = false
            // MARK: landscape buttons
            addPictureBtn1L.isHidden = false
            addPictureBtn2L.isHidden = true
            addPictureBtn3L.isHidden = false
            addPictureBtn4L.isHidden = false
        case layoutBtn2:
            // MARK: layout buttons
            layoutBtn1.imageView?.isHidden = true
            layoutBtn2.imageView?.isHidden = false
            layoutBtn3.imageView?.isHidden = true
            // MARK: portrait buttons
            addPictureBtn1.isHidden = false
            addPictureBtn2.isHidden = false
            addPictureBtn3.isHidden = false
            addPictureBtn4.isHidden = true
            // MARK: landscape buttons
            addPictureBtn1L.isHidden = false
            addPictureBtn2L.isHidden = false
            addPictureBtn3L.isHidden = false
            addPictureBtn4L.isHidden = true
            // MARK: check if image 2 is already uploaded
            if picture2isSet {
                // MARK: assign uploaded image to button
                assignImageUploadToButton(button: addPictureBtn2, image: picture2)
            } else {
                // MARK: assign image 4 to button
                addPictureBtn2.setImage(addPictureBtn4.currentImage, for: .normal)
            }
        case layoutBtn3:
            // MARK: layout buttons
            layoutBtn1.imageView?.isHidden = true
            layoutBtn2.imageView?.isHidden = true
            layoutBtn3.imageView?.isHidden = false
            // MARK: portrait buttons
            addPictureBtn1.isHidden = false
            addPictureBtn2.isHidden = false
            addPictureBtn3.isHidden = false
            addPictureBtn4.isHidden = false
            // MARK: landscape buttons
            addPictureBtn1L.isHidden = false
            addPictureBtn2L.isHidden = false
            addPictureBtn3L.isHidden = false
            addPictureBtn4L.isHidden = false
            // MARK: check if image 2 already uploaded and set image to button
            if picture2isSet {
                // MARK: assign uploaded image to button
                assignImageUploadToButton(button: addPictureBtn2, image: picture2)
            } else {
                // MARK: assign default button image
                addPictureBtn2.setImage(UIImage(named: "Plus.png"), for: .normal)
            }
        default:
            return
        }
    }
    
    // MARK: present UIImage Picker Controller
    private func presentUIImagePicker(sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        picker.modalPresentationStyle = .currentContext
        present(picker, animated: true, completion: nil)
    }
    
    // MARK: sharing layout
    private func shareImage(image: UIImageView) {
        let items = [image]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: [])
        present(ac, animated: true)
    }
    
    // MARK: assign image uploaded to button image
    private func assignImageUploadToButton(button: UIButton, image: UIImage) {
        // MARK: check if image 2 is already uploaded
        if buttonName == "button2" || buttonName == "button2L" {
            picture2 = image
            picture2isSet = true
            picture2L = image
            picture2LisSet = true
        }
        // MARK: assign uploaded image to button
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
    }
}

// MARK: - UIImagePickerControllerDelegate and UINavigationControllerDelegate extension
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let chosenImage = info[.originalImage] as? UIImage else {
            dismiss(animated: true, completion: nil)
            return
        }
        
        // MARK: upload image and set layout
        switch true {
        case buttonName == "button1", buttonName == "button1L":
            print(buttonName ?? "error getting button name")
            assignImageUploadToButton(button: addPictureBtn1, image: chosenImage)
            assignImageUploadToButton(button: addPictureBtn1L, image: chosenImage)
        case buttonName == "button2", buttonName == "button2L":
            print(buttonName ?? "error getting button name")
            assignImageUploadToButton(button: addPictureBtn2, image: chosenImage)
            assignImageUploadToButton(button: addPictureBtn2L, image: chosenImage)
        case buttonName == "button3", buttonName == "button3L":
            print(buttonName ?? "error getting button name")
            assignImageUploadToButton(button: addPictureBtn3, image: chosenImage)
            assignImageUploadToButton(button: addPictureBtn3L, image: chosenImage)
        case buttonName == "button4", buttonName == "button4L":
            print(buttonName ?? "error getting button name")
            assignImageUploadToButton(button: addPictureBtn4, image: chosenImage)
            assignImageUploadToButton(button: addPictureBtn4L, image: chosenImage)
        default:
            print(buttonName ?? "error getting button name")
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UIImage change size extension
extension UIImage {
    func changeImageSize(_ width: CGFloat, height: CGFloat, opaque: Bool) -> UIImage {
        var newImage: UIImage
        
        let size = self.size
        
        print("Here size:", size)
        
        let renderFormat = UIGraphicsImageRendererFormat.default()
        renderFormat.opaque = opaque
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height), format: renderFormat)
        newImage = renderer.image {
            (context) in
            self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        }
        print("here new image bounds :", newImage.size)
        return newImage
    }
}
