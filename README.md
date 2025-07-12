# Tonefy: A Modern Flutter Music Player

Tonefy is a sleek and intuitive music player application developed with Flutter, designed to deliver a seamless audio experience for local music files. It leverages the `on_audio_query` package for efficient audio file management and `just_audio` for robust and high-quality audio playback.

## Key Features

- **Local Music Playback**: Enjoy your favorite tracks directly from your device's storage.
- **Intuitive User Interface**: A beautifully crafted and responsive UI ensures an engaging user experience.
- **Comprehensive Playback Controls**: Full control over your music with play, pause, seek, shuffle, and track navigation functionalities.
- **Rich Visuals**: Displays album art to enhance the listening experience.
- **Interactive Progress Slider**: Easily navigate through songs with a precise and interactive progress bar.

## Getting Started

Follow these instructions to set up and run Tonefy on your local development environment.

### Prerequisites

Ensure you have the following installed:

- **Flutter SDK**: Version 3.x.x or higher.
- **IDE**: Android Studio or VS Code with the Flutter and Dart plugins.
- **Device**: A physical Android/iOS device or an emulator/simulator for testing.

### Installation

1.  **Clone the repository:**

    ```bash
    git clone [YOUR_REPOSITORY_URL_HERE]
    cd Tonefy
    ```

2.  **Install dependencies:**

    ```bash
    flutter pub get
    ```

3.  **Run the application:**

    ```bash
    flutter run
    ```

    *Note: Ensure that your device or emulator has granted the necessary permissions for accessing local storage to allow Tonefy to discover and play music files.*

## Screenshots

![Tonefy Screenshot](assets/Screenshot_1752345443.png)

## Usage

Upon launching the application, Tonefy will automatically scan your device for local music files. You can then browse your music library, select a song to play, and utilize the on-screen controls for playback management. The interactive slider allows for precise seeking within a track.

## Project Structure

```
lib/
├── common/             # Shared utilities, helpers, and navigation logic
├── core/               # Core application components (e.g., constants, network services, base use cases)
├── data/               # Data layer implementation (repositories, data sources, models)
├── domain/             # Domain layer definitions (entities, use case interfaces, repository abstractions)
├── main.dart           # Application entry point and initial setup
├── presentation/       # UI layer (screens, widgets, BLoC/Cubit implementations)
│   └── home/           # Home screen specific modules
│       ├── bloc/       # BLoC/Cubit for state management of the home screen
│       ├── page/       # UI pages/screens for the home section
│       └── widgets/    # Reusable UI widgets specific to the home screen
└── service_locator.dart  # Dependency injection setup using GetIt
```

## Core Dependencies

This project utilizes the following key packages:

-   `on_audio_query`: Facilitates querying and accessing audio files on various device platforms.
-   `just_audio`: Provides a robust and flexible audio playback solution for Flutter.
-   `flutter_bloc`: Manages application state efficiently using the BLoC (Business Logic Component) pattern.
-   `get_it`: A lightweight service locator for managing dependencies.
-   `equatable`: Simplifies value equality comparisons for Dart objects.
-   `dartz`: Introduces functional programming concepts, particularly `Either` for elegant error handling.
-   `sleek_circular_slider`: Enables the creation of customizable circular sliders for UI elements.

## Contributing

Contributions are highly welcome! If you have suggestions for improvements, new features, or bug fixes, please feel free to open an issue or submit a pull request.

## License

This project is licensed under the MIT License. See the `LICENSE` file for more details.

## Acknowledgements

-   [Flutter](https://flutter.dev/)
-   [on_audio_query](https://pub.dev/packages/on_audio_query)
-   [just_audio](https://pub.dev/packages/just_audio)


