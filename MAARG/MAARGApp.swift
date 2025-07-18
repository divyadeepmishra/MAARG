//
//  MAARGApp.swift
//  MAARG
//
//  Created by DIVYADEEP MISHRA on 16/07/25.
//

import SwiftUI
import SwiftData

@main
struct MAARGApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: HikeRecord.self)  //This modifier creates the database and makes it available to our entire app.
        }
    }
}
