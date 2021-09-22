//
//  ImageCache.swift
//  BlogApp
//
//  Created by Ariel Ortiz on 9/21/21.
//

import SwiftUI

struct ImageCache: View {
    
    @ObservedObject var imageLoader: ImageLoaderAndCache
    @State private var isFit = false

    init(_ url: String, isFit: Bool = false) {
        imageLoader = ImageLoaderAndCache(imageURL: url)
        self.isFit = isFit
    }

    
    var body: some View {
        Image(uiImage: UIImage(data: self.imageLoader.imageData) ?? UIImage())
            .resizable()
            .aspectRatio(contentMode: isFit ? .fit : .fill)
              //.scaledToFit()
    }
}

struct ImageCache_Previews: PreviewProvider {
    static var previews: some View {
        ImageCache("")
    }
}


class ImageLoaderAndCache: ObservableObject {
    
    @Published var imageData = Data()
    
    init(imageURL: String) {
        let cache = URLCache.shared
        let request = URLRequest(url: URL(string: imageURL)!, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 60.0)
        if let data = cache.cachedResponse(for: request)?.data {
            self.imageData = data
        } else {
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if let data = data, let response = response {
                let cachedData = CachedURLResponse(response: response, data: data)
                                    cache.storeCachedResponse(cachedData, for: request)
                    DispatchQueue.main.async {
                        self.imageData = data
                    }
                }
            }).resume()
        }
    }
}
