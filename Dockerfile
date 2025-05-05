FROM ubuntu:20.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV FLUTTER_HOME=/opt/flutter
ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV PATH=$PATH:$FLUTTER_HOME/bin:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip 

RUN apt-get install -y \
    libglu1-mesa \
    openjdk-11-jdk \
    wget \
    clang \
    cmake

RUN apt-get install -y \    
    ninja-build \
    pkg-config \
    libgtk-3-dev

# Install Flutter
RUN git clone https://github.com/flutter/flutter.git $FLUTTER_HOME -b stable
RUN flutter precache
RUN flutter doctor

# Install Android SDK tools
RUN mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-8092744_latest.zip && \
    unzip commandlinetools-linux-8092744_latest.zip -d ${ANDROID_SDK_ROOT}/cmdline-tools && \
    mv ${ANDROID_SDK_ROOT}/cmdline-tools/cmdline-tools ${ANDROID_SDK_ROOT}/cmdline-tools/latest && \
    rm commandlinetools-linux-8092744_latest.zip

# Accept Android licenses
RUN yes | sdkmanager --licenses

# Install Android SDK components
RUN sdkmanager "platform-tools" "platforms;android-33" "build-tools;33.0.1"

# Set up a working directory
WORKDIR /app

# Copy Flutter project files
COPY mobile_app/ .

# Define a volume for local development
VOLUME ["/app"]

# Default command
CMD ["flutter", "run", "--no-sound-null-safety"]