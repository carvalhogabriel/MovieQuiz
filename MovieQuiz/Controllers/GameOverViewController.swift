//
//  GameOverViewController.swift
//  MovieQuiz
//
//  Created by Gabriel Carvalho Guerrero on 25/03/19.
//  Copyright © 2019 Gabriel Carvalho Guerrero. All rights reserved.
//

import UIKit

class GameOverViewController: UIViewController {

    // MARK: - @IBOutlet's
    @IBOutlet weak var labelScore: UILabel!
    
    // MARK: - Var's
    var score: Int = 0
    
    // MARK: - @IBAction's
    @IBAction func playAgain(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        labelScore.text = "\(score)"
    }

}
