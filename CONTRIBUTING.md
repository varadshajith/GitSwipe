# GitSwipe Contribution Guidelines

These guidelines define the standards for contributing to the GitSwipe repository. Adherence to these protocols ensures codebase stability and architectural consistency.

---

## Technical Environment Setup

### 1. Prerequisites
- Python 3.11+
- Flutter SDK (Stable Channel)
- PostgreSQL 14+
- Groq API Credentials

### 2. Backend Initialization
```bash
cd backend
python -m venv .venv
source .venv/bin/activate
pip install -e ".[dev]"
cp .env.example .env # Configure local environment variables
alembic upgrade head
uvicorn app.main:app --reload
```

### 3. Frontend Initialization
```bash
cd app
flutter pub get
flutter run
```

---

## Development Protocols

### Branch Management
Utilize the following prefix conventions for all branch names:
- `feature/`: New functional implementations.
- `fix/`: Resolution of identified bugs.
- `agent/`: Modifications to AI logic or LangGraph nodes.
- `design/`: UI/UX and design system updates.

### Commit Standards
Adhere to the [Conventional Commits](https://www.conventionalcommits.org/) specification:
- `feat: [description]`
- `fix: [description]`
- `chore: [description]`
- `docs: [description]`

---

## Implementation Frameworks

### Agent Integration
1.  **Define Models**: Establish Pydantic input/output schemas in `backend/app/schemas/agents/`.
2.  **Logic Implementation**: Define the agent node logic in a dedicated module within `backend/app/agents/`.
3.  **Graph Orchestration**: Integrate the node into the primary state machine in `backend/app/agents/orchestrator.py`.
4.  **Documentation**: Update `AGENTS.md` with the new specification.

### Interface Development (Flutter)
1.  **Module Creation**: Establish a new feature directory in `lib/features/`.
2.  **Component Design**: Implement the UI layer using `StatelessWidget`.
3.  **State Logic**: Implement required Riverpod providers for data synchronization.
4.  **Theme Alignment**: Exclusive use of `GitSwipeTheme` design tokens is required.
5.  **Routing**: Register the module within the application router in `lib/main.dart`.

---

## Quality Assurance

### Testing Procedures
- **Backend**: Execute `pytest` from the `/backend` directory. 
- **Frontend**: Execute `flutter test` from the `/app` directory.

### Pull Request Requirements
- Adherence to language-specific naming conventions (`snake_case` for Python, `camelCase` for Dart).
- Mandatory use of Pydantic schemas for all data transmission.
- Implementation of Riverpod for all state management operations.
- Fulfillment of internal testing benchmarks.
- Verification of architectural alignment as defined in `ARCHITECTURE.md`.
