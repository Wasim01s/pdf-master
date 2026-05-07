# PDF Engine

A professional, elite document compiler for mobile.

## Build Instructions

1.  **Clone the repository**
2.  **Ensure Flutter is installed**
3.  **Run dependencies installation:**
    ```bash
    flutter pub get
    ```
4.  **Build APK for Android:**
    ```bash
    flutter build apk --release
    ```

## CI/CD (Codemagic)

This project is pre-configured for **Codemagic**. Simply connect your repository and trigger a build. The `android/` directory contains all necessary Gradle wrappers for automated builds.
