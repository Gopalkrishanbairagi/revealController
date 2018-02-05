//
//  Reveal_ViewController.swift
//  Raunka
//
//  Created by Gopal krishan on 30/01/18.
//  Copyright © 2018 Gopal krishan. All rights reserved.
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
    var frontController = UIViewController()
    var sideController = UIViewController()
    var sideMenuOpen = false
    
    let frontTopButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        xConstraint = sideView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -sideWidth)
        addController()
        
        NotificationCenter.default.addObserver(self, selector: #selector(toggle), name: NSNotification.Name(rawValue: "Toggle"), object: nil)
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "pushcontroller"), object: nil, queue: nil) { (data) in
            
            let vc = data.userInfo?["vc"] as! UIViewController
            
            (((self.frontController as? UINavigationController)?.topViewController as? UITabBarController)?.selectedViewController as? UINavigationController)?.pushViewController(vc, animated: true)

            
        }
        
                let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(panGesture:)))
                frontView.addGestureRecognizer(panGesture)
        
    }
    
    func addController(){
        
        // add side View
        
        sideView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sideView)
        sideView.backgroundColor = UIColor.clear
        NSLayoutConstraint.activate([
            xConstraint,
            sideView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            sideView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            sideView.widthAnchor.constraint(equalToConstant: sideWidth)
            ])
        
        // add Front View
        
        frontView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(frontView)
        frontView.backgroundColor = UIColor.clear
        NSLayoutConstraint.activate([
            frontView.leadingAnchor.constraint(equalTo: sideView.trailingAnchor),
            frontView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            frontView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            frontView.widthAnchor.constraint(equalToConstant: view.frame.width)
            ])
        frontView.layer.borderWidth = 1
        frontView.layer.borderColor = UIColor.lightGray.cgColor
        // add Side view controller view to Side View
        
        sideController = storyboard!.instantiateViewController(withIdentifier: sideIdentifier)
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
        
        frontController = storyboard!.instantiateViewController(withIdentifier: frontIdentifier)
        addChildViewController(frontController)
        frontController.view.translatesAutoresizingMaskIntoConstraints = false
        frontView.addSubview(frontController.view)
        NSLayoutConstraint.activate([
            frontController.view.leadingAnchor.constraint(equalTo: frontView.leadingAnchor),
            frontController.view.trailingAnchor.constraint(equalTo: frontView.trailingAnchor),
            frontController.view.topAnchor.constraint(equalTo: frontView.topAnchor),
            frontController.view.bottomAnchor.constraint(equalTo: frontView.bottomAnchor)
            ])
        
        addfrontButton()
        
    }
    
    @objc func toggle(){
        
        if sideMenuOpen{
            xConstraint.constant = -sideWidth
            sideMenuOpen = false
            frontTopButton.isHidden = true
            
        }else{
            sideController.viewWillAppear(false)
            xConstraint.constant = 0
            sideMenuOpen = true
            frontTopButton.isHidden = false
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func addfrontButton(){
        
        frontTopButton.addTarget(self, action: #selector(toggle), for: .touchUpInside)
        frontTopButton.isHidden = true
        frontTopButton.backgroundColor = UIColor.clear
        frontTopButton.translatesAutoresizingMaskIntoConstraints = false
        frontController.view.addSubview(frontTopButton)
        frontTopButton.backgroundColor = UIColor.clear
        NSLayoutConstraint.activate([
            frontTopButton.leadingAnchor.constraint(equalTo: frontView.leadingAnchor),
            frontTopButton.topAnchor.constraint(equalTo: frontView.topAnchor, constant: 0),
            frontTopButton.bottomAnchor.constraint(equalTo: frontView.bottomAnchor, constant: 0),
            frontTopButton.widthAnchor.constraint(equalTo: frontView.widthAnchor)
            ])
    }

    @objc func handlePanGesture(panGesture: UIPanGestureRecognizer) {
        
        let translation = panGesture.translation(in: view)
        
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

                sideController.viewWillAppear(false)
                xConstraint.constant = -sideWidth
                sideMenuOpen = false
                
            }
        }
        
        self.view.layoutIfNeeded()
        panGesture.setTranslation(CGPoint.zero, in: view)
    }
}
