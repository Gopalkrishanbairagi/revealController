//
//  Reveal_ViewController.swift
//  PromaticsSW
//
//  Created by promatics on 12/27/17.
//  Copyright © 2017 promatics. All rights reserved.
//

import UIKit

class Reveal_ViewController: UIViewController {
    
    @IBInspectable
    open var sideIdentifier:String = "Enter Side Identity" {
        didSet {
           
        }
    }
    @IBInspectable
    open var frontIdentifier:String = "Enter front Identity"{
        didSet {
            
        }
    }
    @IBInspectable
    open var sideWidth:CGFloat = 240 {
        didSet {
            
        }
    }

    
    let sideView = UIView()
    let frontView = UIView()
    private var xConstraint: NSLayoutConstraint!
    var sideMenuOpen = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        xConstraint = sideView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -sideWidth)
        addController()
        
        NotificationCenter.default.addObserver(self, selector: #selector(toggle), name: NSNotification.Name(rawValue: "Toggle"), object: nil)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(panGesture:)))
        frontView.addGestureRecognizer(panGesture)
    }
    
    func addController(){
        
        // add side View
        
        sideView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sideView)
        NSLayoutConstraint.activate([
            xConstraint,
            sideView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            sideView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            sideView.widthAnchor.constraint(equalToConstant: sideWidth)
            ])
        
        // add Front View
        
        frontView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(frontView)
        NSLayoutConstraint.activate([
            frontView.leadingAnchor.constraint(equalTo: sideView.trailingAnchor),
            frontView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            frontView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            frontView.widthAnchor.constraint(equalToConstant: view.frame.width)
            ])
        frontView.layer.borderWidth = 1
        frontView.layer.borderColor = UIColor.lightGray.cgColor
        // add Side view controller view to Side View
        
        let sideController = storyboard!.instantiateViewController(withIdentifier: sideIdentifier)
        addChildViewController(sideController)
        sideController.view.translatesAutoresizingMaskIntoConstraints = false
        sideView.addSubview(sideController.view)
        
        NSLayoutConstraint.activate([
            sideController.view.leadingAnchor.constraint(equalTo: sideView.leadingAnchor),
            sideController.view.trailingAnchor.constraint(equalTo: sideView.trailingAnchor),
            sideController.view.topAnchor.constraint(equalTo: sideView.topAnchor),
            sideController.view.bottomAnchor.constraint(equalTo: sideView.bottomAnchor)
            ])
        
        sideController.didMove(toParentViewController: self)
        
        // add front View controller to front View
        
        let frontController = storyboard!.instantiateViewController(withIdentifier: frontIdentifier)
        addChildViewController(frontController)
        frontController.view.translatesAutoresizingMaskIntoConstraints = false
        frontView.addSubview(frontController.view)
        NSLayoutConstraint.activate([
            frontController.view.leadingAnchor.constraint(equalTo: frontView.leadingAnchor),
            frontController.view.trailingAnchor.constraint(equalTo: frontView.trailingAnchor),
            frontController.view.topAnchor.constraint(equalTo: frontView.topAnchor),
            frontController.view.bottomAnchor.constraint(equalTo: frontView.bottomAnchor)
            ])
        
    }
    
    func toggle(){
        
        if sideMenuOpen{
            xConstraint.constant = -sideWidth
            sideMenuOpen = false
            
            
        }else{
            xConstraint.constant = 0
            sideMenuOpen = true
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func handlePanGesture(panGesture: UIPanGestureRecognizer) {
        
        let translation = panGesture.translation(in: view)
        
        print(translation)
      
        if panGesture.state == .began || panGesture.state == .changed {
            
            if xConstraint.constant >= -sideWidth && xConstraint.constant <= 0{
                
                xConstraint.constant += translation.x
            }
        }
        
        if panGesture.state == UIGestureRecognizerState.ended {
            if xConstraint.constant > -sideWidth/2{
                
                xConstraint.constant = 0
                sideMenuOpen = true
            }else{
                
                xConstraint.constant = -sideWidth
                sideMenuOpen = false
            }
        }
        
        self.view.layoutIfNeeded()
        panGesture.setTranslation(CGPoint.zero, in: view)
    }
}
