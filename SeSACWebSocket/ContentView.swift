//
//  ContentView.swift
//  SeSACWebSocket
//
//  Created by 선상혁 on 2023/12/26.
//

import SwiftUI

struct ContentView: View {
    
    @State
    private var showNextPage = false
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Button("이동하기") {
                showNextPage = true
            }
        }
        .padding()
        .sheet(isPresented: $showNextPage, content: {
            SocketView()
        })
    }
}

#Preview {
    ContentView()
}
