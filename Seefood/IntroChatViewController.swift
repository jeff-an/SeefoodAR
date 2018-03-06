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
        return stringToSize[response.uppercased()] ?? MealSize.MEDIUM
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
        return stringToCuisine[response.uppercased()] ?? Cuisine.COMFORT
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
        return requests.map({ val in return stringToRequest[val.uppercased()] ?? SpecialRequest.NONE })
    }
    
    func advanceMode(response: String) {
        if (response == "error") {
            self.dataSource.addTextMessage(text: "All set, let's find you a meal!", isIncoming: true)
            prepareResultsView()
            return
        } else if (currentMode == 2) {
            // just finished etc
            specialRequests = parseETCResponse(response: response)
            self.dataSource.addTextMessage(text: "All set, let's find you a meal!", isIncoming: true)
            prepareResultsView()
            return
        } else if (currentMode == 1) {
            // just finished portion
            size = parsePortionResponse(response: response)
            self.dataSource.addTextMessage(text: "Any special requests for your meal? (Vegetarian, organic, gluten-free...)", isIncoming: true)
        } else if (currentMode == 0) {
            // just finished genre
            cuisine = parseCuisineResponse(response: response)
            self.dataSource.addTextMessage(text: "Now, how large a meal would you like?", isIncoming: true)
        } else {
            // somethinasrong, just move on
            self.dataSource.addTextMessage(text: "All set, let's find you a meal!", isIncoming: true)
            prepareResultsView()
            return
        }
        currentMode += 1
        return
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "renderResultsFromChat") {
            ResultsTableViewController.receiveChatResults(cuisine: cuisine, size: size, requests: specialRequests)
        }
    }
    
    func prepareResultsView() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "renderResultsFromChat", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 30, width: UIScreen.main.bounds.width, height: 70))
        self.view.addSubview(navBar);
        let rect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30)
        let greyView = UIView(frame: rect)
        greyView.backgroundColor = self.hexStringToUIColor(hex: "F9F9F9")
        self.view.addSubview(greyView)
        let navItem = UINavigationItem(title: "Chat");
        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: nil, action: Selector("unwind"));
        navItem.leftBarButtonItem = doneItem;
        navBar.setItems([navItem], animated: false);
        
        self.chatDataSource = self.dataSource
        self.messageSender = self.dataSource.messageSender
        self.title = "Chat"
        self.messagesSelector.delegate = self as! MessagesSelectorDelegate
        self.chatItemsDecorator = DemoChatItemsDecorator(messagesSelector: self.messagesSelector)
        self.dataSource.addTextMessage(text: "What would you like to eat?", isIncoming: true)
        self.dataSource.addTextMessage(text: "What would you like to eat?", isIncoming: true)

    }
    
    // color helper function
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) { cString.remove(at: cString.startIndex) }
        if ((cString.characters.count) != 6) { return UIColor.gray }
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        return UIColor( red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                        blue: CGFloat(rgbValue & 0x0000FF) / 255.0, alpha: CGFloat(1.0)
        )
    }
    
    @objc func unwind(){
        print("hello")
        self.performSegue(withIdentifier: "unwind", sender: self)
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

