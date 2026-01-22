//
//  VideoPlayerView.swift
//  VideoTrimmer
//
//  Created by Noman belim on 22/01/26.
//

import SwiftUI
import AVFoundation
import AVKit
import PhotosUI

// MARK: - Video Editor View
@available(iOS 16.0, *)
struct VideoEditorView: View {
    @ObservedObject var vm: VideoTrimmerViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Video Preview
                VideoPlayerView(player: vm.player)
                    .frame(height: 250)
                    .cornerRadius(12)
                    .padding(.horizontal)
                
                // Video Controls
                VideoControlsView(vm: vm)
                
                // Trimmer Section
                TrimmerSection(vm: vm)
                
                // Thumbnails Section
                ThumbnailsSection(vm: vm)
                
                // Action Buttons
                ActionButtonsView(vm: vm)
                    .padding(.bottom, 20)
            }
            .padding(.top)
        }
    }
}

// MARK: - Video Player View
struct VideoPlayerView: View {
    let player: AVPlayer?
    
    var body: some View {
        ZStack {
            if let player = player {
                VideoPlayer(player: player)
                    .disabled(true)
            } else {
                Rectangle()
                    .fill(Color.black)
                    .overlay(
                        ProgressView()
                            .tint(.white)
                    )
            }
        }
    }
}

struct VideoPlayer: UIViewControllerRepresentable {
    let player: AVPlayer
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = true
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

// MARK: - Video Controls View
struct VideoControlsView: View {
    @ObservedObject var vm: VideoTrimmerViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 20) {
                Button(action: { vm.playPause() }) {
                    Image(systemName: vm.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.blue)
                }
                
                Button(action: { vm.seekToStart() }) {
                    Image(systemName: "backward.end.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.blue)
                }
            }
            
            // Progress Slider
            if vm.duration > 0 {
                VStack(spacing: 5) {
                    Slider(value: $vm.currentTime, in: 0...vm.duration, onEditingChanged: { editing in
                        if !editing {
                            vm.seek(to: vm.currentTime)
                        }
                    })
                    .accentColor(.blue)
                    
                    HStack {
                        Text(timeString(vm.currentTime))
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(timeString(vm.duration))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    private func timeString(_ time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
 
