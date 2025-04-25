#!/bin/bash

# Start Docker services
docker-compose up -d

# Wait a moment for services to fully start
echo "Starting services, please wait..."
sleep 10

# Open browser tabs
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    open http://localhost:5050/scalar/v1
    open http://localhost:8080/
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    xdg-open http://localhost:5050/scalar/v1
    xdg-open http://localhost:8080/
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    # Windows with Git Bash or similar
    start http://localhost:5050/scalar/v1
    start http://localhost:8080/
else
    echo "Could not detect OS for opening browser automatically."
    echo "Please open these URLs manually:"
    echo "  http://localhost:5050/scalar/v1"
    echo "  http://localhost:8080/"
fi

# Continue showing logs
docker-compose logs -f