//
//  GithubAPI.swift
//  Sihaty Task
//
//  Created by Admin on 14/08/2021.
//


import Foundation
import Combine

enum Services {
    static let pageSize = 15
    
    static func getRepos(page: Int) -> AnyPublisher<[Repository], Error> {
        let url = URL(string: "https://api.github.com/users/JakeWharton/repos?page=\(page)&per_page=15")!
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .handleEvents(receiveOutput: { print(NSString(data: $0.data, encoding: String.Encoding.utf8.rawValue)!) })
            .tryMap { try JSONDecoder().decode([Repository].self, from: $0.data) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}


struct Repository: Codable, Identifiable ,Equatable{
    
    let id = UUID()
    var fullName: String?
    var description: String?
    var htmlUrl: String?
    var language: String?
    
    enum CodingKeys: String, CodingKey {
        case  description, language
        case fullName = "full_name"
        case htmlUrl = "html_url"
        
        
    }
}


