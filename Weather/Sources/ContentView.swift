import SwiftUI

import Combine

public struct ContentView: View {
    
    @ObservedObject var fetch = FetchManager()

    public var body: some View {
        
        NavigationView {
            List(self.fetch.locationsArr, id: \.name) { location in
                NavigationLink {
                    self.detailView(location)
                } label: {
                    Text("\(location.name)")
                }
            }
            .navigationTitle("지역 명")
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
