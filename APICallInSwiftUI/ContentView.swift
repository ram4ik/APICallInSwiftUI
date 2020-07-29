//
//  ContentView.swift
//  APICallInSwiftUI
//
//  Created by Ramill Ibragimov on 29.07.2020.
//

import SwiftUI

struct Result: Codable {
    let trackId: Int
    let trackName: String
    let collectionName: String
}

struct Response: Codable {
    let results: [Result]
}

struct ContentView: View {
    @State private var results = [Result]()
    
    var body: some View {
        NavigationView {
            List(results, id: \.trackId) { item in
                VStack(alignment: .leading) {
                    Text(item.trackName)
                        .font(.headline)
                    
                    Text(item.collectionName)
                }
            }.onAppear(perform: loadData)
            .navigationBarTitle("iTunes API")
        }
    }
    
    func loadData() {
        guard let url = URL(string: "http://itunes.apple.com/search?term=taylor+swift&entity=song") else { return }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                    DispatchQueue.main.async {
                        self.results = decodedResponse.results
                    }
                    return
                }
            }
        }.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
