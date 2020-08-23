//
//  NABRepository.swift
//  NAB
//
//  Created by Trung Luân on 8/21/20.
//  Copyright © 2020 LuanLT. All rights reserved.
//

import Foundation
import Moya

class NABRepository: Repository {
    
    let remoteRepository: RemoteRepository
    let localRepository: LocalRepository
    
    init() {
        let plugins: [PluginType] = [LogPlugin()]
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        self.remoteRepository = DefaultRemoteRepository(decoder: decoder,
                                                        plugins: plugins)
        self.localRepository = DefaultLocalRepository()
    }
}
