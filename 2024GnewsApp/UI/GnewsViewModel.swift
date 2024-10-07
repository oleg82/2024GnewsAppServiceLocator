//
//  GnewsViewModel.swift
//  2024GnewsApp
//
//  Created by borispolevoj on 29.09.2024.
//

import Foundation


class GnewsViewModel: ObservableObject {
    @Published var loadedArticles: [ArticlesArticlesInner] = []
    @Published var canLoad = true
    
    private var page = 1
    private var totalArticles = 100
    private static let maxArticles = 10
    
    private let provider: GNewsProviding

    init(serviceLocator: ServiceLocating) {
        provider = serviceLocator.resolve()!
    }
    
    func loadNext(category: DefaultAPI.Category_topHeadlinesGet) {
        guard (page * GnewsViewModel.maxArticles) <= totalArticles else { return }
        guard canLoad else { return }

        canLoad = false

        Task {
            guard let result = try? await provider.getNews(category: category, max: GnewsViewModel.maxArticles, page: page) else {
                DispatchQueue.main.async { [weak self] in
                    print("Error! You have reached your request limit for today, the next reset will be tomorrow at midnight UTC. If you need more requests, you can upgrade your subscription here: https:\\\\gnews.io\\pricing")
                    self?.loadedArticles.append(
                        ArticlesArticlesInner(
                            title: "Навигация в SwiftUI или NavigationView и его особенности",
                            description: "Первое с чем вы сталкиваетесь при написании мобильного приложения, это переходы с одного экрана на другой и обратно (в случае простого приложения), а так же многоуровневые переходы и моментальный возврат на первый экран (back to root view). Всё это мы разберём на примерах в данной статье, ну а для начала немного углубимся в теорию.",
                            content: nil,
                            url: "https://habr.com/ru/articles/652593/",
                            image: "https://habrastorage.org/r/w1560/getpro/habr/upload_files/8b8/3ad/022/8b83ad022d6b723969e3577bc9a8c0ac.png",
                            publishedAt: "20 фев 2022 в 22:25"
                        )
                    )
                    self?.canLoad = true
                }
                return
            }

            DispatchQueue.main.async { [weak self] in
                self?.totalArticles = result.totalArticles ?? 0
                self?.loadedArticles.append(contentsOf: result.articles ?? [])
                self?.page += 1
                self?.canLoad = true
            }
        }
    }
}
