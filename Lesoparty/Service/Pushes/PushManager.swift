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

    public func sendLocalPush(_ push: PushMessage) {
        push.sound = UNNotificationSound(named: UNNotificationSoundName("when.mp3"))

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: .leastNonzeroMagnitude, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: push, trigger: trigger)
        center.add(request) { err in
            print("error sendLocalPush", err?.localizedDescription as Any)
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
