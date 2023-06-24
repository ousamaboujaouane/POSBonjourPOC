//
//  DeviceBrowser.swift
//  POSBonjourPOC
//
//  Created by ousama boujaouane on 05/06/2023.
//

import Network
import UIKit

class DeviceBrowser: NSObject, NetServiceBrowserDelegate, NetServiceDelegate, ObservableObject {
    
    private var serviceBrowser: NetServiceBrowser!
    private var netService: NetService!
    
    @Published var discoveredServices = [NetService]()
    @Published var masterIsPublished = false
    @Published var hostURL: URL?

    
    override init() {
        super.init()
        setupServiceBrowser()
    }
    
    private func setupServiceBrowser() {
        serviceBrowser = NetServiceBrowser()
        serviceBrowser.includesPeerToPeer = true
        serviceBrowser.delegate = self
    }
    
    func publishDevice() {
        netService = NetService(domain: "", type: "_emiratesService._tcp.", name: UIDevice.current.name, port: 49897)
        netService.delegate = self
        netService.publish()
        masterIsPublished = true
    }
    
    func unpublishDevice() {
        netService.stop()
        masterIsPublished = false
    }
    
    func startSearch() {
        //discoveredServices.removeAll()
        serviceBrowser.searchForServices(ofType: "_emiratesService._tcp.", inDomain: "")
    }
    
    func stopSearch() {
        serviceBrowser.stop()
    }
    
    // MARK: - NetServiceBrowserDelegate
    
    func netServiceBrowserWillSearch(_ browser: NetServiceBrowser) {
        print("Searching for devices...")
    }
    
    func netServiceBrowserDidStopSearch(_ browser: NetServiceBrowser) {
        print("Search stopped.")
    }
    
    func updateInterface () {
        for service in self.discoveredServices {
            if service.port == -1 {
                print("service \(service.name) of type \(service.type)" +
                      " not yet resolved")
                service.delegate = self
                service.resolve(withTimeout: 10.0)
            } else {
                print("service \(service.name) of type \(service.type)," +
                      "port \(service.port), addresses \(String(describing: service.addresses))")
            }
        }
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        print("Device found: \(service)")
        discoveredServices.append(service)
        
        if !moreComing {
            // All devices have been discovered
            // You can update your UI or perform any other operations with the discovered devices here
            updateInterface()
        }
    }
    
    func netService(_ sender: NetService, didAcceptConnectionWith inputStream: InputStream, outputStream: OutputStream) {
        print("connection accepted")
    }
    
    func netServiceDidResolveAddress(_ sender: NetService) {
        print("netServiceDidResolveAddress")
    }
    
    func resolveThenConnectTo(_ sender: NetService) {
        print("trying to connect to the host")

        // First part : resolve address
        guard let addresses = sender.addresses else {
            print("No addresses found")
            return
        }
        
        if let addressData = addresses.first,
           let socketAddress = addressData.withUnsafeBytes({ $0.baseAddress?.assumingMemoryBound(to: sockaddr_storage.self) }) {
            
            var mutableSocketAddress = socketAddress.pointee
            
            let addressFamily = mutableSocketAddress.ss_family
            
            var addressString = [CChar](repeating: 0, count: Int(NI_MAXHOST))
            var port: UInt16 = 0
            
            if addressFamily == sa_family_t(AF_INET) {
                let socketAddressIPv4 = withUnsafeMutableBytes(of: &mutableSocketAddress) { rawPtr in
                    rawPtr.baseAddress!.assumingMemoryBound(to: sockaddr_in.self)
                }
                port = socketAddressIPv4.pointee.sin_port
                let ipAddress = inet_ntop(AF_INET, &(socketAddressIPv4.pointee.sin_addr), &addressString, socklen_t(addressString.count))
                if let ipAddress, let host = String(validatingUTF8: ipAddress) {
                    if let url = URL(string: "http://\(host):\(port)") {
                        print("url for AF_INET family to connect: \(String(describing: url))")
                        
                        // Continue with URLSession and further processing
                        connectTo(host, port)
                    }
                }
            } else if addressFamily == sa_family_t(AF_INET6) {
                let socketAddressIPv6 = withUnsafeMutableBytes(of: &mutableSocketAddress) { rawPtr in
                    rawPtr.baseAddress!.assumingMemoryBound(to: sockaddr_in6.self)
                }
                port = socketAddressIPv6.pointee.sin6_port
                let ipAddress = inet_ntop(AF_INET6, &(socketAddressIPv6.pointee.sin6_addr), &addressString, socklen_t(addressString.count))
                if let ipAddress, let host = String(validatingUTF8: ipAddress) {
                    if let url = URL(string: "http://\(host):\(port)") {
                        print("url for AF_INET6 family to connect: \(String(describing: url))")
                        
                        // Continue with URLSession and further processing
                        connectTo(host, port)
                    }
                }
            }
        }
    }
    
    private func connectTo(_ ipAddress: String,_ port: UInt16) {
        // Second part connect to address
        // Create the endpoint for the server socket
        let endpoint = NWEndpoint.hostPort(host: NWEndpoint.Host(ipAddress), port: NWEndpoint.Port(rawValue: port)!)

        // Create a TCP connection to the server
        let connection = NWConnection(to: endpoint, using: .tcp)

        // Handle state changes and data received on the connection
        connection.stateUpdateHandler = { newState in
            switch newState {
            case .ready:
                   print("Connected to the server")
                   // Perform actions when the connection is ready
                   
               case .waiting:
                   print("Connection is waiting for a network interface")
                   // Handle waiting state, display message or perform actions
                   
               case .preparing:
                   print("Connection is being prepared")
                   // Handle preparing state, display progress indicator or relevant status
                   
               case .failed(let error):
                   print("Connection error: \(error.localizedDescription)")
                   // Handle the connection error
            default:
                break
            }
        }

        // Start the connection
        connection.start(queue: .main)
    }
    
    func netService(_ sender: NetService, didNotResolve errorDict: [String : NSNumber]) {
        print("Device resolution failed with error: \(errorDict)")
    }
        
    func netServiceBrowser(_ browser: NetServiceBrowser, didRemove service: NetService, moreComing: Bool) {
//        print("Device removed: \(service)")
//        if let index = discoveredServices.firstIndex(of: service) {
//            discoveredServices.remove(at: index)
//            print("removing a service")
//            if !moreComing {
//                self.updateInterface()
//            }
//        }
    }
}
