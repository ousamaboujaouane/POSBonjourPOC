//
//  BonjourManager+Variables.swift
//  POC
//
//  Created by Jonathan Nguyen on 11/07/2023.
//

import Bonjour


extension BonjourManager {
    
    static let masterConfiguration = BonjourSession.Configuration(serviceType: "Bonjour",
                                                                  peerName: BonjourManager.masterPeerName,
                                                                  defaults: .standard,
                                                                  security: .default,
                                                                  invitation: .automatic)
    
    static let slaveConfiguration =  BonjourSession.Configuration(serviceType: "Bonjour",
                                                                  peerName: BonjourManager.slavePeerName,
                                                                  defaults: .standard,
                                                                  security: .default,
                                                                  invitation: .automatic)
    
    static let masterPeerName = "MasterDevice"
    static let slavePeerName = "SlaveDevice"
}

extension Peer {
    var isMaster: Bool {
        return name == BonjourManager.masterPeerName
    }
}
