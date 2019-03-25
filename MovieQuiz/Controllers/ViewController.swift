//
//  ViewController.swift
//  MovieQuiz
//
//  Created by Gabriel Carvalho Guerrero on 25/03/19.
//  Copyright © 2019 Gabriel Carvalho Guerrero. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    // MARK: - @IBOutlet's
    @IBOutlet weak var viewSoundBar: UIView!
    @IBOutlet weak var sliderMusic: UISlider!
    @IBOutlet var buttonOptions: [UIButton]!
    @IBOutlet weak var imageViewQuiz: UIImageView!
    @IBOutlet weak var viewTimer: UIView!
    
    // MARK: - Var's
    var quizManager: QuizManager!
    var quizPlayer: AVAudioPlayer!
    var playerItem: AVPlayerItem!
    var backgroundMusicPlayer: AVPlayer!
    
    // MARK: - @IBAction's
    @IBAction func showHideSoundBar(_ sender: UIButton) {
        viewSoundBar.isHidden = !viewSoundBar.isHidden
    }
    
    @IBAction func changeMusicStatus(_ sender: UIButton) {
        if backgroundMusicPlayer.timeControlStatus == .paused {
            backgroundMusicPlayer.play()
            sender.setImage(UIImage(named: "pause"), for: .normal)
        } else {
            backgroundMusicPlayer.pause()
            sender.setImage(UIImage(named: "play"), for: .normal)
        }
    }
    
    @IBAction func changeMusicTime(_ sender: UISlider) {
        backgroundMusicPlayer.seek(to: CMTime(seconds: Double(sender.value) * playerItem.duration.seconds, preferredTimescale: 1))
    }
    
    @IBAction func checkAnswer(_ sender: UIButton) {
        quizManager.checkAnswer(sender.title(for: .normal)!)
        getNewQuiz()
        startTimer()
    }
    
    @IBAction func playQuiz() {
        guard let round = quizManager.round else {return}
        imageViewQuiz.image = UIImage(named: "movieSound")
        if let url = Bundle.main.url(forResource: "quote\(round.quiz.number)", withExtension: ".mp3") {
            do {
                quizPlayer = try AVAudioPlayer(contentsOf: url)
                quizPlayer.volume = 1
                quizPlayer.delegate = self
                quizPlayer.play()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Private Method's
    private func getNewQuiz() {
        let round = quizManager.generateRandomQuiz()
        for i in 0..<round.options.count {
            buttonOptions[i].setTitle(round.options[i].name, for: .normal)
        }
        playQuiz()
    }
    
    private func startTimer() {
        viewTimer.frame = view.frame
        UIView.animate(withDuration: 60.0, delay: 0.0, options: .curveLinear, animations: {
            self.viewTimer.frame.size.width = 0
            self.viewTimer.frame.origin.x = self.view.center.x
        }) { (success) in
            self.gameOver()
        }
    }
    
    private func gameOver() {
        performSegue(withIdentifier: "gameOverSegue", sender: nil)
        quizPlayer.stop()
    }

    private func playBackgroundMusic() {
        let musicURL = Bundle.main.url(forResource: "MarchaImperial", withExtension: ".mp3")!
//        let musicURL = URL(string: "https://goo.gl/HJwvyZ")!
        playerItem = AVPlayerItem(url: musicURL)
        backgroundMusicPlayer = AVPlayer(playerItem: playerItem)
        backgroundMusicPlayer.volume = 0.1
        backgroundMusicPlayer.play()
        backgroundMusicPlayer.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: nil) { (time) in
            let percent = time.seconds / self.playerItem.duration.seconds
            self.sliderMusic.setValue(Float(percent), animated: true)
        }
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        playBackgroundMusic()
        viewSoundBar.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        quizManager = QuizManager()
        getNewQuiz()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! GameOverViewController
        vc.score = quizManager.score
    }
}

extension ViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        imageViewQuiz.image = UIImage(named: "movieSoundPause")
    }
}
