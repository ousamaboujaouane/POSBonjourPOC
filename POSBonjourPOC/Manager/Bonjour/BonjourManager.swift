//
//  BonjourManager.swift
//  POC
//
//  Created by Jonathan Nguyen on 11/07/2023.
//

import Bonjour
import SwiftUI

class BonjourManager: ObservableObject {
    
    private var bonjourSession: BonjourSession?
    private var data: Data?
    var onDataReceived:((Data) -> Void)?
    var onPeerConnected: ((Peer) -> Void)?
    
    func startSession(with configuration: BonjourSession.Configuration) {
        self.bonjourSession = BonjourSession(usage: .combined,
                                             configuration: configuration)
                
        self.bonjourSession?.onPeerConnection = { peer in
            self.onPeerConnected?(peer)
        }
                
        self.bonjourSession?.onReceive = { data, peer in
            self.onDataReceived?(data)          
        }
        
        self.bonjourSession?.start()
    }
    
    func stopSession() {
        bonjourSession?.stop()
    }
    
    func updateMaster(with data: Data) {
        guard let indexMaster = bonjourSession?.availablePeers.firstIndex(where: { $0.isMaster }),
                let master = bonjourSession?.availablePeers[indexMaster] else  { return }
            self.bonjourSession?.send(data, to: [master])
    }
    
    func updatePeers(with data: Data) {
        self.bonjourSession?.broadcast(data)
    }
}



