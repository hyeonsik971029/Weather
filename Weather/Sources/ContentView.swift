import SwiftUI

import Combine

public struct ContentView: View {
    
    @ObservedObject private var fetch = FetchManager()
    
    @State private var searchString = ""
    var filtered: [Location] {
        let locationsArr = self.fetch.locationsArr
        if self.searchString.isEmpty {
            let isFavoritesArr = locationsArr.filter { $0.favorites }
            return isFavoritesArr.isEmpty ? locationsArr: isFavoritesArr
        } else {
            return locationsArr.filter {
                $0.name.contains(self.searchString)
            }
        }
    }

    public var body: some View {
        NavigationView {
            List(self.filtered, id: \.name) { location in
                NavigationLink {
                    self.detailView(location)
                } label: {
                    Text("\(location.name)")
                }
            }
            .navigationTitle("지역 명")
            .searchable(
                text: $searchString,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "지역 명"
            )
        }
        .onAppear {
            self.fetch.loadLocationsFromCSV()
        }
    }
    
    @State var tmp = "0"
    @State var tmn = "0"
    @State var tmx = "0"
    
    @State var isFavorites = false
    
    func detailView(_ location: Location) -> some View {
        var cancellable = Set<AnyCancellable>()
        
        var body: some View {
            HStack {
                // 현재 기온, 최저/최고 온도
                VStack {
                    Text(self.tmp)
                    Text("\(location.name)")
                    Text("최저: \(self.tmn) 최대: \(self.tmx)")
                }
                .task {
                    await self.fetch.weatherByLocations(location).sink(
                        receiveCompletion: { response in
                            switch response {
                            case .finished:
                                print("finish!!!")
                            case .failure(let error):
                                print("Error occur: \(error.localizedDescription)")
                            }
                        },
                        receiveValue: { weather in
                            let items = weather.response.body.items.item
                            items.forEach {
                                var dateToString: String? {
                                    let formatter = DateFormatter()
                                    formatter.dateFormat = "yyyyMMdd"
                                    let dateToString = formatter.string(from: Date())
                                    return dateToString
                                }
                                if $0.baseDate == dateToString {
                                    if $0.category == "TMP" {
                                        self.tmp = $0.fcstValue
                                    }
                                    if $0.category == "TMN" {
                                        self.tmn = $0.fcstValue
                                    }
                                    if $0.category == "TMX" {
                                        self.tmx = $0.fcstValue
                                    }
                                }
                            }
                        }
                    )
                    .store(in: &cancellable)
                }
                
                // 즐겨찾기
                Button(action: {
                    self.isFavorites.toggle()
                }, label: {
                    Image(self.isFavorites ? "icon_star_fill": "icon_star_empty")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .onAppear {
                            self.isFavorites = location.favorites
                        }
                        .onDisappear {
                            DataManager.shared.updateFavorites(
                                "Locations",
                                name: location.name,
                                favorites: self.isFavorites
                            )
                            
                            self.fetch.loadLocationsFromCSV()
                        }
                })
            }
        }
        
        return body
    }
}


//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
