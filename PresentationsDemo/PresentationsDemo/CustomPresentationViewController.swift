//
//  CustomPresentationViewController.swift
//  PresentationsDemo
//
//  Created by Joyce Echessa on 4/6/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

//http://www.appcoda.com/presentation-controllers-tutorial/ 
import UIKit

class CustomPresentationViewController: UIViewController {

    let exampleTransitionDelegate = ExampleTransitioningDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    @IBAction func infoButtonWasTapped(_ sender: UIButton)
    {
        //assigns ExampleTransitioningDelegate as the view controller’s transitioning delegate.
        transitioningDelegate = exampleTransitionDelegate
        //create an instance of ExampleViewController which will provide the content to display.
        let vc = ExampleViewController()
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = exampleTransitionDelegate
        
        //present this view controller.
        present(vc, animated: true, completion: nil)
    }
}
