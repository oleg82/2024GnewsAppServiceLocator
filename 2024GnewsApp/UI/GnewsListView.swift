//
//  GnewsListView.swift
//  2024GnewsApp
//
//  Created by borispolevoj on 29.09.2024.
//

import SwiftUI

struct GnewsListView: View {
    @StateObject var viewModel: GnewsViewModel
    let category: DefaultAPI.Category_topHeadlinesGet
    
    @State private var isOn = false
    
    var body: some View {
        NavigationView {
            List(viewModel.loadedArticles, id: \.self) { item in
                NavigationLink(destination: GnewsFullInfoView(info: item)) {
                    let isElemLast = viewModel.loadedArticles.needToLoad(item)
                    let isLoading = isElemLast && viewModel.canLoad == false
                    
                    GnewsItemView(title: item.title ?? "", description: item.description ?? "", imageUrl: item.image ?? "")
                        .progressBar(isLoading: isLoading)
                        .onAppear {
                            viewModel.loadNext(category: category)
                        }
                }
            }
            .onAppear {
                viewModel.loadNext(category: category)
            }
        }
    }
}

