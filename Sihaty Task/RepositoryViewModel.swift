//
//  RepositoryViewModel.swift
//  Sihaty Task
//
//  Created by Admin on 14/08/2021.
//

import SwiftUI
import Combine
import Network

class RepositoriesViewModel: ObservableObject {
    @Published private(set) var state = State()
    let monitor = NWPathMonitor()
    
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var showAlert = false

    func fetchNextPageIfPossible() {
        guard state.canLoadNextPage else { return }
        
        Services.getRepos(page: state.page)
            .sink(receiveCompletion: onReceive,
                  receiveValue: onReceive)
            .store(in: &subscriptions)
    }
    
    private func onReceive(_ completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            print("dfdf")
            break
        case .failure (let error):
            state.canLoadNextPage = false
            if !NetworkReachability().isNetworkAvailable() {
                state.repos = getAndMapFromLocalToRemote()
            }
            showAlert = true
        }
    }

    private func onReceive(_ batch: [Repository]) {
        let repos = state.repos + batch
        DatabaseManager.shared.addRepoListItems(repos)
        state.repos = repos
        state.page += 1
        state.canLoadNextPage = batch.count == Services.pageSize
    }
    
    func getAndMapFromLocalToRemote() -> [Repository] {
       let repos =  DatabaseManager.shared.fetchAllReposItems().compactMap { (repo) -> Repository in
            var repoItem = Repository()
            repoItem.fullName    = repo.fullName
            repoItem.description      = repo.details
            repoItem.fullName    = repo.fullName
            repoItem.language  = repo.language
            return repoItem
        }
        return repos
    }
    

    struct State {
        var repos: [Repository] = []
        var page: Int = 1
        var canLoadNextPage = true
    }
}
