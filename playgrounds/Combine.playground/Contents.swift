import Combine
import Foundation

class DecodableDataTaskSubscriber<Input: Decodable>: Subscriber, Cancellable {
    typealias Failure = Error

    var subscription: Subscription?

    func receive(subscription: Subscription) {
        self.subscription = subscription
        subscription.request(.unlimited)
    }

    func receive(_: Input) -> Subscribers.Demand {
        .none
    }

    func receive(completion _: Subscribers.Completion<Error>) {
        cancel()
    }

    func cancel() {
        subscription?.cancel()
        subscription = nil
    }
}

extension URLSession {
    class DecodedDataTaskPublisher<Output: Decodable>: Publisher {
        typealias Failure = Error

        init(urlRequest: URLRequest) {
            self.urlRequest = urlRequest
        }

        let urlRequest: URLRequest

        func receive<S>(subscriber: S) where S: Subscriber, Failure == S.Failure, Output == S.Input {
            let subscription = DecodedDataTaskSubscription(urlRequest: urlRequest, subscriber: subscriber)
            subscriber.receive(subscription: subscription)
        }
    }
}

extension URLSession.DecodedDataTaskPublisher {
    class DecodedDataTaskSubscription<Output: Decodable, S: Subscriber>: Subscription
        where S.Input == Output, S.Failure == Error
    {
        private let urlRequest: URLRequest
        private var subscriber: S?

        init(urlRequest: URLRequest, subscriber: S) {
            self.urlRequest = urlRequest
            self.subscriber = subscriber
        }

        func request(_ demand: Subscribers.Demand) {
            if demand > 0 {
                URLSession.shared.dataTask(with: urlRequest) { [weak self] data, _, error in
                    defer { self?.cancel() }
                    if let data {
                        do {
                            let result = try JSONDecoder().decode(Output.self, from: data)
                            self?.subscriber?.receive(result)
                            self?.subscriber?.receive(completion: .finished)
                        } catch {
                            self?.subscriber?.receive(completion: .failure(error))
                        }
                    } else if let error {
                        self?.subscriber?.receive(completion: .failure(error))
                    }
                }.resume()
            }
        }

        func cancel() {
            subscriber = nil
        }
    }
}

struct SomeModel: Decodable {
    let value: String
}

let request = URLRequest(url: URL(string: "https://www.google.com")!)
let publisher: URLSession.DecodedDataTaskPublisher<SomeModel> = URLSession.DecodedDataTaskPublisher(urlRequest: request)
let subscriber = DecodableDataTaskSubscriber<SomeModel>()
publisher.subscribe(subscriber)
