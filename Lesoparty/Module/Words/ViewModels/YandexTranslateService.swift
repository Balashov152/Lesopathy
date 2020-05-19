//
//  YandexTranslateService.swift
//  MyWords
//
//  Created by Sergey Balashov on 03/07/2019.
//  Copyright © 2019 Sergey Balashov. All rights reserved.
//

import Foundation

private let apiKey = "trnsl.1.1.20190703T132302Z.6349d98682060898.b928e73276202b149784c6c2e9d7dbebb89d2731"
struct YandexTranslateService {
    
    public func translateAndSaveWord(text: String, completion: @escaping () -> Void) {
        translateWord(text: text) { (translate) in
            let enity = Word(context: CoreDataService.shared.persistentContainer.viewContext)
            enity.id = UUID()
            enity.original = text
            enity.translate = translate
            enity.create = Date()
            CoreDataService.shared.saveContext()
            completion()
        }
    }
    
    public func translateWord(text: String, completion: @escaping (_ translate: String) -> Void) {
        var components = URLComponents(string: "https://translate.yandex.net/api/v1.5/tr.json/translate")!
        components.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "text", value: text),
            URLQueryItem(name: "lang", value: "en-ru"),
            URLQueryItem(name: "format", value: "plain")
        ]
        guard let url = components.url else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                debugPrint(error)
                return
            }
            guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                if let json = json, let text = json["text"] as? [String], let translate = text.first {
                    completion(translate)
                }
            } catch {
                debugPrint(error)
            }
            
        }
        task.resume()
        
    }
    
}
