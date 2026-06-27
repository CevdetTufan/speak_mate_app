# SpeakMate

SpeakMate is a smart AI assistant application supporting voice commands and Speech-to-Text capabilities. This project brings together a **Flutter** (Mobile Client) and **.NET 10 gRPC** (Server) architecture in a unified monorepo.

## Architecture & Folder Structure

The project is structured as a Monorepo:

- **`src/SpeakMate.Client/`**
  - The mobile frontend built with Flutter. It records audio and streams the voice data (or transcribed text) to the server via gRPC.
- **`src/SpeakMate.Contracts/`**
  - The shared library that contains the `speech_analysis.proto` file and related C#/.NET helper classes. It defines the communication schema between the Flutter Client and the .NET Server.
- **`src/SpeakMate.Server/`**
  - A high-performance, gRPC-powered .NET 10 backend application. It receives audio streams from the Flutter client, processes them via an AI engine (Mock or real integrations like OpenAI), and streams the results back to the client.
- **`tests/`**
  - Contains xUnit test projects to ensure the backend logic works correctly.

## Getting Started

### 1. Running the Server (Backend)
The backend runs on .NET 10.
```bash
# Navigate to the backend folder or run the solution from the root
dotnet run --project src/SpeakMate.Server/SpeakMate.Server.csproj
```
*(The server will typically start on a default port like `localhost:5001` or `localhost:5000`.)*

### 2. Running the Client (Flutter)
Before running the Flutter app, ensure you install all dependencies.
*Note: If you make changes to the `.proto` files in the future, you will need to regenerate the Dart gRPC code using the `protoc` tool.*
```bash
cd src/SpeakMate.Client
flutter pub get
flutter run
```

## Technologies Used
- **Frontend:** Dart, Flutter, `speech_to_text`, `grpc`, `protobuf`
- **Backend:** C#, .NET 10, gRPC (`Grpc.AspNetCore`)
- **Communication:** HTTP/2 (gRPC) & Protocol Buffers
