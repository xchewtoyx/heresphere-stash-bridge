# HereSphere Stash Bridge

A bridge service that connects HereSphere VR video player with Stash media server, enabling seamless content management and playback.

## Features

- RESTful API for bridging HereSphere and Stash
- Health monitoring and status endpoints
- Configuration management
- Comprehensive testing suite
- Development and production ready

## Quick Start

### Development Setup

1. Clone the repository:
```bash
git clone https://github.com/xchewtoyx/heresphere-stash-bridge.git
cd heresphere-stash-bridge
```

2. Run the development setup script:
```bash
chmod +x setup-dev.sh
./setup-dev.sh
```

3. Activate the virtual environment:
```bash
source venv/bin/activate
```

4. Configure your environment:
```bash
cp .env.example .env
# Edit .env with your specific settings
```

5. Start the development server:
```bash
python run.py
```

The server will be available at `http://localhost:5000`

### Manual Installation

If you prefer to set up manually:

```bash
# Create and activate virtual environment
python3 -m venv venv
source venv/bin/activate

# Install dependencies
pip install -r requirements-dev.txt

# Install in development mode
pip install -e .

# Run the application
python run.py
```

## Configuration

The application can be configured through environment variables or a `.env` file:

- `FLASK_ENV`: Environment (development, production, testing)
- `SECRET_KEY`: Flask secret key
- `HERESPHERE_HOST`: HereSphere server host
- `HERESPHERE_PORT`: HereSphere server port
- `STASH_HOST`: Stash server host
- `STASH_PORT`: Stash server port
- `STASH_API_KEY`: Stash API key
- `BRIDGE_HOST`: Bridge server host
- `BRIDGE_PORT`: Bridge server port

## API Endpoints

- `GET /` - Basic service information
- `GET /health` - Health check
- `GET /api/bridge/status` - Bridge connection status
- `GET /api/heresphere/library` - HereSphere library content
- `GET /api/stash/scenes` - Stash scenes
- `POST /api/bridge/sync` - Sync content between services

## Testing

Run the test suite:

```bash
pytest
```

Run with coverage:

```bash
pytest --cov=heresphere_stash_bridge --cov-report=html
```

## Development

### Code Quality

The project uses several tools for code quality:

- **Black**: Code formatting
- **Flake8**: Linting
- **isort**: Import sorting
- **mypy**: Type checking

Run all quality checks:

```bash
black src/ tests/
isort src/ tests/
flake8 src/ tests/
mypy src/
```

### Project Structure

```
heresphere-stash-bridge/
├── src/heresphere_stash_bridge/    # Main application package
│   ├── __init__.py                 # Application factory
│   ├── routes.py                   # API routes
│   └── cli.py                      # CLI interface
├── tests/                          # Test suite
├── config/                         # Configuration files
├── templates/                      # Flask templates (if needed)
├── static/                         # Static files (if needed)
├── requirements.txt                # Production dependencies
├── requirements-dev.txt            # Development dependencies
├── pyproject.toml                  # Project configuration
├── .env.example                    # Environment template
├── setup-dev.sh                    # Development setup script
├── run.py                          # Development server
└── wsgi.py                         # Production WSGI entry point
```

## Production Deployment

### Using Gunicorn

```bash
pip install -r requirements.txt
pip install gunicorn
gunicorn --bind 0.0.0.0:5000 wsgi:application
```

### Using Docker

#### Production Deployment

```bash
# Build the image
docker build -t heresphere-stash-bridge .

# Run the container
docker run -d \
  --name heresphere-stash-bridge \
  -p 5000:5000 \
  -e SECRET_KEY=your-secret-key \
  -e HERESPHERE_HOST=your-heresphere-host \
  -e STASH_HOST=your-stash-host \
  -e STASH_API_KEY=your-stash-api-key \
  heresphere-stash-bridge
```

#### Docker Compose Development

```bash
# Start all services (includes mock services)
docker-compose up -d

# Start only the development version
docker-compose -f docker-compose.dev.yml up -d

# View logs
docker-compose logs -f heresphere-stash-bridge

# Stop services
docker-compose down
```

#### Build and Push to Docker Hub

```bash
# Make the build script executable
chmod +x docker-build.sh

# Build and push (update username in script first)
./docker-build.sh v1.0.0 true
```

## CI/CD Pipeline

The project uses GitHub Actions for continuous integration and deployment:

- **Tests**: Run on Python 3.9, 3.10, 3.11, and 3.12
- **Code Quality**: Linting, formatting, and type checking
- **Security**: Vulnerability scanning and static analysis
- **Docker**: Multi-architecture builds (AMD64 + ARM64)
- **Auto-Release**: Tags trigger automatic releases

### Workflows

- `test.yml` - Comprehensive test suite
- `ci-cd.yml` - Main CI/CD pipeline
- `docker.yml` - Docker build and push
- `quality.yml` - Code quality and security scans
- `dependencies.yml` - Automated dependency updates

### Setup GitHub Secrets

Run the setup guide:
```bash
chmod +x github-secrets-setup.sh
./github-secrets-setup.sh
```

Required secrets:
- `DOCKERHUB_USERNAME` - Your Docker Hub username
- `DOCKERHUB_TOKEN` - Docker Hub access token

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Ensure all tests pass (GitHub Actions will run automatically)
6. Submit a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Roadmap

- [ ] HereSphere API integration
- [ ] Stash GraphQL API integration
- [ ] Content synchronization
- [ ] Authentication and authorization
- [ ] Docker containerization
- [ ] Configuration management UI
- [ ] Logging and monitoring
- [ ] Performance optimizations
