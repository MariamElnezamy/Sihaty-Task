//
//  RespoitoriesList.swift
//  Sihaty Task
//
//  Created by Admin on 14/08/2021.
//


import SwiftUI
import Combine


struct RepositoriesListContainer: View {
    @ObservedObject var viewModel: RepositoriesViewModel
    
    var body: some View {
        RepositoriesList(
            repos: viewModel.state.repos,
            isLoading: viewModel.state.canLoadNextPage,
            onScrolledAtBottom: viewModel.fetchNextPageIfPossible
        )
        .onAppear(perform: viewModel.fetchNextPageIfPossible)
        .alert(isPresented: $viewModel.showAlert) { () -> Alert in
            Alert(title: Text("No Connection."))
                }
    }
}

struct RepositoriesList: View {
    let repos: [Repository]
    let isLoading: Bool
    let onScrolledAtBottom: () -> Void
    
    var body: some View {
        List {
            reposList
            if isLoading {
                loadingIndicator
            }
        }
    }
    
    private var reposList: some View {
        ForEach(repos) { repo in
            RepositoryRow(repo: repo).onAppear {
                if self.repos.last == repo {
                    self.onScrolledAtBottom()
                }
            }
        }
    }
    
    private var loadingIndicator: some View {
        Spinner(style: .medium)
            .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .center)
    }
}

struct RepositoryRow: View {
    let repo: Repository
    
    var body: some View {
        VStack {
            Text(repo.fullName ?? "").font(.title)
            Text("⭐️ \(repo.language ?? "")").font(.title2)
            Text(repo.description ?? "").font(.body)
        }
        .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .center)
    }
}
