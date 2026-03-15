# AirGapped

This is an **Epitech project**.

## Presentation
AirGapped is a mobile app that displays events.
For each event, the app provides buttons to:

- **Call** the organizer using the phone number.
- **Send an email** to the organizer.
- **Open the event website** in your browser.
- **Show the event location** on Google Maps.

Each button will automatically open the corresponding application on your phone and pre-fill the correct information, like phone number, email address, website, or location.

## Features

- Browse a list of events with all relevant details.
- Add or remove events from your **favorites**.
- Offline storage of favorites using a local JSON file.
- Easy navigation to event resources (phone, email, website, location).

## Project Structure

- **lib/**: Flutter source code.
- **assets/**: JSON files and images (logos, event data).
- **services/**: Contains `storage_service.dart` for saving and loading favorites.
- **main.dart**: Entry point of the application.

## Getting Started

### Prerequisites

- Flutter SDK installed ([Install guide](https://docs.flutter.dev/get-started/install)).
- VSCode for development with IDE.
- A connected device or emulator.

### Installation and use

1. Clone the repository:
```
git clone git@github.com:Valentin22r/AirGapped.git AirGapped
```

2. Enter the repository
To enter into the repository, use the command :
```
cd AirGapped
```
To enter the flutter project when you are in the repository, use the command :
```
cd airgapped
```

3. Install dependencies:
```
flutter pub get
```

4. Run the app:
```
flutter run
```

### Installation and build the apk
In the root of the repository, use the commande ```./builder```.
It will execute the script into [builder file](builder)
It will enter the flutter project, get all dependencies, build the apk, move the apk to the root of the reposity then go back to the root of the directory

### iOS (macOS only)
To build for iOS, follow these steps:

1. Ensure Xcode is installed and command-line tools are set up:
```
xcode-select --install
```
2. Navigate to the Flutter project:
```
cd airgapped
```
3. Install CocoaPods dependencies:
```
pod install
```
> Note: This is required if your project uses plugins with iOS native code.

4. Open the Xcode workspace:
open ios/Runner.xcworkspace

5. Select a simulator or a connected iPhone device in Xcode.

6. Build and run from Xcode:
- Click the Run button (▶) to launch the app on the simulator or device.
- Alternatively, from terminal:
```
flutter run
```
> Flutter will automatically use the selected iOS device.

7. To build an iOS release archive:
```
flutter build ios --release
```
- The archive will be in build/ios/iphoneos/Runner.app.
- You can distribute it via TestFlight or submit to the App Store using Xcode.

### Notes

- On Linux/Windows, you can only build and test Android or web versions.
- On MacOS, you can build for iOS after installing Xcode.

### Contributing

- Add new events by editing assets/events.json.
- Update images in assets/logos/.
- Make sure to run ```flutter clean``` then ```flutter pub get``` after adding dependencies.

---