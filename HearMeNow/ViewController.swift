//
//  ViewController.swift
//  HearMeNow
//
//  Created by NIE on 19/10/15.
//  Copyright (c) 2015 NIE. All rights reserved.
//  This is one of the View Controllers

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    
    var hasRecording = false
    var soundPlayer : AVAudioPlayer?
    var soundRecorder : AVAudioRecorder?
    var session : AVAudioSession?
    var soundPath : String?

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    
    @IBAction func recordPressed(sender: AnyObject) {
        if (soundRecorder?.recording == true)
        {
            soundRecorder?.stop()
            recordButton.setTitle("Record", forState: UIControlState.Normal)
            hasRecording = true
        }
        else
        {
            session?.requestRecordPermission(){
                granted in
                if (granted == true)
                {
                    self.soundRecorder?.record()
                    self.recordButton.setTitle("Stop", forState: UIControlState.Normal)
                }
                else
                {
                    println("Unable to record")
                }
            }
        }
    }
    
    @IBAction func playPressed(sender: AnyObject) {
        
        if (soundPlayer?.playing == true)
        {
            soundPlayer?.pause()
            playButton.setTitle("Play", forState: UIControlState.Normal)
           
        }
        else if (hasRecording == true)
        {
            let url = NSURL(fileURLWithPath: soundPath!)
            var error : NSError?
            
            soundPlayer = AVAudioPlayer(contentsOfURL: url, error: &error)
            
            if(error == nil)
            {
 
                soundPlayer?.delegate = self
                soundPlayer?.enableRate = true
                soundPlayer?.rate = 0.5
                soundPlayer?.play()
            }
            else
            {
                println("Error initializing the player: \(error)")
            }
        
            playButton.setTitle("Pause", forState: UIControlState.Normal)
            hasRecording = false
            
        }
        else if (soundPlayer != nil)
        {
            soundPlayer?.play()
            playButton.setTitle("Pause", forState: UIControlState.Normal)
        }
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        recordButton.setTitle("RECORD", forState: UIControlState.Normal)
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        playButton.setTitle("Play", forState: UIControlState.Normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        soundPath = "\(NSTemporaryDirectory())hearmenow.wav"
        
        let url = NSURL(fileURLWithPath: soundPath!)
        
        session = AVAudioSession.sharedInstance()
        session?.setActive(true, error: nil)
        
        var error : NSError?
        
        session?.setCategory(AVAudioSessionCategoryPlayAndRecord, error: &error)
        
        soundRecorder = AVAudioRecorder(URL:url, settings: nil, error: &error)
        
        if(error != nil)
        {
            println("Error initializing the recorder: \(error)")
        }
        
        soundRecorder?.delegate = self
        soundRecorder?.prepareToRecord()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

