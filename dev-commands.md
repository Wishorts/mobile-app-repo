# Build the Docker image

docker-compose build

# Run the Flutter container with bash

docker-compose run flutter

# Inside the container, run Flutter commands

flutter pub get
flutter run

# For Android specific commands

flutter build apk

# To exit the container

exit

#Points to remember-
Notes for your Collaborators
Your friends will need:
-Docker installed on their systems (regardless of OS)
-Git for version control
-For iOS development, at least one team member needs macOS with XCode

Since building for iOS requires macOS, your Docker setup will primarily help with Android development and general Flutter coding. For iOS compilation, a team member with a Mac would need to handle that part of the process.
