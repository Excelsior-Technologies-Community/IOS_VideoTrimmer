//
//  TrimmerSection.swift
//  VideoTrimmer
//
//  Created by Noman belim on 22/01/26.
//

import SwiftUI
import AVFoundation
import AVKit
import PhotosUI


// MARK: - Trimmer Section
struct TrimmerSection: View {
    @ObservedObject var vm: VideoTrimmerViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Trim Video")
                .font(.headline)
                .padding(.horizontal)
            
            VStack(spacing: 16) {
                HStack {
                    Text("Start:")
                        .fontWeight(.medium)
                        .frame(width: 60, alignment: .leading)
                    
                    Slider(value: $vm.startTime, in: 0...vm.duration)
                        .accentColor(.green)
                        .onChange(of: vm.startTime) { newValue in
                            if newValue >= vm.endTime {
                                vm.startTime = max(0, vm.endTime - 1)
                            }
                        }
                    
                    Text(timeString(vm.startTime))
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .frame(width: 50)
                }
                
                HStack {
                    Text("End:")
                        .fontWeight(.medium)
                        .frame(width: 60, alignment: .leading)
                    
                    Slider(value: $vm.endTime, in: 0...vm.duration)
                        .accentColor(.red)
                        .onChange(of: vm.endTime) { newValue in
                            if newValue <= vm.startTime {
                                vm.endTime = min(vm.duration, vm.startTime + 1)
                            }
                        }
                    
                    Text(timeString(vm.endTime))
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .frame(width: 50)
                }
                
                HStack {
                    Image(systemName: "scissors")
                        .foregroundColor(.blue)
                    Text("Duration: \(timeString(vm.endTime - vm.startTime))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(12)
            .padding(.horizontal)
        }
    }
    
    private func timeString(_ time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

// MARK: - Thumbnails Section
struct ThumbnailsSection: View {
    @ObservedObject var vm: VideoTrimmerViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Thumbnails")
                    .font(.headline)
                Spacer()
                Button(action: { vm.generateThumbnails() }) {
                    Label("Generate", systemImage: "photo.stack")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal)
            
            if vm.isGeneratingThumbnails {
                HStack {
                    Spacer()
                    ProgressView()
                    Text("Generating...")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.leading, 8)
                    Spacer()
                }
                .padding()
            } else if !vm.thumbnails.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(0..<vm.thumbnails.count, id: \.self) { index in
                            ThumbnailCell(
                                image: vm.thumbnails[index],
                                isSelected: vm.selectedThumbnailIndex == index,
                                action: { vm.selectedThumbnailIndex = index }
                            )
                        }
                    }
                    .padding(.horizontal)
                }
            } else {
                Text("Tap 'Generate' to create thumbnails")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
        }
    }
}

// MARK: - Thumbnail Cell
struct ThumbnailCell: View {
    let image: UIImage
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 120, height: 90)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 3)
                )
                .shadow(radius: 2)
        }
    }
}

// MARK: - Action Buttons View
struct ActionButtonsView: View {
    @ObservedObject var vm: VideoTrimmerViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            Button(action: { vm.exportTrimmedVideo() }) {
                HStack {
                    if vm.isExporting {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Image(systemName: "square.and.arrow.down")
                        Text("Export Trimmed Video")
                    }
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(12)
            }
            .disabled(vm.isExporting)
            
            if vm.selectedThumbnailIndex != nil {
                Button(action: { vm.saveThumbnail() }) {
                    HStack {
                        Image(systemName: "photo")
                        Text("Save Selected Thumbnail")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(12)
                }
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - View Model
@available(iOS 16.0, *)
class VideoTrimmerViewModel: ObservableObject {
    @Published var selectedVideo: AVAsset?
    @Published var player: AVPlayer?
    @Published var selectedItem: PhotosPickerItem?
    @Published var showVideoPicker = false
    
    @Published var duration: Double = 0
    @Published var currentTime: Double = 0
    @Published var startTime: Double = 0
    @Published var endTime: Double = 0
    @Published var isPlaying = false
    
    @Published var thumbnails: [UIImage] = []
    @Published var selectedThumbnailIndex: Int?
    @Published var isGeneratingThumbnails = false
    
    @Published var isExporting = false
    @Published var showError = false
    @Published var showSuccess = false
    @Published var errorMessage = ""
    
    private var timeObserver: Any?
    
    func loadVideo(from item: PhotosPickerItem?) {
        guard let item = item else { return }
        
        item.loadTransferable(type: VideoPickerTransferable.self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let video):
                    if let video = video {
                        self.setupVideo(url: video.url)
                    }
                case .failure(let error):
                    self.showErrorAlert("Failed to load video: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func setupVideo(url: URL) {
        selectedVideo = AVAsset(url: url)
        player = AVPlayer(url: url)
        
        let asset = AVAsset(url: url)
        duration = asset.duration.seconds
        endTime = duration
        
        setupTimeObserver()
    }
    
    private func setupTimeObserver() {
        let interval = CMTime(seconds: 0.1, preferredTimescale: 600)
        timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            self?.currentTime = time.seconds
        }
    }
    
    func playPause() {
        guard let player = player else { return }
        
        if isPlaying {
            player.pause()
        } else {
            player.play()
        }
        isPlaying.toggle()
    }
    
    func seek(to time: Double) {
        let cmTime = CMTime(seconds: time, preferredTimescale: 600)
        player?.seek(to: cmTime)
    }
    
    func seekToStart() {
        seek(to: startTime)
    }
    
    func generateThumbnails() {
        guard let asset = selectedVideo else { return }
        
        isGeneratingThumbnails = true
        thumbnails = []
        
        Task {
            let generator = AVAssetImageGenerator(asset: asset)
            generator.appliesPreferredTrackTransform = true
            generator.maximumSize = CGSize(width: 300, height: 300)
            
            let count = 6
            let step = (endTime - startTime) / Double(count)
            var images: [UIImage] = []
            
            for i in 0..<count {
                let time = startTime + (Double(i) * step)
                let cmTime = CMTime(seconds: time, preferredTimescale: 600)
                
                if let cgImage = try? generator.copyCGImage(at: cmTime, actualTime: nil) {
                    images.append(UIImage(cgImage: cgImage))
                }
            }
            
            await MainActor.run {
                self.thumbnails = images
                self.isGeneratingThumbnails = false
            }
        }
    }
    
    func exportTrimmedVideo() {
        guard let asset = selectedVideo else { return }
        
        isExporting = true
        
        Task {
            do {
                let outputURL = FileManager.default.temporaryDirectory.appendingPathComponent("trimmed_\(UUID().uuidString).mp4")
                
                guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality) else {
                    await showErrorAlert("Failed to create export session")
                    return
                }
                
                let startCMTime = CMTime(seconds: startTime, preferredTimescale: 600)
                let endCMTime = CMTime(seconds: endTime, preferredTimescale: 600)
                let timeRange = CMTimeRange(start: startCMTime, end: endCMTime)
                
                exportSession.outputURL = outputURL
                exportSession.outputFileType = .mp4
                exportSession.timeRange = timeRange
                
                await exportSession.export()
                
                if exportSession.status == .completed {
                    try await PHPhotoLibrary.shared().performChanges {
                        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputURL)
                    }
                    
                    try? FileManager.default.removeItem(at: outputURL)
                    
                    await MainActor.run {
                        self.isExporting = false
                        self.showSuccess = true
                    }
                } else {
                    await showErrorAlert("Export failed")
                }
            } catch {
                await showErrorAlert("Failed to save video: \(error.localizedDescription)")
            }
        }
    }
    
    func saveThumbnail() {
        guard let index = selectedThumbnailIndex, index < thumbnails.count else { return }
        
        let image = thumbnails[index]
        
        Task {
            do {
                try await PHPhotoLibrary.shared().performChanges {
                    PHAssetChangeRequest.creationRequestForAsset(from: image)
                }
                
                await MainActor.run {
                    self.showSuccess = true
                }
            } catch {
                await showErrorAlert("Failed to save thumbnail: \(error.localizedDescription)")
            }
        }
    }
    
    func reset() {
        player?.pause()
        player = nil
        selectedVideo = nil
        selectedItem = nil
        duration = 0
        currentTime = 0
        startTime = 0
        endTime = 0
        isPlaying = false
        thumbnails = []
        selectedThumbnailIndex = nil
        
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
            timeObserver = nil
        }
    }
    
    @MainActor
    private func showErrorAlert(_ message: String) {
        errorMessage = message
        showError = true
        isExporting = false
        isGeneratingThumbnails = false
    }
}

// MARK: - Video Transferable
@available(iOS 16.0, *)
struct VideoPickerTransferable: Transferable {
    let url: URL
    
    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(contentType: .movie) { video in
            SentTransferredFile(video.url)
        } importing: { received in
            let copy = FileManager.default.temporaryDirectory.appendingPathComponent(received.file.lastPathComponent)
            
            if FileManager.default.fileExists(atPath: copy.path) {
                try FileManager.default.removeItem(at: copy)
            }
            
            try FileManager.default.copyItem(at: received.file, to: copy)
            return Self(url: copy)
        }
    }
}
 
