//
//  ExampleObject.swift
//  RealmExample
//
//  Created by Ben Jones on 8/22/14.
//  Copyright (c) 2014 Avocado Software Inc. All rights reserved.
//

import Foundation
import Realm

public class ExampleObject: RLMObject {
    dynamic var type: String = ""
    dynamic var text: String = ""
    dynamic var exampleId: String = ""
    dynamic var source: String = ""
    dynamic var createDate = NSDate(timeIntervalSince1970: 0)
}

extension ExampleObject {
    public class func createExampleFromResponse(examples: [NSDictionary]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            let realm = RLMRealm.defaultRealm()

            realm.beginWriteTransaction()

            for example: NSDictionary in examples {
                let realmExample = ExampleObject.exampleFromDictioanry(example, realm: realm)
                println("example \(example)")
            }

            realm.commitWriteTransaction()
        }
    }

    public class func exampleFromDictioanry(dictionary: NSDictionary, realm: RLMRealm) -> ExampleObject {
        let example = ExampleObject()

        if let type = dictionary["type"] as? String {
            example.type = type
        }

        if let text = dictionary["text"] as? String {
            example.text = text
        }

        if let exampleId = dictionary["id"] as? String {
            example.exampleId = exampleId
        }

        if let source = dictionary["source"] as? String {
            example.source = source
        }

        if let createTime = dictionary["createTime"] as? NSNumber {
            example.createDate = NSDate(timeIntervalSince1970: createTime.doubleValue * 1000)
        }

        realm.addObject(example)

        return example
    }
}