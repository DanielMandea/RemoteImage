//
//  RemoteImageService.swift
//  RemoteImage
//
//  Created by Christian Elies on 11.08.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import Combine
import Foundation

public final class RemoteImageService: NSObject, ObservableObject {
    private var cancellable: AnyCancellable?
    
    var state: RemoteImageState = .loading {
        didSet {
            objectWillChange.send()
        }
    }
    
    public static let cache = NSCache<NSURL, RemoteImageType>()
    
    public let objectWillChange = PassthroughSubject<Void, Never>()
    
    func fetchImage(atURL url: URL) {
        cancellable?.cancel()
        
        if let image = RemoteImageService.cache.object(forKey: url as NSURL) {
            state = .image(image)
            return
        }
        
        let urlSession = URLSession.shared
        let urlRequest = URLRequest(url: url)
        
        cancellable = urlSession.dataTaskPublisher(for: urlRequest)
            .map { RemoteImageType(data: $0.data) }
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .failure(let failure):
                        self.state = .error(failure)
                    default: ()
                }
            }) { image in
                if let image = image {
                    RemoteImageService.cache.setObject(image, forKey: url as NSURL)
                    self.state = .image(image)
                } else {
                    self.state = .error(RemoteImageServiceError.couldNotCreateImage)
                }
            }
    }
}
