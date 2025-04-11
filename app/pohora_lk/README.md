# Pohora.lk 🌾

**Pohora.lk** is an intelligent agriculture assistant mobile application built with Flutter that helps farmers make data-driven decisions for crop selection and fertilizer application. Leveraging machine learning algorithms, the app analyzes soil conditions, environmental factors, and crop requirements to provide personalized recommendations.


## 🚀 Features

- **Smart Crop Recommendations**  
  Get AI-powered suggestions for the best crops to plant based on your soil type and environmental conditions.

- **Fertilizer Analysis**  
  Receive personalized fertilizer recommendations to maximize crop yields based on scientific analysis of soil composition.

- **Cultivation Tracking**  
  Monitor your cultivations with detailed logging, tracking fertilizer applications and crop progress.

- **AI Assistance**  
  Get help from our integrated chatbot for agriculture-related questions and guidance.

- **Dark Mode Support**  
  Switch between light and dark themes for comfortable use day and night.

- **User Authentication**  
  Secure login and registration with Firebase Authentication.


## 🛠️ Tech Stack

- **Flutter & Dart**: Cross-platform UI framework  
- **Firebase Authentication**: User authentication and management  
- **BLoC Pattern**: Scalable state management
- **Material Design 3**: Modern UI components  
- **Shared Preferences**: Local data persistence  

## 🧰 Getting Started

### ✅ Prerequisites

- Flutter SDK (3.0.0 or higher)  
- Dart SDK (2.17.0 or higher)  
- Android Studio or VS Code with Flutter extension  
- Android SDK for Android deployment  
- Xcode for iOS deployment  

### 🧪 Installation

1. **Clone the repository**  
    ```bash
    git clone https://github.com/Caramel-Labs/pohora.lk.git
    ```
2. **Navigate to the app directory**
    ```bash
    cd pohora.lk\app\pohora_lk
    ```
3. **Install dependencies**
    ```bash
    flutter pub get
    ```
4. **Configure Firebase**
     - Create a Firebase project
     - Add Flutter app to your Firebase project
5. **Run the app**
    ```bash
    flutter run
    ```


## 🗂️ Project Structure

```pohora_lk/
├── lib/
│   ├── blocs/            # BLoC state management
│   │   ├── auth/         # Authentication bloc
│   │   └── theme/        # Theme management
│   ├── data/             # Data layer
│   │   ├── models/       # Data models
│   │   ├── repositories/ # Data repositories
│   │   └── services/     # API services
│   ├── presentation/     # UI layer
│   │   ├── screens/      # App screens
│   │   └── widgets/      # Reusable widgets
│   ├── routes.dart       # App navigation routes
│   └── main.dart         # Entry point
├── assets/               # Images and other static files
└── test/                 # Unit and widget tests
```
## 📄 License

This project is licensed under the MIT License - see the [LICENSE](../../../LICENSE) file for details.

## 🙏 Acknowledgments
 - The Flutter team for the amazing framework
 - Firebase for authentication and cloud services
 - All our team members and supporters of the project