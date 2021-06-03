
//  ViewController.swift
//  BasicSample-Swift
//
//  Created by Eliza Sapir on 12/04/2017.
//  Copyright © 2017 Kaltura. All rights reserved.
//

import UIKit
import PlayKit

/*
 This sample will show you how to create a player with basic functionality.
 The steps required:
 1. Load player with plugin config (only if has plugins).
 2. Register player events.
 3. Prepare Player.
 */

class ViewController: UIViewController {
    var player: Player! // Created in viewDidLoad
    @IBOutlet weak var playerContainer: PlayerView!
    @IBOutlet weak var playheadSlider: UISlider!
    
    @IBOutlet weak var visualSeekingView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.playheadSlider.isContinuous = false;
        
        // 1. Load the player
        player = PlayKitManager.shared.loadPlayer(pluginConfig: nil)
        // 2. Register events if have ones.
        // Event registeration must be after loading the player successfully to make sure events are added,
        // and before prepare to make sure no events are missed (when calling prepare player starts buffering and sending events)
        player.addObserver(self, event: PlayerEvent.playheadUpdate, block: { (event) in
            if let playerEvent = event as? PlayerEvent, let currentTime = playerEvent.currentTime {
                //print("Current Time: \(currentTime)")
                
                if self.didStartSeeking == false {
                    self.playheadSlider.value = Float(self.player.currentTime / self.player.duration)
                }
            }
        })
        
        player.addObserver(self, event: PlayerEvent.videoTrackChanged) { (event) in
            if let playerEvent = event as? PlayerEvent, let bitrate = playerEvent.bitrate {
                print("Bitrate: \(bitrate.intValue)")
            }
        }
        
        
        
        // 3. Prepare the player (can be called at a later stage, preparing starts buffering the video)
        self.preparePlayer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
/************************/
// MARK: - Player Setup
/***********************/
    func preparePlayer() {
        // setup the player's view
        self.player?.view = self.playerContainer
        
        let contentURL = "https://devstreaming-cdn.apple.com/videos/wwdc/2018/103zvtnsrnrijr/103/hls_vod_mvp.m3u8"
//        let contentURL = "https://01-ucd01-3201-staging.tv.cetin.cz/bpk-vod/vod/output2/MV-HBO_200824_M115908/MV-HBO_200824_M115908/index.m3u8?accountId=3201&deviceType=1&subscriptionType=0&ip=91.197.170.68&primaryToken=f761ff024c0598be_df16e2d79c5973a94f2515f22ab3b159"
        
//        let contentURL = "https://d3rlna7iyyu8wu.cloudfront.net/skip_armstrong/skip_armstrong_multi_language_subs.m3u8"
//        let contentURL = "https://cdnapisec.kaltura.com/p/2215841/playManifest/entryId/1_w9zx2eti/format/applehttp/protocol/https/a.m3u8"
//        let contentURL = "https://01-ucd01-3201-staging.tv.cetin.cz/bpk-tv/africke_nebe_hd_1005/output3/index.m3u8?accountId=3200&deviceType=32&subscriptionType=34111&ip=91.197.170.68&primaryToken=550be126549bdab0_258af9de66247a379c30498ebb25cbe8"
        // create media source and initialize a media entry with that source
        let entryId = "sintel"
        
        let drmData = FairPlayDRMParams(licenseUri: "https://udrmv3.kaltura.com/fps/license?custom_data=eyJhY2NvdW50X2lkIjoiMzIwMSIsImNvbnRlbnRfaWQiOiJNVi1IQk9fMjAwODI0X00xMTU5MDgiLCJjYV9zeXN0ZW0iOiJodHRwczovLzMyMDEuZnJzMS5vdHQua2FsdHVyYS5jb20vYXBpX3YzL3NlcnZpY2UvYXNzZXRGaWxlL2FjdGlvbi9nZXRDb250ZXh0P2tzPWRqSjhNekl3TVh5TDVmQzFPM2hqaENPT3VwdXNUaU1DQ3NTNWI4ZHE4RzEyTU9ISVBJbWQ2S1lnV1dubDZnVFZscXAxUjZ4MFMyNlFSX3FDYXpwZVV2Z2dsS1lvU2c0U3pmSWlsOXdDS1dUc2o2MWF2VTNFU0FIY2U5V3IzWkQzVjNHaENQNWVILUZYNFo0Skl4UnN5UU91YjJtbTVkVjYtN3BXczg2UWVFa0MxQzlCWjRVWnhSOWozdFF4a3hwbWZlajB6dFFYYTU5WnNCS09KLWo5dnZIODUxcHAtUzNwLUh0dHRlUW5ZTERIM0l5SUhxSnVCTmVRa2hBa1psdXRIZm84RGJhM3lUbi1jb2F6RmxoU051cVpoQV9aSjJGN0NFTXdXUnp1OFpXS0IyNUNlNklieURXLWRqVUVwN1ZIMTB6MXVLeHZ5OUlpRUdOa0c0QnlDV3JIY1o0XzRWVkVrbklQR3h4d3ZMMHNjWTFSS0tKVkp3PT0mY29udGV4dFR5cGU9bm9uZSZpZD0xNzgzMDAwMiIsImZpbGVzIjoiIiwidXNlcl90b2tlbiI6ImRqSjhNekl3TVh5TDVmQzFPM2hqaENPT3VwdXNUaU1DQ3NTNWI4ZHE4RzEyTU9ISVBJbWQ2S1lnV1dubDZnVFZscXAxUjZ4MFMyNlFSX3FDYXpwZVV2Z2dsS1lvU2c0U3pmSWlsOXdDS1dUc2o2MWF2VTNFU0FIY2U5V3IzWkQzVjNHaENQNWVILUZYNFo0Skl4UnN5UU91YjJtbTVkVjYtN3BXczg2UWVFa0MxQzlCWjRVWnhSOWozdFF4a3hwbWZlajB6dFFYYTU5WnNCS09KLWo5dnZIODUxcHAtUzNwLUh0dHRlUW5ZTERIM0l5SUhxSnVCTmVRa2hBa1psdXRIZm84RGJhM3lUbi1jb2F6RmxoU051cVpoQV9aSjJGN0NFTXdXUnp1OFpXS0IyNUNlNklieURXLWRqVUVwN1ZIMTB6MXVLeHZ5OUlpRUdOa0c0QnlDV3JIY1o0XzRWVkVrbklQR3h4d3ZMMHNjWTFSS0tKVkp3PT0iLCJhZGRpdGlvbmFsX2Nhc19zeXN0ZW0iOiIzMjAxIiwidWRpZCI6IjQxNjgyNjcifQ%3d%3d&signature=UWZ7fPYLM3pMzC5djqsn0H%2brqu8%3d",
                                        base64EncodedCertificate: "MIIE2DCCA8CgAwIBAgIIe+m5FYw0/X8wDQYJKoZIhvcNAQEFBQAwfzELMAkGA1UEBhMCVVMxEzARBgNVBAoMCkFwcGxlIEluYy4xJjAkBgNVBAsMHUFwcGxlIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MTMwMQYDVQQDDCpBcHBsZSBLZXkgU2VydmljZXMgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkwHhcNMTkwNTA3MDkyNTQzWhcNMjEwNTA3MDkyNTQzWjB4MQswCQYDVQQGEwJDWjEfMB0GA1UECgwWTzIgQ3plY2ggUmVwdWJsaWMgYS5zLjETMBEGA1UECwwKTVRBMzYyRzlHNjEzMDEGA1UEAwwqRmFpclBsYXkgU3RyZWFtaW5nOiBPMiBDemVjaCBSZXB1YmxpYyBhLnMuMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDMF2c2Sa/DzXYzUBHVRIUzevf89EH9O82am1xBH1U7U+f/kP2ENMmM9u4F89Dz6z4cockgEx5Rlx0UiUeomerNVApqKWFdRAgAqBh38Yltz6+lgVpId1GAQLb9n+TxT5p3JPlc/fyVJkaTLTqLUXmCqaqs9iA6iPFnG41IDywctwIDAQABo4IB4TCCAd0wDAYDVR0TAQH/BAIwADAfBgNVHSMEGDAWgBRj5EdUy4VxWUYsg6zMRDFkZwMsvjCB4gYDVR0gBIHaMIHXMIHUBgkqhkiG92NkBQEwgcYwgcMGCCsGAQUFBwICMIG2DIGzUmVsaWFuY2Ugb24gdGhpcyBjZXJ0aWZpY2F0ZSBieSBhbnkgcGFydHkgYXNzdW1lcyBhY2NlcHRhbmNlIG9mIHRoZSB0aGVuIGFwcGxpY2FibGUgc3RhbmRhcmQgdGVybXMgYW5kIGNvbmRpdGlvbnMgb2YgdXNlLCBjZXJ0aWZpY2F0ZSBwb2xpY3kgYW5kIGNlcnRpZmljYXRpb24gcHJhY3RpY2Ugc3RhdGVtZW50cy4wNQYDVR0fBC4wLDAqoCigJoYkaHR0cDovL2NybC5hcHBsZS5jb20va2V5c2VydmljZXMuY3JsMB0GA1UdDgQWBBTcMLLajv6XDqfkZPp0GQ7IEeG/FzAOBgNVHQ8BAf8EBAMCBSAwLQYLKoZIhvdjZAYNAQMBAf8EGwFjOXh2b2I5dXVpemJ2enprcDFnMjlibzNydjAyBgsqhkiG92NkBg0BBAEB/wQgAW43aTJzMGF4bnF3Z3N2dHgzN3gzdDl2bmowMnlkanowDQYJKoZIhvcNAQEFBQADggEBABAubWcR53n9V+UzSpmku9PLFRPVMSxcMsd1/giibXmJT2pY1qcqzYSi6AfeEZm3Bq/3yZTupjzFKPSuqALDGuBw8fvCcjSBY6RdgNB4awMKDLDOnsCdu7r3X68oAnayrD5bauTQMHkBUnLhGP6CpaSeTduAXVKj3ZK+O+2iYFSN1kP3bjr9cQDXVz5LfRP5llHjuBMYCWlP7ZXxbz7PIRGfoytYagFqTgtRDue0u5QqKpJtL8IuOhrVjaZZk/A9UzyxMK4l+mcoJJkWo85pNKdyW4WGxjw/lg+RNIAqyeLXsQa+FFsKhAXp9NZXRttE3XQKHEJEVc+8sdqExq1fkwo=")
        
        let source = PKMediaSource(entryId, contentUrl: URL(string: contentURL), drmData: nil, mediaFormat: .hls)
//        let source = PKMediaSource(entryId, contentUrl: URL(string: contentURL), drmData: [drmData], mediaFormat: .hls)
        
        // setup media entry
        let mediaEntry = PKMediaEntry(entryId, sources: [source], duration: -1)
        
        // create media config
        let mediaConfig = MediaConfig(mediaEntry: mediaEntry)
        
        // prepare the player
        self.player!.prepare(mediaConfig)
    }
    
/************************/
// MARK: - Actions
/***********************/
    
    @IBAction func playTouched(_ sender: Any) {
        guard let player = self.player else {
            print("player is not set")
            return
        }
        
        if !(player.isPlaying) {
            player.play()
        }
    }
    
    @IBAction func pauseTouched(_ sender: Any) {
        guard let player = self.player else {
            print("player is not set")
            return
        }

        player.pause()
    }
    
    var didDragValue: Float = 0
    
    @IBAction func didDrag(_ sender: Any) {
        let slider = sender as! UISlider
        guard let player = self.player else {
            print("player is not set")
            return
        }
        
        let rounded = Float(round(1000 * slider.value)/1000)

        if didDragValue == rounded {
            return
        }
        
        didDragValue = rounded
        
        
        let currentTime = Int((player.duration * Double(didDragValue)).rounded(.down))
        
        print("Did drag: \(didDragValue) Time: \(currentTime)")
        
        
        if let image = player.closestImageForSeekDistance(seek: currentTime) {
            self.visualSeekingView.image = image
        } else {
//            let time = CMTime.init(seconds: currentTime, preferredTimescale: 1)
            
        }
        
        /*
        if currentTime.isMultiple(of: 10) {
            print("Load for current Time: \(currentTime)")
            player.loadImageForTimePeriod(time: [currentTime])
        }
        */
    }
    
    var didStartSeeking: Bool = false
    var seekDistance: Float = 0
    
    @IBAction func playheadValueChanged(_ sender: Any) {
        guard let player = self.player else {
            print("player is not set")
            return
        }
        
        let slider = sender as! UISlider
        
        print("playhead value:", slider.value)
        self.seekDistance = slider.value
    }
    
    @IBAction func didStartSeeking(_ sender: Any) {
        let slider = sender as! UISlider
        print("didStartSeeking: \(slider.value)")
        self.didStartSeeking = true
        player.cancellImageDownloading()
    }
    
    @IBAction func finishedSeeking(_ sender: Any) {
        let slider = sender as! UISlider
        print("finishedSeeking: \(slider.value)")
        
        
        player.currentTime = player.duration * Double(self.seekDistance)
        self.didStartSeeking = false
    }
    
    @IBAction func replayTouched(_ sender: Any) {
        guard let player = self.player else {
            print("player is not set")
            return
        }
        
        player.replay()
    }
}

/*
@IBAction func touchDragEnter(_ sender: Any) {
    let slider = sender as! UISlider
    print("Touch Drag Enter: \(slider.value)")
}

@IBAction func touchDragExit(_ sender: Any) {
    let slider = sender as! UISlider
    print("Touch Drag Exit: \(slider.value)")
}
*/
