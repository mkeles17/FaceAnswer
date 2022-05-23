//
//  CustomSegue.swift
//  FaceAnswer
//


import UIKit

class CustomSegue: UIStoryboardSegue {
    override func perform() {
        //UIViewController; *sourceViewController = (UIViewController*)[self,, sourceViewController];
        //UIViewController *destinationController = (UIViewController*)[self destinationViewController];
        //UINavigationController *navigationController = sourceViewController.navigationController;
        
        //NSMutableArray *controllerStack = [NSMutableArray arrayWithArray:navigationController.viewControllers];
        //[controllerStack replaceObjectAtIndex:[controllerStack indexOfObject:sourceViewController] withObject:destinationController];
        //[navigationController setViewControllers:controllerStack animated:YES];
        source.navigationController?.setViewControllers([destination], animated: true)
    }
}
