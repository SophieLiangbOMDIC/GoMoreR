//
//  IntentHandler.swift
//  MessageIntents
//
//  Created by Sophie Liang on 2019/5/15.
//  Copyright © 2019 jake. All rights reserved.
//

import Intents

// As an example, this class is set up to handle Message intents.
// You will want to replace this or add other intents as appropriate.
// The intents you wish to handle must be declared in the extension's Info.plist.

// You can test your example integration by saying things to Siri like:
// "Send a message using <myApp>"
// "<myApp> John saying hello"
// "Search for messages in <myApp>"

class IntentHandler: INExtension, INSendMessageIntentHandling {
    
    override func handler(for intent: INIntent) -> Any {
        if intent is INSendMessageIntent {
            return INSendMessageIntent()
        }
        return self
    }
    
    // MARK: - INSendMessageIntentHandling
    func resolveContent(for intent: INSendMessageIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
        if let text = intent.content, !text.isEmpty {
            if text == "運動紀錄" || text == "我的體力" {
                completion(INStringResolutionResult.success(with: text))
            }
            completion(INStringResolutionResult.disambiguation(with: ["運動紀錄", "我的體力"]))
        } else {
            completion(INStringResolutionResult.disambiguation(with: ["運動紀錄", "我的體力"]))
        }
    }
    
    // Once resolution is completed, perform validation on the intent and provide confirmation (optional).
    
    func confirm(intent: INSendMessageIntent, completion: @escaping (INSendMessageIntentResponse) -> Void) {
        // Verify user is authenticated and your app is ready to send a message.
        
        let userActivity = NSUserActivity(activityType: NSStringFromClass(INSendMessageIntent.self))
        let response = INSendMessageIntentResponse(code: .ready, userActivity: userActivity)
        completion(response)
    }
    
    // Handle the completed intent (required).
    
    func handle(intent: INSendMessageIntent, completion: @escaping (INSendMessageIntentResponse) -> Void) {
        // Implement your application logic to send a message here.
        
        let userActivity = NSUserActivity(activityType: NSStringFromClass(INSendMessageIntent.self))
        let response = INSendMessageIntentResponse(code: .failureRequiringAppLaunch, userActivity: userActivity)
        completion(response)
    }
}
