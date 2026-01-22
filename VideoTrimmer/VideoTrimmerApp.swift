//
//  VideoTrimmerApp.swift
//  VideoTrimmer
//
//  Created by Noman belim on 22/01/26.
//

import SwiftUI
import SwiftUI

@main
struct VideoTrimmerApp: App {
    var body: some Scene {
        WindowGroup {
            if #available(iOS 16.0, *) {
                ContentView()
            } else {
                Text("This app requires iOS 16.0 or later")
                    .padding()
            }
        }
    }
}
