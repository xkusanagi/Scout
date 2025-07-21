# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Open WebUI is a comprehensive, self-hosted web interface for AI language models that supports multiple LLM providers including Ollama, OpenAI-compatible APIs, and more. It's built with a **FastAPI backend** and **SvelteKit frontend**, designed to operate entirely offline with extensive RAG capabilities.

## Architecture

### Backend (Python/FastAPI)
- **Main entry point**: `backend/open_webui/main.py` - FastAPI application with extensive middleware and routing
- **Database layer**: Uses SQLAlchemy with Alembic migrations, supports PostgreSQL, MySQL, and SQLite
- **API routers**: Modular router structure in `backend/open_webui/routers/` (auth, chats, models, retrieval, etc.)
- **Models**: Database models in `backend/open_webui/models/` 
- **Core utilities**: `backend/open_webui/utils/` for auth, chat processing, embeddings, middleware
- **Configuration**: Centralized config in `backend/open_webui/config.py` with extensive environment variable support

### Frontend (SvelteKit)
- **Main app**: SvelteKit SPA with static adapter
- **Routes**: File-based routing in `src/routes/`
- **Components**: Reusable components in `src/lib/components/`
- **Stores**: State management in `src/lib/stores/`
- **Types**: TypeScript definitions in `src/lib/types/`
- **Workers**: Web workers for Pyodide and audio processing

### Key Features Architecture
- **RAG Integration**: Built-in document processing with multiple embedding engines (OpenAI, Ollama, Sentence Transformers)
- **Multi-modal Support**: Image generation (AUTOMATIC1111, ComfyUI), audio processing (TTS/STT)
- **Plugin System**: Pipelines framework for custom logic and Python libraries
- **WebSocket Support**: Real-time features via Socket.IO
- **Code Execution**: Jupyter integration for Python code execution

## Development Commands

### Frontend Development
```bash
# Install dependencies
npm install

# Development server with hot reload
npm run dev

# Development on custom port
npm run dev:5050

# Build for production
npm run build

# Build with watch mode
npm run build:watch

# Preview production build
npm run preview
```

### Code Quality & Testing
```bash
# Run all linting (frontend + backend + types)
npm run lint

# Frontend linting with ESLint
npm run lint:frontend

# Type checking with Svelte
npm run lint:types

# Backend linting with Pylint
npm run lint:backend

# Format code with Prettier
npm run format

# Format backend code with Black
npm run format:backend

# Frontend tests with Vitest
npm run test:frontend

# End-to-end tests with Cypress
npm run cy:open
```

### Backend Development
```bash
# Start backend development server
cd backend && ./start.sh

# Or for Windows
cd backend && start_windows.bat

# Install Python dependencies
pip install -r backend/requirements.txt

# Run with Python directly
cd backend && python -m uvicorn open_webui.main:app --reload --host 0.0.0.0 --port 8080
```

### Docker Development
```bash
# Start with Docker Compose
make install
# or
docker-compose up -d

# Start and build
make startAndBuild

# Stop services
make stop

# Update and rebuild
make update
```

### Database Migrations
Database migrations are handled by Alembic. Migration files are in `backend/open_webui/migrations/`.

## Configuration

The application uses extensive environment variable configuration. Key config areas:

- **Database**: `DATABASE_URL`, database type selection
- **Authentication**: JWT settings, OAuth providers, LDAP integration  
- **AI Models**: Ollama URLs, OpenAI API keys, model configurations
- **RAG/Retrieval**: Embedding models, vector database settings, chunk sizes
- **Features**: Enable/disable web search, image generation, code execution
- **File Handling**: Upload limits, allowed extensions, compression settings

Configuration is centralized in `backend/open_webui/config.py` with validation and type safety.

## Key Development Considerations

### State Management
- Backend uses FastAPI's app.state for global application state
- Frontend uses Svelte stores for reactive state management
- WebSocket integration for real-time features

### Security
- JWT-based authentication with role-based access control (RBAC)
- API key support with endpoint restrictions
- Input validation and sanitization throughout
- CORS configuration for cross-origin requests

### Performance
- Lazy loading of models and embeddings
- Caching layer with Redis support
- Background task processing
- Connection pooling for databases

### Plugin Architecture
- Pipelines framework for extending functionality
- Tool and function system for custom integrations
- External service connectors (web search, document processing)

## Testing

- Frontend: Vitest for unit tests, Cypress for E2E
- Backend: Pytest with Docker integration
- Test files in `test/` directory and `cypress/` for E2E tests

## Build Process

The build process combines frontend and backend:
1. Frontend builds to static files in `build/` directory
2. Backend serves frontend as static files from FastAPI
3. Production deployments can use the built-in container or pip installation