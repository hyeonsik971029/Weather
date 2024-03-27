//
//  FetchManager.swift
//  Weather
//
//  Created by 오현식 on 3/23/24.
//

import Foundation

import Combine


class FetchManager: ObservableObject {
    
    @Published var locationsTuple = [(key: String, value: Location)]()
    
    func loadLocationsFromCSV() {
        if let path = Bundle.main.path(forResource: "Locations_Grid", ofType: "csv") {
            let url = URL(fileURLWithPath: path)
            do {
                let data = try Data(contentsOf: url)
                if let dataEncoded = String(data: data, encoding: .utf8) {
                    let dataArr = dataEncoded
                        .components(separatedBy: "\r\n")
                        .map { $0.components(separatedBy: ",") }
                    var tmpDic = [String: Location]()
                    for data in dataArr {
                        if data.count != 3 { continue }
                        tmpDic[data[0]] = Location(name: data[0], x: data[1], y: data[2])
                    }
                    
                    self.locationsTuple = tmpDic.sorted(by: { $0.key < $1.key })
                }
            } catch {
                print("Error reading CSV file: \(error.localizedDescription)")
            }
        } else {
            print("CSV file not found.")
        }
    }
    
    // 디코딩 키
    private let serviceKey = "Qj/YURB65hOyyUnblK1/I9xs1ivp4Tj2/OQuF83kkUD8b0Bc238c53hb2P99kwiNi9v90iTtzb+rMuVGChxvuA=="
    private let endpoint = "http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst"
    
    func weatherByLocations(_ location: Location) async -> AnyPublisher<Weather, Error> {
        guard var components = URLComponents(string: self.endpoint) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        let serviceKey = URLQueryItem(name: "serviceKey", value: self.serviceKey)
        let numOfRows = URLQueryItem(name: "numOfRows", value: "1000")
        let dataType = URLQueryItem(name: "dataType", value: "JSON")
        
        var dateToString: String? {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyyMMdd"
            let dateToString = formatter.string(from: Date())
            return dateToString
        }
        let baseDate = URLQueryItem(name: "base_date", value: dateToString)
        
        var timeToString: String? {
            let formatter = DateFormatter()
            formatter.dateFormat = "HHmm"
            let timeToString = formatter.string(from: Date())
            switch timeToString {
            case "0200"..."0459":
                return "0200"
            case "0500"..."0759":
                return "0500"
            case "0800"..."1059":
                return "0800"
            case "1100"..."1359":
                return "1100"
            case "1400"..."1659":
                return "1400"
            case "1700"..."1959":
                return "1700"
            case "2000"..."2259":
                return "2000"
            default:
                return "2300"
            }
        }
        let baseTime = URLQueryItem(name: "base_time", value: timeToString)
        let nx = URLQueryItem(name: "nx", value: location.x)
        let ny = URLQueryItem(name: "ny", value: location.y)
        
        components.queryItems = [serviceKey, numOfRows, dataType, baseDate, baseTime, nx, ny]
        if var queryString = components.query {
            queryString = queryString.replacingOccurrences(of: "+", with: "%2B")
            queryString = queryString.replacingOccurrences(of: "/", with: "%2F")
            
            components.percentEncodedQuery = queryString
        }
        
        if let url = components.url {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            return URLSession.shared.dataTaskPublisher(for: request)
                .tryMap { data, response in
                    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                        throw URLError(.badServerResponse)
                    }
                    return data
                }
                .decode(type: Weather.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
        }
        
        return Fail(error: URLError(
            .badURL,
            userInfo: [NSLocalizedDescriptionKey: "Invalid URL: endpoint to url"]
        )).eraseToAnyPublisher()
    }
}
