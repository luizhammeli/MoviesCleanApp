//
//  RemoteMovieLoaderFactory.swift
//  Main
//
//  Created by Luiz Hammerli on 26/02/22.
//

import Foundation
import Data

func makeRemoteMovieLoaderFactory(url: URL, httpClient: HttpGetClient) -> RemoteMovieLoader {
    RemoteMovieLoader(url: url, httpClient: httpClient)
}

func makeRemoteMovieImageLoaderFactory(httpClient: HttpGetClient) -> RemoteMovieImageDataLoader {    
    RemoteMovieImageDataLoader(client: httpClient)
}
