# 🎬 Video Trimmer & Thumbnail Generator

<div align="center">

![iOS](https://img.shields.io/badge/iOS-16.0+-blue.svg)
![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)
![SwiftUI](https://img.shields.io/badge/SwiftUI-4.0-green.svg)
![License](https://img.shields.io/badge/License-MIT-yellow.svg)

A professional SwiftUI-based iOS application for video trimming and thumbnail generation, built with modern Apple frameworks.

 

</div>

---

## 📱 Overview

Video Trimmer & Thumbnail Generator is a native iOS application that provides an intuitive interface for video editing operations. Built entirely with SwiftUI and AVFoundation, it demonstrates production-ready video processing capabilities while maintaining App Store compliance.

### Key Capabilities

- **Video Selection**: Import videos directly from the Photos library using PhotosUI
- **Smart Trimming**: Precise start and end time controls with real-time preview
- **Thumbnail Generation**: Automatically extract 6 preview frames from any video segment
- **Export Options**: Save trimmed videos or individual thumbnails to Photos
- **Modern UI**: Clean, native iOS design following Apple's Human Interface Guidelines

---

## ✨ Features

### Core Functionality

- ✅ **Photo Library Integration** - Seamless video import using PhotosUI framework
- ✅ **Video Playback** - Built-in AVPlayer with play/pause and seek controls
- ✅ **Precision Trimming** - Dual slider system (green=start, red=end) with live duration display
- ✅ **Live Progress Tracking** - Real-time playback position indicator synced with video
- ✅ **Thumbnail Extraction** - Generate 6 evenly-spaced preview thumbnails from trimmed segment
- ✅ **Thumbnail Selection** - Visual selector with blue border indicator for chosen frame
- ✅ **High-Quality Export** - Save trimmed videos at maximum quality (AVAssetExportPresetHighestQuality)
- ✅ **Photo Library Saving** - Direct integration with iOS Photos app using PHPhotoLibrary

### Technical Features

- 🏗️ **MVVM Architecture** - Clean separation with VideoTrimmerViewModel
- ⚡ **Async/Await** - Modern Swift concurrency for all heavy operations
- 🎯 **Error Handling** - Comprehensive error states with user-friendly alerts
- 📱 **iOS 16+ Support** - Leverages PhotosPicker and latest SwiftUI capabilities
- 🔄 **State Management** - Reactive UI with @Published property observers
- 🎨 **Modular Design** - Separated into 4 distinct view files for maintainability

---

## 📋 Requirements

- **iOS**: 16.0 or later
- **Xcode**: 15.0 or later
- **Swift**: 5.9 or later
- **Frameworks**: SwiftUI, AVFoundation, AVKit, PhotosUI, Photos

---

## 🚀 Installation

### 1. Clone the Repository

```bash
git clone https://github.com/nomanbelim/video-trimmer-ios.git
cd video-trimmer-ios
```

### 2. Open in Xcode

```bash
open VideoTrimmer.xcodeproj
```

### 3. Configure Permissions

Add the following keys to your `Info.plist`:

```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>This app needs access to your photo library to select videos for trimming.</string>

<key>NSPhotoLibraryAddUsageDescription</key>
<string>This app saves trimmed videos and thumbnails to your photo library.</string>
```

### 4. Set Deployment Target

1. Select your project in Xcode navigator
2. Go to the **VideoTrimmer** target
3. Under **General** → **Deployment Info**
4. Set **Minimum Deployments** to **iOS 16.0**

### 5. Build and Run

1. Select your target device or simulator (iOS 16.0+)
2. Press `⌘ + R` to build and run
3. Grant photo library permissions when prompted

---

## 📖 Usage

### Basic Workflow

```
1. Launch App → 2. Select Video → 3. Set Trim Points → 4. Generate Thumbnails → 5. Export
```

### Step-by-Step Guide

#### 1. Selecting a Video
- Launch the app to see the empty state with a video icon
- Tap the **"Select Video"** button
- Choose a video from your Photos library
- The video loads automatically into the player

#### 2. Video Playback
- **Play/Pause**: Tap the large circular play button
- **Seek to Start**: Tap the backward button to jump to trim start point
- **Progress Slider**: Drag the slider to scrub through the video
- **Time Display**: Current time / Total duration shown below slider

#### 3. Trimming Video
- **Start Time Slider** (Green): Drag to set where the trim begins
- **End Time Slider** (Red): Drag to set where the trim ends
- **Duration Display**: Shows the length of your trimmed segment
- **Automatic Validation**: App prevents invalid ranges (start > end)

#### 4. Generating Thumbnails
- Tap **"Generate"** button in the Thumbnails section
- App extracts 6 frames evenly spaced across your trimmed range
- Progress indicator shows generation status
- Tap any thumbnail to select it (blue border appears)

#### 5. Exporting Content
- **Export Trimmed Video**: 
  - Tap the blue "Export Trimmed Video" button
  - Video saves to Photos at highest quality
  - Success alert confirms completion
  
- **Save Selected Thumbnail**: 
  - Select a thumbnail first (tap to highlight)
  - Tap the green "Save Selected Thumbnail" button
  - Image saves directly to Photos

#### 6. Starting Fresh
- Tap **"New"** in the top-right corner to reset and select another video

---

## 🏗️ Architecture

### Project Structure

```
VideoTrimmer/
│
├── VideoTrimmerApp.swift           # App entry point with @main attribute
│   └── iOS version check (16.0+)
│
├── ContentView.swift               # Main view controller
│   ├── NavigationView wrapper
│   ├── EmptyStateView (no video selected)
│   ├── VideoEditorView (video loaded)
│   ├── Error/Success alerts
│   └── Toolbar with "New" button
│
├── VideoPlayerView.swift           # Video playback components
│   ├── VideoEditorView
│   │   ├── ScrollView container
│   │   ├── VideoPlayerView (AVPlayer wrapper)
│   │   ├── VideoControlsView (play/pause/seek)
│   │   └── Layout coordination
│   │
│   ├── VideoPlayerView
│   │   └── AVPlayerViewController integration
│   │
│   └── VideoControlsView
│       ├── Play/Pause button
│       ├── Seek to Start button
│       ├── Progress slider
│       └── Time displays
│
├── TrimmerSection.swift            # Trimming & export logic
│   ├── TrimmerSection
│   │   ├── Start time slider (green)
│   │   ├── End time slider (red)
│   │   ├── Duration calculator
│   │   └── Validation logic
│   │
│   ├── ThumbnailsSection
│   │   ├── Generate button
│   │   ├── Loading state
│   │   ├── Horizontal scroll grid
│   │   └── Empty state message
│   │
│   ├── ThumbnailCell
│   │   ├── Image display
│   │   ├── Selection indicator
│   │   └── Tap gesture
│   │
│   ├── ActionButtonsView
│   │   ├── Export button
│   │   └── Save thumbnail button
│   │
│   ├── VideoTrimmerViewModel      # Core business logic
│   │   ├── Video loading
│   │   ├── Playback control
│   │   ├── Trimming management
│   │   ├── Thumbnail generation
│   │   └── Export operations
│   │
│   └── VideoPickerTransferable
│       └── PhotosPicker data transfer
```

---

## 💻 Code Structure

### File Breakdown

#### 1. **VideoTrimmerApp.swift** (Entry Point)
```swift
@main
struct VideoTrimmerApp: App {
    // iOS 16.0 version check
    // Launches ContentView
}
```

#### 2. **ContentView.swift** (Main Container)
- **ContentView**: Navigation wrapper, state management
- **EmptyStateView**: Initial state UI with video picker
- Handles toolbar, alerts, and video selection flow

#### 3. **VideoPlayerView.swift** (Playback Components)
- **VideoEditorView**: Main editing interface layout
- **VideoPlayerView**: AVPlayer wrapper with UIViewControllerRepresentable
- **VideoControlsView**: Play, pause, seek controls with progress slider

#### 4. **TrimmerSection.swift** (Business Logic & UI)
- **TrimmerSection**: Dual slider UI for start/end points
- **ThumbnailsSection**: Grid of generated thumbnails
- **ThumbnailCell**: Individual thumbnail with selection
- **ActionButtonsView**: Export and save buttons
- **VideoTrimmerViewModel**: Core logic (380+ lines)
- **VideoPickerTransferable**: PhotosPicker integration

---

## 🔧 Technical Implementation

### 1. Video Loading with PhotosPicker

```swift
// PhotosPicker integration in EmptyStateView
.photosPicker(
    isPresented: $vm.showVideoPicker,
    selection: $vm.selectedItem,
    matching: .videos
)

// Load video through Transferable
item.loadTransferable(type: VideoPickerTransferable.self) { result in
    // Handle success/failure
}
```

### 2. Video Playback & Time Observation

```swift
// Setup AVPlayer with periodic observer
private func setupTimeObserver() {
    let interval = CMTime(seconds: 0.1, preferredTimescale: 600)
    timeObserver = player?.addPeriodicTimeObserver(
        forInterval: interval,
        queue: .main
    ) { [weak self] time in
        self?.currentTime = time.seconds
    }
}
```

**Why 0.1 seconds?** Updates UI 10 times per second for smooth slider movement without performance overhead.

### 3. Smart Trimming Validation

```swift
// Prevent invalid trim ranges
.onChange(of: vm.startTime) { newValue in
    if newValue >= vm.endTime {
        vm.startTime = max(0, vm.endTime - 1)
    }
}

.onChange(of: vm.endTime) { newValue in
    if newValue <= vm.startTime {
        vm.endTime = min(vm.duration, vm.startTime + 1)
    }
}
```

**Safety Guarantees**:
- Start time always < End time
- Minimum 1-second trim duration
- Respects video boundaries (0 to duration)

### 4. Thumbnail Generation Algorithm

```swift
func generateThumbnails() {
    let generator = AVAssetImageGenerator(asset: asset)
    generator.appliesPreferredTrackTransform = true  // Respects video rotation
    generator.maximumSize = CGSize(width: 300, height: 300)
    
    let count = 6
    let step = (endTime - startTime) / Double(count)
    
    for i in 0..<count {
        let time = startTime + (Double(i) * step)
        // Extract frame at calculated timestamp
    }
}
```

**Thumbnail Strategy**:
- Generates 6 frames evenly distributed across trim range
- 300x300px max size for memory efficiency
- Preserves aspect ratio and orientation
- Async Task prevents UI blocking

### 5. Video Export with AVAssetExportSession

```swift
func exportTrimmedVideo() {
    let exportSession = AVAssetExportSession(
        asset: asset,
        presetName: AVAssetExportPresetHighestQuality
    )
    
    // Define trim range
    let timeRange = CMTimeRange(
        start: CMTime(seconds: startTime, preferredTimescale: 600),
        end: CMTime(seconds: endTime, preferredTimescale: 600)
    )
    
    exportSession.outputURL = temporaryURL
    exportSession.outputFileType = .mp4
    exportSession.timeRange = timeRange
    
    await exportSession.export()
    
    // Save to Photos library
    try await PHPhotoLibrary.shared().performChanges {
        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputURL)
    }
}
```

**Export Features**:
- Highest quality preset (no compression)
- MP4 container format (universal compatibility)
- Temporary file cleanup after save
- Photo Library integration with proper permissions

### 6. State Management with @Published

```swift
class VideoTrimmerViewModel: ObservableObject {
    // Video state
    @Published var selectedVideo: AVAsset?
    @Published var player: AVPlayer?
    @Published var duration: Double = 0
    
    // Playback state
    @Published var currentTime: Double = 0
    @Published var isPlaying = false
    
    // Trim state
    @Published var startTime: Double = 0
    @Published var endTime: Double = 0
    
    // Thumbnail state
    @Published var thumbnails: [UIImage] = []
    @Published var selectedThumbnailIndex: Int?
    @Published var isGeneratingThumbnails = false
    
    // UI state
    @Published var isExporting = false
    @Published var showError = false
    @Published var showSuccess = false
}
```

**Reactive Updates**: Any `@Published` property change automatically refreshes connected SwiftUI views.

---

## 📊 View Model API Reference

### VideoTrimmerViewModel

#### Published Properties

| Property | Type | Description |
|----------|------|-------------|
| `selectedVideo` | `AVAsset?` | Currently loaded video asset |
| `player` | `AVPlayer?` | Video player instance |
| `selectedItem` | `PhotosPickerItem?` | Selected item from picker |
| `showVideoPicker` | `Bool` | Controls picker presentation |
| `duration` | `Double` | Total video duration (seconds) |
| `currentTime` | `Double` | Current playback position (seconds) |
| `startTime` | `Double` | Trim start time (seconds) |
| `endTime` | `Double` | Trim end time (seconds) |
| `isPlaying` | `Bool` | Video playback state |
| `thumbnails` | `[UIImage]` | Generated thumbnail images |
| `selectedThumbnailIndex` | `Int?` | Currently selected thumbnail |
| `isGeneratingThumbnails` | `Bool` | Thumbnail generation state |
| `isExporting` | `Bool` | Video export state |
| `showError` | `Bool` | Error alert visibility |
| `showSuccess` | `Bool` | Success alert visibility |
| `errorMessage` | `String` | Error message text |

#### Methods

```swift
// Video Management
func loadVideo(from item: PhotosPickerItem?)
private func setupVideo(url: URL)
private func setupTimeObserver()

// Playback Control
func playPause()                    // Toggle play/pause
func seek(to time: Double)          // Seek to specific time
func seekToStart()                  // Jump to trim start

// Content Generation
func generateThumbnails()           // Extract 6 preview frames

// Export Operations
func exportTrimmedVideo()           // Save trimmed video to Photos
func saveThumbnail()                // Save selected thumbnail to Photos

// State Management
func reset()                        // Clear all state and restart
private func showErrorAlert(_ message: String)
```

---

## ⚡ Performance Considerations

### Optimization Strategies

1. **Async Operations**: All heavy tasks use Swift concurrency
   ```swift
   Task {
       // Thumbnail generation
       // Video export
       // Photo library saves
   }
   ```

2. **Memory Management**: 
   - Thumbnails capped at 300x300px (reduces memory 10x vs full size)
   - Temporary files deleted immediately after export
   - Weak self in time observer prevents retain cycles

3. **UI Responsiveness**:
   - 0.1s time observer interval (10 FPS) balances smoothness and performance
   - Progress indicators during long operations
   - Disabled buttons prevent double-submissions

4. **Resource Cleanup**:
   ```swift
   func reset() {
       player?.pause()
       player?.removeTimeObserver(observer)
       // Clear all references
   }
   ```

### Known Limitations

| Limitation | Impact | Reason |
|-----------|--------|--------|
| Large videos (>1GB) may take 30-60s to export | User must wait | iOS encoding performance |
| Thumbnail generation scales with video length | ~1-2 seconds for typical videos | Frame extraction is CPU-intensive |
| No background export | App must remain open | iOS AVAssetExportSession restriction |
| Maximum 6 thumbnails | Fixed preview count | Balances detail and memory |
| No frame-accurate trimming | 1-second precision minimum | Validation enforces minimum duration |

---

## 🎨 UI/UX Design

### Design Principles

- **Native iOS Feel**: Uses system colors, SF Symbols, and standard components
- **Clear Visual Hierarchy**: Color-coded controls (green=start, red=end, blue=actions)
- **Responsive Feedback**: Loading indicators, disabled states, progress tracking
- **Error Prevention**: Validation prevents invalid trim ranges
- **Accessibility**: Semantic labels, proper contrast ratios

### Color Scheme

| Element | Color | Purpose |
|---------|-------|---------|
| Start Slider | Green | Indicates beginning of trim |
| End Slider | Red | Indicates end of trim |
| Action Buttons | Blue | Primary actions |
| Save Button | Green | Success action |
| Selection Border | Blue | Selected thumbnail |

### Key UI Components

- **Empty State**: Large icon, clear call-to-action button
- **Video Player**: 250pt height, rounded corners
- **Control Buttons**: 50pt play/pause, 30pt seek
- **Sliders**: Full-width with colored accents
- **Thumbnails**: 120x90pt cells, horizontal scrolling
- **Action Buttons**: Full-width, 48pt height (touch-friendly)

---

## 🛡️ Error Handling

### Comprehensive Error Coverage

```swift
@MainActor
private func showErrorAlert(_ message: String) {
    errorMessage = message
    showError = true
    isExporting = false
    isGeneratingThumbnails = false
}
```

### Error Scenarios

| Error Type | User Message | Recovery |
|-----------|--------------|----------|
| Video load failure | "Failed to load video: [reason]" | Select another video |
| Export failure | "Export failed" | Try again or check storage |
| Photo library permission | "Failed to save video: [reason]" | Grant permissions in Settings |
| Thumbnail generation | "Failed to save thumbnail: [reason]" | Regenerate thumbnails |
| Invalid export session | "Failed to create export session" | Technical issue, restart app |

### Success Feedback

- ✅ **Video Export**: "Video saved successfully!"
- ✅ **Thumbnail Save**: "Video saved successfully!" (unified message)

---

## 🔮 Future Enhancements

### Planned Features

#### High Priority
- [ ] **Timeline-style trimmer** - Drag handles on video timeline
- [ ] **Frame-accurate trimming** - Frame-by-frame precision
- [ ] **Export progress bar** - Show 0-100% during export
- [ ] **Custom thumbnail count** - User selects 3-12 thumbnails

#### Medium Priority
- [ ] **Export quality presets** - 720p, 1080p, 4K options
- [ ] **Multiple aspect ratios** - 16:9, 1:1, 9:16, 4:5
- [ ] **Video compression** - Reduce file size options
- [ ] **Batch processing** - Trim multiple videos

#### Low Priority
- [ ] **Video filters** - Brightness, contrast, saturation
- [ ] **Audio waveform** - Visual audio representation
- [ ] **Video speed control** - Slow motion, fast forward
- [ ] **Text overlays** - Add captions

### Performance Improvements

- [ ] **Background export** - Continue export when app backgrounds
- [ ] **Progressive thumbnail loading** - Load thumbnails as visible
- [ ] **Video preview caching** - Cache decoded frames
- [ ] **Hardware acceleration** - Use GPU for encoding

---

## 🧪 Testing Recommendations

### Manual Testing Checklist

#### Video Selection
- [ ] Select video from Photos library
- [ ] Handle permission denial gracefully
- [ ] Load videos of various formats (MOV, MP4, etc.)
- [ ] Test with videos of different lengths (10s, 1m, 10m)

#### Trimming
- [ ] Set start time before end time
- [ ] Try to set invalid ranges (start > end)
- [ ] Trim very short segments (1-2 seconds)
- [ ] Trim entire video (0 to duration)

#### Playback
- [ ] Play/pause functionality
- [ ] Seek using slider
- [ ] Jump to start button
- [ ] Verify time display accuracy

#### Thumbnails
- [ ] Generate thumbnails successfully
- [ ] Select different thumbnails
- [ ] Regenerate after changing trim range
- [ ] Handle generation errors

#### Export
- [ ] Export trimmed video
- [ ] Save thumbnail to Photos
- [ ] Verify exported video plays correctly
- [ ] Check file size is reasonable

#### Edge Cases
- [ ] Reset and select new video
- [ ] Background app during export
- [ ] Deny photo library permissions
- [ ] Fill device storage and attempt export

---
 
