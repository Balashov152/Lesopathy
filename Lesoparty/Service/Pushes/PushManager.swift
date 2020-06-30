//
//  PushManager.swift
//  Use and Go
//
//  Created by Sergey on 20.10.17.
//  Copyright © 2017 Sergey. All rights reserved.
//

import PushKit
import RxCocoa
import RxSwift
import UIKit
import UserNotifications

extension Storage {
    enum PushKeys: String {
        case pushTokenUpdateDate, pushToken
    }
    
    static var pushTokenUpdateDate: Date {
        get {
            return Date(timeIntervalSince1970: TimeInterval(defaults.integer(forKey: PushKeys.pushTokenUpdateDate.rawValue)))
        } set {
            debugPrint("update exepirationDate", newValue)
            defaults.set(newValue.timeIntervalSince1970, forKey: PushKeys.pushTokenUpdateDate.rawValue)
            defaults.synchronize()
        }
    }
    
    static var pushToken: String? {
        get {
            return defaults.string(forKey: PushKeys.pushToken.rawValue)
        } set {
            debugPrint("update pushToken", newValue ?? "")
            defaults.set(newValue, forKey: PushKeys.pushToken.rawValue)
            defaults.synchronize()
        }
    }
}

private extension SettingsModel.TypeIntensity {
    var timeIntervalPushes: TimeInterval {
        switch self {
        case .average:
            return TimeInterval(3 * 60 * 60) // 3 hour
        case .often:
            return TimeInterval(1 * 60 * 60) // 1 hour
        case .rarely:
            return TimeInterval(5 * 60 * 60) // 5 hour
        }
    }
}

class PushManager: NSObject {
    public static let shared = PushManager()

    let updateBadge = PublishSubject<Void>()
    var unreadPushMessages: [PushMessage] = [] {
        didSet {
            UIApplication.shared.applicationIconBadgeNumber = unreadPushMessages.count
        }
    }

    private let application = UIApplication.shared
    private let center = UNUserNotificationCenter.current()

    private var disposeBag = DisposeBag()

//    private var visible: UIViewController? { UIApplication.topViewController }

    private override init() {
        super.init()
        center.delegate = self
        center.removeAllPendingNotificationRequests()
        setupBindings()
        
        let timer = DispatchSource.makeTimerSource()
        timer.schedule(deadline: .now(), repeating: .seconds(10))
        timer.setEventHandler(handler: {
            PushManager.shared.backgroundFetch {}
        })
        
        timer.activate()
    }
    
    
    public func backgroundFetch(completion: @escaping () -> () = {}) {
        guard let word = Word.findFirst(sortDescriptors: [NSSortDescriptor(key: "rating", ascending: true)],
                                        context: .main) else { return }
        word.rating += 0.01
        CoreDataService.shared.saveContext()
        
        let content = PushMessage(word: word)
        sendLocalPush(content, completion: completion)
    }
    
    public func updatePushTasks(intensity: SettingsModel.TypeIntensity) {
        center.removeAllPendingNotificationRequests()
        let words: [Word] = Word.findAll(sortDescriptors: [NSSortDescriptor(key: "rating", ascending: true)],
                                         context: .main)
        
//        let _ = words.enumerated().map { word -> UNNotificationRequest in
//            let content = PushMessage(word: word.element)
//            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: intensity.timeIntervalPushes, repeats: true)
//            return UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//        }
//        requests.forEach { center.add($0, withCompletionHandler: nil) }
    }

    public func updatePushToken() {
        DispatchQueue.main.async {
            if UIApplication.shared.isRegisteredForRemoteNotifications,
                let exepirationDate = Calendar.current.date(byAdding: .hour, value: 24, to: Storage.pushTokenUpdateDate) {
                debugPrint("push exepirationDate", exepirationDate)
                if exepirationDate < Date() {
                    debugPrint("push unregisterForRemoteNotifications", exepirationDate, "pushTokenUpdateDate")
                    UIApplication.shared.unregisterForRemoteNotifications()
                    Storage.pushTokenUpdateDate = Date()
                }
            } else { // for first launch
                Storage.pushTokenUpdateDate = Date()
            }
            UIApplication.shared.registerForRemoteNotifications()
        }
    }

    private func setupBindings() {}

    public func updatePushToken(token: String) {
        Storage.pushToken = token
    }

    public func sendLocalPush(_ push: PushMessage, completion: @escaping () -> () = {}) {
        push.sound = UNNotificationSound(named: UNNotificationSoundName("when.mp3"))

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: .leastNonzeroMagnitude, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: push, trigger: trigger)
        center.add(request) { err in
            if let err = err {
                print("error sendLocalPush", err.localizedDescription)
            }
            completion()
        }
    }

    func didPressPush(message: PushMessage) {
        
    }

    func didPressOnNotificationContent(_ content: UNNotificationContent) {
        let push = PushMessage(category: content)
        didPressPush(message: push)
    }
}

extension PushManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case UNNotificationDismissActionIdentifier:
            print("Dismiss Action")

        case UNNotificationDefaultActionIdentifier:
            print("UNNotificationDefaultActionIdentifier")
            didPressOnNotificationContent(response.notification.request.content)

        default: break
        }
        completionHandler()
    }

    func userNotificationCenter(_: UNUserNotificationCenter, openSettingsFor _: UNNotification?) {}

    func userNotificationCenter(_: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("UNUserNotificationCenter willPresent Push", notification.request.content, notification.request.content.userInfo)

        updateBadge.onNext(())

        completionHandler([.alert, .sound, .badge])
    }
}

extension AppDelegate {
    // MARK: Push Notification's

    func application(_: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // present a local notifcation from Push when app is open
        print("Did Receive Remote Notification: \(userInfo)")
//        PushManager.shared.didReceivePushNotification(userInfo: userInfo)
    }

    // MARK: Register notification's

    func application(_: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenPush = deviceToken.reduce("") { $0 + String(format: "%02X", $1) }
        print("Push Notification token: \(tokenPush)")
        PushManager.shared.updatePushToken(token: tokenPush)
    }

    // MARK: Error register notification

    func application(_: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Push Notification token invalidated \(error)")
    }
}
