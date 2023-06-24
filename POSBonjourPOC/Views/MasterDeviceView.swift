//
//  MasterDeviceView.swift
//  POSBonjourPOC
//
//  Created by ousama boujaouane on 07/06/2023.
//

import SwiftUI

struct MasterDeviceView: View {
    
    @State var showDescription = false
    @ObservedObject var deviceBrowser: DeviceBrowser
    
    
    var body: some View {
        ZStack {
            if deviceBrowser.masterIsPublished {
                Text("This master device is published")
            }
            
            VStack(spacing: 60) {
                Button {
                    deviceBrowser.publishDevice()
                } label: {
                    Text("Publish this device as master")
                        .foregroundColor(.white)
                        .padding(20)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                }
                
                Button {
                    deviceBrowser.unpublishDevice()
                } label: {
                    Text("Unpublish this device")
                        .foregroundColor(.white)
                        .padding(20)
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                }
            }
            .fixedSize(horizontal: true, vertical: false)
        }
    }
}

struct MasterDeviceView_Previews: PreviewProvider {
    static var previews: some View {
        MasterDeviceView(deviceBrowser: DeviceBrowser())
    }
}
