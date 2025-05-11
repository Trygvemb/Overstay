# OVERSTAY Project

## Overview
OVERSTAY is a full-stack application designed to manage visa-related operations. It is built using modern technologies, including .NET 9.0 for the backend and Flutter for the frontend. The project is containerized using Docker and orchestrated with Docker Compose.

## Features
- Backend API for visa management (CRUD operations)
- Frontend built with Flutter for a responsive user interface
- Microsoft SQL Server database with Full-Text Search capabilities
- Dockerized services for easy deployment and development
- OpenAPI documentation for the backend API

---

## Prerequisites
Ensure the following tools are installed on your system:

For running in Docker:
- Docker
- Bash (for running the `start-dev.sh` script)

For running in local development:
- .NET 9.0 SDK
- Flutter SDK
- Keys and secrets for the database and external services.

---

## Project Structure
- `api/`: Backend API built with .NET 9.0
- `frontend/`: Frontend application built with Flutter
- `docker-compose.yaml`: Configuration for containerized services
- `start-dev.sh`: Script to start the development environment
- `README.md`: Documentation for the project

For more in dept information about the backend and frontend, please refer to the respective directories. Each directory contains its own README file with specific instructions and details.

---

## Setup Instructions

### 1. Clone the Repository
```bash
git clone https://github.com/Trygvemb/Overstay
cd Overstay
```

### 2. Start the Development Environment
Run the following command to start all services:
```bash
docker-compose up --build
```
```bash
./start-dev.sh
```
This script will:
- Start the backend, frontend, and database services using Docker Compose
- Open the backend API and frontend in your default browser

### 3. Access the Application
- **Backend API**: [http://localhost:5050](http://localhost:5050)
- **Backend API Documentation**: [http://localhost:5050/scalar/v1](http://localhost:5050/scalar/v1)
- **Frontend**: [http://localhost:8080](http://localhost:8080)

---

## Backend API
The backend is built with ASP.NET Core and provides endpoints for managing visas. It uses MediatR for CQRS and is containerized for easy deployment.

### Key Files
- `api/src/Overstay.API/Controllers/VisaController.cs`: Contains API endpoints for visa operations.
- `api/Dockerfile`: Dockerfile for building the backend service.
- `api/src/Overstay.API/Program.cs`: Configures the application and its dependencies.

### Running Locally
To run the backend locally:
1. Navigate to the `api/` directory.
2. Run the following commands:
   ```bash
   dotnet restore
   dotnet run
   ```

---

## Frontend
The frontend is a Flutter application designed for a responsive and user-friendly experience.

### Key Files
- `frontend/pubspec.yaml`: Defines dependencies and assets for the Flutter app.
- `frontend/Dockerfile`: Dockerfile for building the frontend service.

### Running Locally
To run the frontend locally:
1. Navigate to the `frontend/` directory.
2. Run the following commands:
   ```bash
   flutter pub get
   flutter run -d chrome
   ```

---

## Database
The project uses Microsoft SQL Server with Full-Text Search capabilities. The database is configured via Docker Compose.

### Key Configuration
- **Image**: `vibs2006/sql_server_fts:latest`
- **Connection String**:
  ```
  Server=mssql_server;Database=Overstay;User Id=sa;Password=Password123!;TrustServerCertificate=True;
  ```

### Starting the Database
The database is automatically started with Docker Compose. To start it manually:
```bash
docker-compose up -d mssql
```

---

## Docker Setup
The project is fully containerized. The `docker-compose.yaml` file defines the following services:
- **mssql**: SQL Server database
- **backend**: .NET API
- **frontend**: Flutter web app

### Build and Start Services
```bash
docker-compose up --build
```

### Stop Services
```bash
docker-compose down
```

---

## Development Notes
- **CORS**: Configured to allow requests from `http://localhost:8080` and `http://localhost:5050`.
- **Authentication**: Uses cookies with secure and lax policies for OAuth redirects.
- **Health Checks**: Configured for backend and frontend services.

---

## Future Enhancements
- Complete the frontend UI based on wireframes.
- Add integration tests for backend and frontend.
- Improve error handling and logging.

---

## Contributors
- **Trygve**: Overstay Development Team
- **Lyanne**: Overstay Development Team
- **Timeline**: April 1 - May 31

For any issues or contributions, please open a pull request or issue in the repository.