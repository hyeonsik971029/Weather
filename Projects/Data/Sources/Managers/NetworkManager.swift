//
//  NetworkManager.swift
//  Data
//
//  Created by 오현식 on 4/23/24.
//  Copyright © 2024 hyeonsik. All rights reserved.
//

import Combine
import Foundation

import Domain

// TODO: Client 만들어서 사용해보기
//public actor APIClient {
//    private let session: URLSession
//    private let baseURL: URL
//    
//    public init(
//        baseURL: URL,
//        configuration: URLSessionConfiguration = .default,
//        delegate: APIClientDelegate? = nil
//    ) {
//        self.url = url
//        self.session = URLSession(configuration: configuration)
//        self.delegate = delegate ?? DefaultAPIClientDelegate()
//    }
//}

public class NetworkManager {
    public static let shared = NetworkManager()
    
    public func weatherByGrid(_ location: LocationInfo) -> AnyPublisher<Weather, Error> {
        let serviceKey = "Qj/YURB65hOyyUnblK1/I9xs1ivp4Tj2/OQuF83kkUD8b0Bc238c53hb2P99kwiNi9v90iTtzb+rMuVGChxvuA=="
        let endpoint = "http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst"
        
        return Future<Weather, Error> { promise in
            guard var components = URLComponents(string: endpoint) else {
                promise(.failure(URLError(.badURL)))
                return
            }
            
            let serviceKey = URLQueryItem(name: "serviceKey", value: serviceKey)
            let numOfRows = URLQueryItem(name: "numOfRows", value: "1000")
            let dataType = URLQueryItem(name: "dataType", value: "JSON")
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyyMMdd"
            let baseDate = URLQueryItem(name: "base_date", value: formatter.string(from: Date()))
            
            formatter.dateFormat = "HHmm"
            let timeToString = formatter.string(from: Date())
            let baseTime: URLQueryItem
            switch timeToString {
            case "0200"..."0459":
                baseTime = URLQueryItem(name: "base_time", value: "0200")
            case "0500"..."0759":
                baseTime = URLQueryItem(name: "base_time", value: "0500")
            case "0800"..."1059":
                baseTime = URLQueryItem(name: "base_time", value: "0800")
            case "1100"..."1359":
                baseTime = URLQueryItem(name: "base_time", value: "1100")
            case "1400"..."1659":
                baseTime = URLQueryItem(name: "base_time", value: "1400")
            case "1700"..."1959":
                baseTime = URLQueryItem(name: "base_time", value: "1700")
            case "2000"..."2259":
                baseTime = URLQueryItem(name: "base_time", value: "2000")
            default:
                baseTime = URLQueryItem(name: "base_time", value: "2300")
            }
            
            let nx = URLQueryItem(name: "nx", value: location.x)
            let ny = URLQueryItem(name: "ny", value: location.y)
            
            components.queryItems = [serviceKey, numOfRows, dataType, baseDate, baseTime, nx, ny]
            if var queryString = components.query {
                queryString = queryString.replacingOccurrences(of: "+", with: "%2B")
                queryString = queryString.replacingOccurrences(of: "/", with: "%2F")
                
                components.percentEncodedQuery = queryString
            }
            
            guard let url = components.url else {
                promise(.failure(URLError(.badURL)))
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    promise(.failure(error))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    promise(.failure(URLError(.badServerResponse)))
                    return
                }
                
                guard let data = data else {
                    promise(.failure(URLError(.badServerResponse)))
                    return
                }
                
                do {
                    let weather = try JSONDecoder().decode(Weather.self, from: data)
                    promise(.success(weather))
                    return
                } catch {
                    promise(.failure(error))
                    return
                }
            }
            .resume()
        }
        .eraseToAnyPublisher()
    }
}
