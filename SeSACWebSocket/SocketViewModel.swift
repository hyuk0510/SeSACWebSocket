//
//  SocketViewModel.swift
//  SeSACWebSocket
//
//  Created by 선상혁 on 2023/12/26.
//

import Foundation
import Combine

class SocketViewModel: ObservableObject {
    
    private var cancellable = Set<AnyCancellable>() // dispose
    
    @Published
    var askOrderBook: [OrderbookItem] = []
    @Published 
    var bidOrderBook: [OrderbookItem] = []


    
    init() {
        WebSocketManager.shared.openWebSocket()
        
        WebSocketManager.shared.send()
        
        //RxSwift Subscribe vs Combine sink
        //RxSwift schedular vs Combine receive
        //RxSwift Dispose vs Combine AnyCancellable
        WebSocketManager.shared.orderBookSbj
            .receive(on: DispatchQueue.main)
            .sink { [weak self] order in
                guard let self else { return }
                self.askOrderBook = order.orderbookUnits
                    .map { .init(price: $0.askPrice, size: $0.askSize) }
                    .sorted { $0.price > $1.price }        
                
                self.bidOrderBook = order.orderbookUnits
                    .map { .init(price: $0.bidPrice, size: $0.bidSize) }        
                    .sorted { $0.price > $1.price }


            }
            .store(in: &cancellable)
    }
    
    deinit {
        WebSocketManager.shared.closeWebSocket()
    }
}
