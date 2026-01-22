//
//  ContentView.swift
//  VideoTrimmer
//
//  Created by Noman belim on 22/01/26.
//

import SwiftUI
import SwiftUI
import AVFoundation
import AVKit
import PhotosUI

// MARK: - Content View
@available(iOS 16.0, *)
struct ContentView: View {
    @StateObject private var vm = VideoTrimmerViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                if vm.selectedVideo == nil {
                    EmptyStateView(vm: vm)
                } else {
                    VideoEditorView(vm: vm)
                }
            }
            .navigationTitle("Video Trimmer")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                if vm.selectedVideo != nil {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("New") {
                            vm.reset()
                        }
                    }
                }
            }
            .alert("Error", isPresented: $vm.showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(vm.errorMessage)
            }
            .alert("Success", isPresented: $vm.showSuccess) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Video saved successfully!")
            }
        }
    }
}
// MARK: - Empty State View
@available(iOS 16.0, *)
struct EmptyStateView: View {
    @ObservedObject var vm: VideoTrimmerViewModel
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "video.badge.plus")
                .font(.system(size: 80))
                .foregroundColor(.blue)
            
            Text("Select a Video")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Choose a video to trim and generate thumbnails")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button(action: { vm.showVideoPicker = true }) {
                Label("Select Video", systemImage: "photo.on.rectangle")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 15)
                    .background(Color.blue)
                    .cornerRadius(12)
            }
        }
        .photosPicker(isPresented: $vm.showVideoPicker, selection: $vm.selectedItem, matching: .videos)
        .onChange(of: vm.selectedItem) { newItem in
            vm.loadVideo(from: newItem)
        }
    }
}


#Preview {
    ContentView()
}
