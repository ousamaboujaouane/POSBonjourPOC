//
//  SlaveDeviceView.swift
//  POSBonjourPOC
//
//  Created by ousama boujaouane on 05/06/2023.
//

import SwiftUI

struct SlaveDeviceView: View {
    
    @StateObject var deviceBrowser = DeviceBrowser()
    
    var body: some View {
        VStack {
            Button {
                deviceBrowser.startSearch()
            } label: {
                Text("Discover master device(s)")
                    .padding(20)
                    .foregroundColor(.white)
                    .background(Color.mint)
                    .frame(maxWidth: .infinity)
            }
            .padding()
            
            Spacer()
            
            if deviceBrowser.discoveredServices.count > 0 {
                List(deviceBrowser.discoveredServices, id: \.self) { service in
                    VStack {
                        HStack {
                            Text(service.name)
                            
                            Spacer()
                            
                            Text("Not connected")
                                .font(.subheadline)
                                .frame(width: 200)
                        }
                    }
                    
                    Button(action: {
                        deviceBrowser.resolveThenConnectTo(service)
                    }) {
                        Text("Connect to this device")
                    }
                    .buttonStyle(.borderless)
                }
            } else {
                Text("No master device published yet")
                Spacer()
            }
        }
    }
}

struct SlaveDeviceView_Previews: PreviewProvider {
    static var previews: some View {
        SlaveDeviceView()
    }
}
