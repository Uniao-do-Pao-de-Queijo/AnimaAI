

import UIKit
import Lottie

class SplashViewController: UIViewController {
    
    @IBOutlet weak var leftAnimation: LottieAnimationView!
    @IBOutlet weak var rightAnimation: LottieAnimationView!
    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
    
    override func viewDidLoad() {
      super.viewDidLoad()
        leftAnimation.contentMode = .scaleAspectFit
        leftAnimation.loopMode = .loop
        leftAnimation.animationSpeed = 0.5
        leftAnimation.play()
        
        rightAnimation.contentMode = .scaleAspectFit
        rightAnimation.loopMode = .loop
        rightAnimation.animationSpeed = 0.5
        rightAnimation.play()
    }
     
     
}

