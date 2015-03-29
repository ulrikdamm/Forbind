//
//  ChainedAnimationsDemoViewController.swift
//  Forbind
//
//  Created by Ulrik Damm on 29/03/15.
//
//

import Foundation
import UIKit
import Forbind
import ForbindExtensions

class ChainedAnimationsDemoViewController : UIViewController {
	@IBOutlet var box : UIView?
	
	@IBAction func performAnimations() {
		let x = CGFloat(arc4random_uniform(UInt32(view.bounds.size.width)))
		let y = CGFloat(arc4random_uniform(UInt32(view.bounds.size.width)))
		
		UIView.animate(0.3) { self.box?.backgroundColor = .blackColor() }
			=> { UIView.animate(0.3) { self.box?.layer.position = CGPoint(x: x, y: y) } }
			=> { UIView.animate(0.3) { self.box?.backgroundColor = .whiteColor() } }
	}
}
