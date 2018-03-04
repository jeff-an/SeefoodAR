//
//  IntroChatViewController.swift
//  Seefood
//
//  Created by Sara on 3/2/18.
//  Copyright © 2018 Duvelop. All rights reserved.
//

import UIKit
import Chatto
import ChattoAdditions

class IntroChatViewController: BaseChatViewController {
    var currtxt = ""
    var cuisine: Cuisine = Cuisine.COMFORT
    var size: MealSize = MealSize.MEDIUM
    var specialRequests: [SpecialRequest] = []
    var currentMode = 0
    let modes = [
        "genre",
        "portion",
        "etc"
    ]
    var messageSender = DemoChatMessageSender()
    let messagesSelector = BaseMessagesSelector()
    var dataSource = DemoChatDataSource(count: 0, pageSize: 500)
    /*
    var dataSource: DemoChatDataSource! {
        didSet {
            self.chatDataSource = self.dataSource
            self.messageSender = self.dataSource.messageSender
        }
    }*/
    
    lazy private var baseMessageHandler: BaseMessageHandler = {
        return BaseMessageHandler(messageSender: self.messageSender, messagesSelector: self.messagesSelector)
    }()
    
    func parsePortionResponse(response: String) -> MealSize {
        let stringToSize = [
            "SMALL": MealSize.SMALL,
            "MEDIUM": MealSize.MEDIUM,
            "LARGE": MealSize.LARGE
        ]
        return stringToSize[response] ?? MealSize.MEDIUM
    }
    
    func parseCuisineResponse(response: String) -> Cuisine {
        let stringToCuisine = [
            "JAPANESE": Cuisine.JAPANESE,
            "KOREAN": Cuisine.KOREAN,
            "CHINESE": Cuisine.CHINESE,
            "AMERICAN": Cuisine.AMERICAN,
            "COMFORT": Cuisine.COMFORT,
            "INDIAN": Cuisine.INDIAN
        ]
        return stringToCuisine[response] ?? Cuisine.COMFORT
    }
    
    func parseETCResponse(response: String) -> [SpecialRequest] {
        let requests = response.components(separatedBy: ",")
        let stringToRequest = [
            "ORGANIC": SpecialRequest.ORGANIC,
            "SPICY": SpecialRequest.SPICY,
            "MILD": SpecialRequest.MILD,
            "GLUTENFREE": SpecialRequest.GLUTENFREE,
            "VEGETARIAN": SpecialRequest.VEGETARIAN,
            "NONE": SpecialRequest.NONE
        ]
        return requests.map({ val in return stringToRequest[val] ?? SpecialRequest.NONE })
    }
    
    func advanceMode(response: String) {
        if (currentMode == 2) {
            // just finished etc
            specialRequests = parseETCResponse(response: response)
            prepareResultsView()
            return
        } else if (currentMode == 1) {
            // just finished portion
            size = parsePortionResponse(response: response)
        } else if (currentMode == 0) {
            // just finished genre
            cuisine = parseCuisineResponse(response: response)
        } else {
            // something wrong, just move on
            prepareResultsView()
            return
        }
        currentMode += 1
        return
    }
    
    func prepareResultsView() {
        // TODO: segue behavior here
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.chatDataSource = self.dataSource
        self.messageSender = self.dataSource.messageSender
        self.title = "Chat"
        self.messagesSelector.delegate = self as! MessagesSelectorDelegate
        self.chatItemsDecorator = DemoChatItemsDecorator(messagesSelector: self.messagesSelector)
        self.dataSource.addTextMessage(text: "What would you like to eat?", isIncoming: true)
    }
    
    var chatInputPresenter: BasicChatInputBarPresenter!
    override func createChatInputView() -> UIView {
        let chatInputView = ChatInputBar.loadNib()
        var appearance = ChatInputBarAppearance()
        appearance.sendButtonAppearance.title = NSLocalizedString("Send", comment: "")
        appearance.textInputAppearance.placeholderText = NSLocalizedString("Type a message", comment: "")
        self.chatInputPresenter = BasicChatInputBarPresenter(chatInputBar: chatInputView, chatInputItems: self.createChatInputItems(), chatInputBarAppearance: appearance)
        chatInputView.maxCharactersCount = 1000
        return chatInputView
    }
    
    override func createPresenterBuilders() -> [ChatItemType: [ChatItemPresenterBuilderProtocol]] {
        
        let textMessagePresenter = TextMessagePresenterBuilder(
            viewModelBuilder: DemoTextMessageViewModelBuilder(),
            interactionHandler: DemoTextMessageHandler(baseHandler: self.baseMessageHandler)
        )
        textMessagePresenter.baseMessageStyle = BaseMessageCollectionViewCellAvatarStyle()
        
        return [
            DemoTextMessageModel.chatItemType: [textMessagePresenter]
        ]
    }
    
    func createChatInputItems() -> [ChatInputItemProtocol] {
        var items = [ChatInputItemProtocol]()
        items.append(self.createTextInputItem())
        return items
    }
    
    private func createTextInputItem() -> TextChatInputItem {
        let item = TextChatInputItem()
        item.textInputHandler = { [weak self] text in
            self?.dataSource.addTextMessage(text: text, isIncoming: false)
            let type = (self?.modes[(self?.currentMode)!])
            self?.dataSource.respondToText(type: type!, text: text, vc: self!)
            print("Sending payload with type " + type! + " and text " + text)
            self?.currtxt = text
            /**
            if(DemoChatMessageFactory.messageindex == 0){
                DemoChatMessageFactory.messageindex = 1
                self?.dataSource.addTextMessage(text: DemoChatMessageFactory.demoTexts[2], isIncoming: true)
            }
            else if(DemoChatMessageFactory.messageindex == 2){
                DemoChatMessageFactory.messageindex = 3
                self?.dataSource.addTextMessage(text: DemoChatMessageFactory.demoTexts[3], isIncoming: true)
            }
            else if(DemoChatMessageFactory.messageindex == 3 && self?.currtxt.lowercased() == "yes"){
                self?.dataSource.addTextMessage(text: DemoChatMessageFactory.demoTexts[5], isIncoming: true)
                DemoChatMessageFactory.messageindex = 4
                self?.dataSource.addTextMessage(text: DemoChatMessageFactory.demoTexts[9], isIncoming: true)
            }
            else if(DemoChatMessageFactory.messageindex == 3 && self?.currtxt.lowercased() == "no"){
                DemoChatMessageFactory.messageindex = 5
                self?.dataSource.addTextMessage(text: DemoChatMessageFactory.demoTexts[4], isIncoming: true)
            }
            else if(DemoChatMessageFactory.messageindex == 5 && self?.currtxt.lowercased() == "negative"){
                DemoChatMessageFactory.messageindex = 6
                self?.dataSource.addTextMessage(text: DemoChatMessageFactory.demoTexts[6], isIncoming: true)
                
            }
                //repeat that
            else{
                self?.dataSource.addTextMessage(text: DemoChatMessageFactory.demoTexts[6], isIncoming: true)
            }
            **/
        }
        return item
    }

}

extension IntroChatViewController: MessagesSelectorDelegate {
    func messagesSelector(_ messagesSelector: MessagesSelectorProtocol, didSelectMessage: MessageModelProtocol) {
        self.enqueueModelUpdate(updateType: .normal)
    }
    
    func messagesSelector(_ messagesSelector: MessagesSelectorProtocol, didDeselectMessage: MessageModelProtocol) {
        self.enqueueModelUpdate(updateType: .normal)
    }
}

