//
//  HomeView.swift
//  POSBonjourPOC
//
//  Created by ousama boujaouane on 07/06/2023.
//

import SwiftUI

struct HomeView: View {

    @ObservedObject var deviceBrowser = DeviceBrowser()
    
    @State private var showMasterDeviceView = false
    @State private var showSlaveDeviceView = false

    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: MasterDeviceView(deviceBrowser: deviceBrowser),
                               isActive: $showMasterDeviceView) {
                    Button("Show Master Device View") {
                        self.showMasterDeviceView = true
                    }.padding([.bottom], 20)
                }
                NavigationLink(destination: SlaveDeviceView(),
                               isActive: $showSlaveDeviceView) {
                    Button("Show Slave Devices View") {
                        self.showSlaveDeviceView = true
                    }
                }
            }
            .navigationTitle("Bonjour Service POC")
        }
        .navigationViewStyle(.stack)
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(deviceBrowser: DeviceBrowser())
    }
}
