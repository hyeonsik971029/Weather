import SwiftUI

import Combine

public struct ContentView: View {
    
    @ObservedObject var fetch = FetchManager()
    
    @State private var searchString = ""
    var filtered: [(key: String, value: Location)] {
        if self.searchString.isEmpty {
            return self.fetch.locationsTuple.map { $0 }
        } else {
            return self.fetch.locationsTuple.filter {
                $0.key.contains(self.searchString)
            }
        }
    }

    public var body: some View {
        NavigationView {
            List(self.filtered, id: \.key) { tuple in
                NavigationLink {
                    self.detailView(tuple.value)
                } label: {
                    Text("\(tuple.key)")
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
    
    func detailView(_ location: Location) -> some View {
        var cancellable = Set<AnyCancellable>()
        
        var body: some View {
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
        }
        
        return body
    }
}


//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
