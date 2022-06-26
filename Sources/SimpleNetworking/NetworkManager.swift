import Combine
import Foundation

public final class NetworkManager: Networking {
    
    public enum Error: Swift.Error {
        case error(error: Swift.Error?)
        case cannotParse
    }
    
    let urlSession: URLSession
    
    public weak var delegate: NetworkingDelegate?
    
    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    // closure based approach
    public func fetch<R: Request>(request: R, completion: @escaping (Result<R.Output, Error>) -> Void) {
        let urlRequest = makeRequest(request: request)
        
        urlSession.dataTask(with: urlRequest) { data, _, error in
            guard let data = data else {
                completion(.failure(.error(error: error)))
                return
            }
            guard let result = try? request.decode(data) else {
                completion(.failure(.cannotParse))
                return
            }
            completion(.success(result))
        }
    }
    
    // combine based approach
    @available(iOS 13.0, *)
    @available(macOS 10.15, *)
    public func fetch<R: Request>(request: R) -> AnyPublisher<R.Output, Swift.Error> {
        let urlRequest = makeRequest(request: request)
        
        return urlSession.dataTaskPublisher(for: urlRequest)
            .map(\.data)
            .tryMap(request.decode)
            .eraseToAnyPublisher()
    }
    
    // async/await approach
    @available(iOS 15.0.0, *)
    @available(macOS 12.0.0, *)
    public func fetch<R: Request>(request: R) async throws -> R.Output {
        let urlRequest = makeRequest(request: request)
        let (data, response) = try await urlSession.data(for: urlRequest, delegate: nil)
        return try request.decode(data)
    }
    
    // MARK: - Private
    
    private func makeRequest<R: Request>(request: R) -> URLRequest {
        var urlRequest = URLRequest(request: request)
        urlRequest.allHTTPHeaderFields = delegate?.headers(for: self)
        urlRequest.httpBody = delegate?.httpBody(for: self)
        return urlRequest
    }
}

extension URLRequest {
    fileprivate init<R: Request>(request: R) {
        var urlRequest = URLRequest(url: request.url)
        urlRequest.httpMethod = request.method.rawValue
        self = urlRequest
    }
}
