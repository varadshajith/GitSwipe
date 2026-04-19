# GitSwipe

## Project Overview

**GitSwipe** is a multi-agent AI-powered GitHub discovery app for developers. It combines Tinder-style swiping with intelligent agent orchestration to help developers discover, understand, and contribute to open-source repositories.

### What It Does

- **Swipe Feed**: Browse AI-curated repository cards with one-tap actions (right=save, left=skip, up=deep dive)
- **AI Summaries**: Every card shows an AI-generated summary of what the repo does, tech stack, and contribution opportunities
- **Preference Learning**: The app learns from your swipes to personalize future recommendations
- **Guide Agent**: Chat with any repository to understand code structure, issues, or contribution pathways
- **Contribute Mode**: Browse "good first issues" ranked by your skill level with AI-powered issue breakdowns
- **PR Draft Helper**: Paste a diff and get a full PR description generated
- **Contribution Tracker**: Kanban board tracking your open source contributions (Exploring → Working On → PR Submitted → Merged)

---

## Tech Stack

### Frontend
- **Flutter/Dart** — Cross-platform mobile app (iOS/Android)
- **Riverpod** — State management
- **Feature-based folder structure** — Screens, widgets, and logic co-located by feature

### Backend
- **Python 3.11+** — Core language
- **FastAPI** — Async web framework
- **Pydantic v2** — Request/response validation and serialization
- **APScheduler** — Background job scheduling (runs inside FastAPI process)
- **PostgreSQL** — Primary database (user profiles, swipe history, saved repos, contribution tracker)

### AI/ML Layer
- **LangGraph** — Agent orchestration and state management
- **LangChain** — LLM tool integration and chaining
- **Groq API** — LLM inference (fast, cheap)
  - `llama-3.3-70b-versatile` — Heavy tasks (Explainer deep dives, Guide conversations, PR Draft generation)
  - `llama-3.1-8b-instant` — Fast/cheap tasks (Ranker scoring, card summaries)
- **HuggingFace sentence-transformers/all-MiniLM-L6-v2** — Local embeddings (fully local, zero API cost)
- **ChromaDB** — V1 vector database (local, file-based)
- **Pinecone** — V2 vector database (free tier, serverless)

### External APIs
- **GitHub REST API v3** — Repository data, issues, user profile

### Deployment
- **Railway** or **Render** — Backend and database hosting

---

## Monorepo Structure

```
/home/vsv/CODE/Learning/GitSwipe/
├── CLAUDE.md              # This file — project context for Claude Code
├── README.md              # Public-facing project documentation
├── ARCHITECTURE.md        # Deep technical documentation
├── DESIGN_SYSTEM.md       # UI/UX specifications
├── AGENTS.md              # Agent reference documentation
├── CONTRIBUTING.md        # Contribution guidelines
├── ROADMAP.md             # V1/V2/V3 feature roadmap
├── .cursorrules           # Cursor AI rules
│
├── app/                   # Flutter frontend
│   ├── lib/
│   │   ├── main.dart
│   │   ├── features/
│   │   │   ├── auth/          # GitHub OAuth
│   │   │   ├── feed/          # Swipe feed
│   │   │   ├── explore/       # Deep dive / Explainer
│   │   │   ├── guide/         # Guide chat
│   │   │   ├── contribute/    # Good first issues
│   │   │   ├── tracker/       # Contribution Kanban
│   │   │   └── profile/       # User preferences
│   │   ├── shared/            # Reusable widgets, themes, utils
│   │   └── providers/         # Riverpod providers
│   ├── pubspec.yaml
│   └── test/
│
└── backend/               # Python FastAPI backend
    ├── pyproject.toml
    ├── alembic/             # Database migrations
    ├── app/
    │   ├── main.py          # FastAPI entry point
    │   ├── config.py        # Settings / env vars (Pydantic)
    │   ├── models/          # SQLAlchemy models
    │   ├── schemas/         # Pydantic request/response schemas
    │   ├── routers/         # API endpoint modules
    │   ├── agents/          # LangGraph agents
    │   ├── services/        # Business logic
    │   ├── jobs/            # APScheduler background jobs
    │   └── db/              # Database connection, Chroma client
    └── tests/
```

---

## Local Development

### Prerequisites
- Python 3.11+
- Flutter SDK (latest stable)
- PostgreSQL 14+
- Git

### Backend Setup

```bash
cd backend
python -m venv .venv
source .venv/bin/activate  # Windows: .venv\Scripts\activate
pip install -e ".[dev]"

# Create database
createdb gitswipe

# Copy environment file
cp .env.example .env
# Edit .env with your values

# Run migrations
alembic upgrade head

# Start development server
uvicorn app.main:app --reload
```

### Frontend Setup

```bash
cd app
flutter pub get
cp .env.example .env
# Edit .env with backend URL

# Run on device/emulator
flutter run
```

---

## Environment Variables

Create `.env` files in both `/app` and `/backend` directories. **Never commit `.env` files.**

### Backend Variables

| Variable | Description | Required |
|----------|-------------|----------|
| `DATABASE_URL` | PostgreSQL connection string | Yes |
| `GITHUB_CLIENT_ID` | GitHub OAuth app ID | Yes |
| `GITHUB_CLIENT_SECRET` | GitHub OAuth app secret | Yes |
| `GROQ_API_KEY` | Groq API key | Yes |
| `PINECONE_API_KEY` | Pinecone API key (V2 only) | No |
| `PINECONE_INDEX_NAME` | Pinecone index name | No |
| `CHROMA_PERSIST_DIR` | ChromaDB persistence directory | Yes |
| `JWT_SECRET` | JWT signing key | Yes |
| `JWT_ALGORITHM` | JWT algorithm (default: HS256) | No |
| `APP_ENV` | development/staging/production | No |
| `LOG_LEVEL` | DEBUG/INFO/WARNING/ERROR | No |
| `GITHUB_API_TOKEN` | Personal access token for API calls | Yes |

### Frontend Variables

| Variable | Description | Required |
|----------|-------------|----------|
| `API_BASE_URL` | Backend URL (http://localhost:8000) | Yes |
| `GITHUB_CLIENT_ID` | Same as backend OAuth ID | Yes |

---

## Key Architectural Decisions

### Why LangGraph over vanilla LangChain

LangGraph provides explicit state management and conditional edges that model agent workflows more accurately than simple chains. Our agents have branching logic (e.g., "if repo has CONTRIBUTING.md, read it; else skip"), loops (chat turns), and parallel execution (Scout's multiple search vectors). LangGraph's graph structure makes these control flows explicit and testable.

### Why Groq over OpenAI

Groq offers 5-10x lower latency at 10x lower cost for the same model quality. We process thousands of repositories; OpenAI costs would be prohibitive. The `llama-3.3-70b-versatile` model matches GPT-4 quality for our use case (code summarization, PR drafting) at $0.90 per 1M tokens vs $30 per 1M tokens.

### Why Local Sentence Transformers

Embeddings are compute-heavy but not quality-sensitive. Running `all-MiniLM-L6-v2` locally means:
- Zero API cost for embedding storage
- Zero latency on embed operations
- Full offline capability for the Scout agent
- Privacy (repo content never leaves the server)

The model is 22MB and runs comfortably on CPU.

### Why Pre-computed Feed via Background Job

The swipe feed is pre-computed twice daily, not live-queried, because:
- GitHub API rate limits (5000/hour) cannot support on-demand feed generation for all users
- Personalized ranking requires heavy LLM calls that would add 5-10s latency per feed load
- Users expect instant swipe; pre-computation gives <100ms feed response
- Feed freshness is acceptable at 12-hour intervals

### Why ChromaDB for V1

ChromaDB's file-based persistence requires zero infrastructure setup and works locally out of the box. For V1 with <1000 repos, it's sufficient. Pinecone migration in V2 provides serverless scaling when we exceed Chroma's single-node limitations.

---

## The Four Agents + Orchestrator

### 1. Scout Agent
**Purpose**: Discovers repositories matching user interests.

**Search Vectors** (can run in parallel):
- Topic-based (e.g., "machine-learning", "react")
- Organization-based (repos from orgs the user starred)
- Dependency-based (repos using similar tech stack)
- Recent low-star repos (under 500 stars, active commits)
- Good-first-issue label
- Star velocity (trending repos)

**Output**: List of repository candidates with metadata (name, owner, star count, topics, last pushed).

### 2. Ranker Agent
**Purpose**: Scores and ranks candidates by relevance to user's preference profile.

**Input**: Scout's candidate list + user's preference profile.

**Scoring**:
- Mathematical pre-filter (star count bounds, language match, activity recency)
- LLM-based relevance scoring (`llama-3.1-8b-instant` for speed)
- Preference profile weights applied

**Output**: Ranked list, top 20 sent to feed.

### 3. Explainer Agent
**Purpose**: Generates human-readable summaries of repositories.

**Reads**:
- README (chunked if long)
- File tree structure
- Open issues (sample)
- CONTRIBUTING.md (if exists)

**Output**:
- **Card summary**: 2-3 sentences for feed card
- **Deep dive**: Full structured summary with tech stack, contribution opportunities, complexity assessment

### 4. Guide Agent
**Purpose**: Conversational interface to understand any repository.

**Tools**:
- `fetch_file` — Read specific file content
- `search_issues` — Query open/closed issues
- `find_similar_repos` — Semantic search in vector DB

**Memory**:
- Session memory (current conversation context)
- Cross-session memory (learned about user's skill level, preferred explanation depth)

**Output**: Natural language responses with citations to files/issues.

### Orchestrator (LangGraph)

The orchestrator manages agent state and flow:

- **Feed Generation Flow**: Trigger background job → Scout → (parallel) Ranker → Explainer (card summaries) → Store in DB
- **Repo Open Flow**: User opens repo → Explainer (deep dive if not cached) → Return structured data
- **Guide Flow**: User message → RAG retrieval → Guide agent with context → Stream response

---

## Coding Conventions

### Python (Backend)

**Use `snake_case` for everything.**

**Async everywhere**: All I/O operations (DB, HTTP, LLM calls) must use `async/await`. No blocking calls in request handlers.

**Pydantic for all request/response shapes**:

```python
# GOOD
class SwipeRequest(BaseModel):
    repo_id: str
    action: Literal["save", "skip", "deep_dive"]

# BAD
def swipe(request: dict):  # No raw dicts!
    repo_id = request.get("repo_id")
```

**No raw `dict` in business logic**: Convert to Pydantic models at the boundary.

**Type hints everywhere**: Enable `strict` mypy checking.

**Agent return types**: Always return structured output models, not strings.

### Flutter (Frontend)

**Feature-based folder structure**:

```
lib/features/feed/
├── feed_screen.dart
├── feed_controller.dart      # Riverpod
├── widgets/
│   ├── swipe_card.dart
│   └── action_buttons.dart
└── models/
    └── repo_card_model.dart
```

**Riverpod for state management**: No StatefulWidget business logic. Keep widgets stateless, put logic in providers.

**Stateless widgets where possible**: Prefer `StatelessWidget` + Riverpod over `StatefulWidget`.

**API client**: Centralized Dio instance with interceptors for auth tokens.

**Error handling**: Global error boundary + snackbar notifications via Riverpod.

---

## What NOT To Do

### Backend

- **Never call GitHub API directly from HTTP endpoints** — Only background jobs call GitHub. Endpoints read from DB/cache.
- **Never store plain text secrets** — Use environment variables only.
- **Never block the event loop** — Always use `async` for I/O.
- **Never return raw SQLAlchemy models from routers** — Always convert to Pydantic schemas.
- **Never hardcode model names** — Use constants from `config.py`.

### Frontend

- **Never put API keys in client code** — Use backend proxy for all authenticated APIs.
- **Never use `setState` for shared state** — Use Riverpod.
- **Never hardcode colors** — Use theme from `Theme.of(context)`.

### Agents

- **Never call LLM without timeout/retry** — Wrap all LLM calls with tenacity.
- **Never store full repo content in graph state** — Use summaries and references.
- **Never expose raw LLM errors to users** — Catch and return friendly messages.

---

## Testing

### Backend
- **pytest** for unit tests
- **pytest-asyncio** for async test support
- **Factory Boy** for test data generation
- **Test coverage target**: 80%+

### Frontend
- **widget_test** for widget testing
- **integration_test** for end-to-end flows
- **Mockito** for HTTP mocking

---

## Deployment

### Railway (Recommended)

1. Connect GitHub repo to Railway
2. Add PostgreSQL plugin
3. Set environment variables in Railway dashboard
4. Deploy `backend/` directory

### Render

1. Create new Web Service
2. Point to `backend/` directory
3. Add PostgreSQL managed database
4. Set environment variables

### Database Migrations

Run `alembic upgrade head` as the release command in your deployment pipeline.

---

## Debugging

### Enable verbose logging

```python
# In app/config.py or via env
LOG_LEVEL=DEBUG
```

### LangGraph tracing

Set `LANGCHAIN_TRACING_V2=true` to enable LangSmith tracing for agent debugging.

### Local Chroma inspection

```python
from app.db.chroma import client
collection = client.get_collection("repos")
collection.peek()  # View sample documents
```

---

## Getting Help

- Check `ARCHITECTURE.md` for detailed system flows
- Check `AGENTS.md` for agent-specific documentation
- Check `CONTRIBUTING.md` for development workflow
- Check `ROADMAP.md` for feature status

---

*Last updated: 2026-04-19*
