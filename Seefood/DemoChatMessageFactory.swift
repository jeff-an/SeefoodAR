/*
 The MIT License (MIT)

 Copyright (c) 2015-present Badoo Trading Limited.

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
*/

import Foundation
import Chatto
import ChattoAdditions

func createTextMessageModel(uid: String, text: String, isIncoming: Bool) -> DemoTextMessageModel {
    let messageModel = createMessageModel(uid: uid, isIncoming: isIncoming, type: DemoTextMessageModel.chatItemType)
    let textMessageModel = DemoTextMessageModel(messageModel: messageModel, text: text)
    return textMessageModel
}

func createMessageModel(uid: String, isIncoming: Bool, type: String) -> MessageModel {
    let senderId = isIncoming ? "1" : "2"
    
    let messageModel = MessageModel(uid: uid, senderId: senderId, type: type, isIncoming: isIncoming, date: NSDate() as Date, status: MessageStatus.success)
    return messageModel
}


extension TextMessageModel {
    static var chatItemType: ChatItemType {
        return "text"
    }
}

class DemoChatMessageFactory {
    static var messageindex = 0
    
    
    static let demoTexts = [
        "Hi! It's a beautiful day today ☀️", //0
        //Default Something Else
        "Sounds like you like fish! 😀",//1
        //Positive
        "That's great! 👏🏻 ", //2
        //No
        "That's okay, keep staying healthy!",//3
        //Yes
        "Great! I'll show you what this dish typically looks like",//4
        //Nothing Else
        "Alright, get ready...", //5
        //Didn't understand: Repeat
        "Sorry, I didn't understand 😔 Could you repeat that?" //6
    ]
    
    
    class func createChatItem(uid: String) -> MessageModelProtocol {
        //let isIncoming: Bool = arc4random_uniform(100) % 2 == 0
        return self.createChatItem(uid: uid, isIncoming: true)
    }
    
    class func createChatItem(uid: String, isIncoming: Bool) -> MessageModelProtocol {
        return self.createTextMessageModel(uid: uid, isIncoming: isIncoming)
    }
    
    
    class func createTextMessageModel(uid: String, isIncoming: Bool) -> DemoTextMessageModel {
        //let incomingText: String = isIncoming ? "incoming" : "outgoing"
        let text = self.demoTexts[messageindex]
        return Seefood.createTextMessageModel(uid: "\(index)", text: text, isIncoming: isIncoming)
    }
}


