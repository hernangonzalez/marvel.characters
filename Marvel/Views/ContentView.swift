//
//  ContentView.swift
//  Marvel
//
//  Created by Hernan G. Gonzalez on 16/01/2020.
//  Copyright © 2020 Hernan. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ContentViewModel
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .edgesIgnoringSafeArea(.all)
            ScrollView(.vertical) {
                VStack {
                    ForEach(viewModel.rows) { row in
                        Text(row.name)
                        Divider()
                    }
                    ActivityIndicatorView(isAnimating: true, style: .medium)
                        .onAppear(perform: viewModel.updateResults)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
            }
        }
    }
}
