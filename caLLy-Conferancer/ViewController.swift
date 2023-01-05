//
//  ViewController.swift
//  caLLy-Conferancer
//
//  Created by Ayberk Mogol on 2.01.2023.
//

import UIKit
import VoxeetSDK
import VoxeetUXKit

class ViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var conferenceNameTextField: UITextField!
    @IBOutlet weak var startConferenceButton: UIButton!
    
    private let kConferenceNameNSUserDefaults = "conferenceNameNSUserDefaults"
    private let kUsernameNSUserDefaults = "usernameNSUserDefaults"
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
          if let window = UIApplication.shared.keyWindow {
              for subview in window.subviews {
                  if subview.accessibilityIdentifier == "ConferenceView" && subview.frame.origin == .zero {
                      return .lightContent
                  }
              }
          }
          return .default
      }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Populate textfields using cache.
        if let conferenceName = UserDefaults.standard.object(forKey: kConferenceNameNSUserDefaults) as? String {
            conferenceNameTextField.text = conferenceName
        }
        if let username = UserDefaults.standard.object(forKey: kUsernameNSUserDefaults) as? String {
            usernameTextField.text = username
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        conferenceNameTextField.becomeFirstResponder()
    }

    @IBAction func startConferenceAction(_ sender: Any) {
        guard VoxeetSDK.shared.conference.current?.id == nil else { return }
               
               // Get conference alias and username.
               let conferenceNameTextFieldText = conferenceNameTextField.text?.lowercased().replacingOccurrences(of: " ", with: "")
               guard let confAlias = conferenceNameTextFieldText, let username = usernameTextField.text, !confAlias.isEmpty && !username.isEmpty else {
                   // Error message.
                   let alert = UIAlertController(title: "Error", message: "Invalid conference name/username", preferredStyle: .alert)
                   alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                   self.present(alert, animated: true, completion: nil)
                   return
               }
               
               // Save to cache.
               UserDefaults.standard.set(confAlias, forKey: kConferenceNameNSUserDefaults)
               UserDefaults.standard.set(username, forKey: kUsernameNSUserDefaults)
               UserDefaults.standard.synchronize()
               
               // Disable startConferenceButton during request network.
               startConferenceButton.isEnabled = false
               startConferenceButton.alpha = 0.5
               
               // Connect participant with a random avatar and start conference.
               let avatarID = Int(arc4random_uniform(1000000))
               let participant = VTParticipantInfo(externalID: nil, name: username, avatarURL: "https://gravatar.com/avatar/\(avatarID)?s=200&d=identicon")
               VoxeetSDK.shared.session.open(info: participant) { error in
                   self.startConference(alias: confAlias)
               }
    }
    
     private func startConference(alias: String) {
         // Create a conference (with a custom conference alias).
         let options = VTConferenceOptions()
         options.alias = alias
         
         VoxeetSDK.shared.conference.create(options: options, success: { conference in
             // Join the created conference as listener.
             self.joinConference(conference)
             
         }, fail: { error in
             // Re-enable startConferenceButton when the request finish.
             self.startConferenceButton.isEnabled = true
             self.startConferenceButton.alpha = 1
             //self.errorPopUp(error: error)
         })
     }
     
     private func joinConference(_ conference: VTConference) {
         // Join the created conference.
         VoxeetSDK.shared.conference.join(conference: conference, success: { conference in
             // Re-enable startConferenceButton when the request finish.
             self.startConferenceButton.isEnabled = true
             self.startConferenceButton.alpha = 1
             
             // Debug.
             print("[VoxeetUXKitSample] \(String(describing: self)).\(#function).\(#line) - Conference successfully started")
         }, fail: { error in
             // Re-enable startConferenceButton when the request finish.
             self.startConferenceButton.isEnabled = true
             self.startConferenceButton.alpha = 1
             //self.errorPopUp(error: error)
         })
     }
    
}
