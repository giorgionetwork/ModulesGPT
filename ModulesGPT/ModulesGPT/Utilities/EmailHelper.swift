//
//  EmailHelper.swift
//  ModulesGPT
//
//  Created by Giorgio Ferraz on 2/10/23.
//

import MessageUI

class EmailHelper: NSObject, MFMailComposeViewControllerDelegate {
    
    public static let shared = EmailHelper()
    private override init() {}
    
    func sendEmail(subject: String, body: String, to: String){
        if !MFMailComposeViewController.canSendMail() { return }
        
        let picker = MFMailComposeViewController()
        picker.setSubject(subject)
        picker.setMessageBody(body, isHTML: true)
        picker.setToRecipients([to])
        picker.mailComposeDelegate = self
        
        EmailHelper.getRootViewController()?.present(picker, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        EmailHelper.getRootViewController()?.dismiss(animated: true, completion: nil)
    }
    
    static func getRootViewController() -> UIViewController? {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        return windowScene?.windows.first?.rootViewController
    }
}


