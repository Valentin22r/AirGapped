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

2. Install dependencies:
```
flutter pub get
```

3. Run the app:
```
flutter run
```

### Installation and build the apk

Make the commande ```./builder``` into the root of the project.

### Notes

- On Linux/Windows, you can only build and test Android or web versions.
- On MacOS, you can build for iOS after installing Xcode.

### Contributing

- Add new events by editing assets/events.json.
- Update images in assets/logos/.
- Make sure to run ```flutter clean``` then ```flutter pub get``` after adding dependencies.

---