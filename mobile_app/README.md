# Flutter App

A cross-platform Flutter application for Android and iOS.

## Development Setup Requirements

To work on this project, you'll need:

1. **Docker**: 
   - [Installation instructions](https://docs.docker.com/get-docker/)

2. **Git**:
   - [Installation instructions](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

## Setup Instructions

1. Clone the repository:
https://github.com/Wishorts/mobile-app-repo.git

2. Build the Docker container:
docker-compose build

3. Start the Docker container:
docker-compose run flutter

4. Inside the container, you can run Flutter commands:
flutter pub get
flutter run

## For iOS Development

For iOS development, team members with macOS will need:
- XCode installed
- iOS development certificates

## For Testing on Physical Devices

- Android: Connect your device and enable USB debugging
- iOS: Connect your device to a Mac with XCode
