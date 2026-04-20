# GitSwipe — Master Task List

> **Status Legend**: `[ ]` Todo · `[/]` In Progress · `[x]` Done · `[-]` Blocked

---

## 📦 Phase 0 — Project Bootstrap

### Environment & Tooling
- [x] Initialize Git repository and push to GitHub
- [x] Create Python virtual environment (`uv` or `venv`)
- [ ] Set up `pyproject.toml` with all backend dependencies (FastAPI, LangGraph, SQLAlchemy, APScheduler, Pydantic, ChromaDB, httpx, etc.)
- [x] Set up `.env` structure and `python-dotenv` loading
- [/ ] Configure `pre-commit` hooks (ruff, black, mypy)
- [ ] Add `.gitignore` for Python, Node, `.env`, `__pycache__`, `chroma_db/`

### Frontend Scaffold
- [x] Scaffold frontend project (Flutter) – created in ./mobile
- [ ] Install Inter variable font via Google Fonts
- [ ] Create base CSS design tokens matching `DESIGN_SYSTEM.md` (colors, radii, shadows, typography)
- [ ] Implement glassmorphism utility classes / CSS variables
- [ ] Set up animation constants (`cubic-bezier(0.2, 0.0, 0.0, 1.0)`, spring curves)

### CI/CD Foundation
- [ ] Add GitHub Actions workflow for linting and type-checking (backend)
- [ ] Add GitHub Actions workflow for frontend build validation
- [ ] Create `docker-compose.yml` for local development (PostgreSQL, backend, frontend)

---

## 🔐 Phase 1A — Authentication

### Backend
- [ ] Register GitHub OAuth App and obtain `CLIENT_ID` / `CLIENT_SECRET`
- [ ] Implement `/auth/github/login` redirect endpoint
- [ ] Implement `/auth/github/callback` endpoint to exchange code for access token
- [ ] Store GitHub access token securely (encrypted at rest in PostgreSQL)
- [ ] Implement JWT session token issuance post-OAuth
- [ ] Add auth middleware to protect all `/api/v1/*` routes
- [ ] Define scope requirements (`read:user`, `public_repo`)

### Database
- [ ] Design and create `users` table (id, github_id, username, avatar_url, access_token_encrypted, created_at)
- [ ] Design and create `preference_profiles` table (JSON column for `PreferenceProfile` object)
- [ ] Set up Alembic for database migrations
- [ ] Run initial migration to create schema

### Frontend
- [ ] Build Login / Landing page with GitHub OAuth button
- [ ] Implement token storage (httpOnly cookie or secure localStorage)
- [ ] Add auth guard / redirect logic for protected routes
- [ ] Build minimal user avatar + logout component in nav bar

---

## 🔍 Phase 1B — Scout Agent V1

### GitHub API Client
- [ ] Create reusable `GitHubClient` class (async httpx, rate-limit aware)
- [ ] Implement rate limit detection and exponential backoff
- [ ] Implement fallback to cached trending results on rate limit (per AGENTS.md)
- [ ] Write unit tests for the GitHub API client

### Search Vectors (V1 — first 3)
- [ ] Implement **Topic-centric** search vector (`/search/repositories?q=topic:{keyword}`)
- [ ] Implement **Organizational** search vector (repos from starred/explored orgs)
- [ ] Implement **Momentum-based** (star velocity) search vector
- [ ] Integrate all three vectors into a parallel execution block (asyncio.gather / LangGraph parallel node)
- [ ] Implement result deduplication logic by `repo_id`
- [ ] Define `RepositoryCandidate` Pydantic model (id, name, description, stars, language, topics, readme_url, etc.)

---

## 📊 Phase 1C — Heuristic Ranker

- [ ] Define `PreferenceProfile` Pydantic model (matching ARCHITECTURE.md JSON spec)
- [ ] Implement heuristic scoring function:
  - [ ] Growth rate score (star velocity)
  - [ ] Commit frequency score
  - [ ] Language overlap score vs. `technical_stack`
  - [ ] Filter gate for `min_stars`, `max_stars`, `license`
- [ ] Normalize and combine sub-scores into a single `heuristic_score` (0–100)
- [ ] Write unit tests for the scoring function with edge cases

---

## 📝 Phase 1D — Explainer Agent V1

- [ ] Set up Groq API client with `llama-3.3-70b-versatile`
- [ ] Implement README fetcher (raw GitHub content API)
- [ ] Implement **Map phase**: chunk README into 1000-token segments
- [ ] Implement **Reduce phase**: combine chunk summaries into final output
- [ ] Define output schema: `card_summary` (≤200 chars) + `deep_dive` (Markdown)
- [ ] Wire Explainer into LangGraph as a post-ranking node
- [ ] Write integration test: given a repo URL, assert `card_summary` is non-empty

---

## 🗃️ Phase 1E — Feed Persistence & Core API

### Database
- [ ] Design and create `repositories` table (id, github_id, name, description, stars, language, topics, card_summary, deep_dive, scored_at)
- [ ] Design and create `feed_items` table (user_id, repo_id, score, status: [pending/saved/skipped], created_at)
- [ ] Run Alembic migration

### API Endpoints
- [ ] Implement `GET /api/v1/feed` — return ordered list of pending feed cards for user
- [ ] Implement `POST /api/v1/feed/action` — accept `{repo_id, action: "save"|"skip"|"explore"}` and persist
- [ ] Implement `GET /api/v1/exploration/{repo_id}` — return deep-dive metadata
- [ ] Add pagination / cursor support to feed endpoint

### Background Jobs (APScheduler)
- [ ] Set up APScheduler within FastAPI lifespan context
- [ ] Register **Feed Ingestion** job (12-hour interval): Scout → Filter → Rank → Explain → Persist
- [ ] Register **Metadata Refresh** job (24-hour interval): sync star counts and commit data for saved repos

---

## 🎨 Phase 1F — Frontend MVP

### Feed View
- [x] Build `RepoCard` component:
  - [x] Glassmorphic card with `24px` border radius and multi-layer shadow
  - [x] Display: repo name, card summary, language chip, star count, topics
  - [x] Swipe gesture handling (touch + mouse drag)
  - [x] Save (✓) / Skip (✗) floating action buttons with `0.95` scale-on-press
  - [x] Haptic feedback trigger on action (mobile)
- [x] Build card stack / feed container with staggered entrance animation
- [x] Implement infinite scroll / auto-load next batch when feed < 3 cards
- [x] Connect feed to `GET /api/v1/feed` and `POST /api/v1/feed/action`

### Exploration / Deep-Dive View
- [ ] Build `RepoDetailModal` or page with rendered Markdown deep-dive
- [ ] Add "Open on GitHub" external link button
- [ ] Show language, star count, license, topics as metadata chips

### Navigation
- [ ] Implement bottom nav bar (semi-transparent, blur backdrop)
  - [ ] Feed tab
  - [ ] Saved repos tab
  - [ ] Profile / Settings tab
- [ ] Add active state indicator (weight change + muted accent bar)

### Saved Repos View
- [ ] Build saved repositories list/grid view
- [ ] Allow un-saving a repo from this view

---

## 🧠 Phase 2A — LLM-Driven Ranker

- [ ] Replace / augment heuristic ranker with `llama-3.1-8b-instant` scoring
- [ ] Implement Ranker prompt template (per AGENTS.md)
- [ ] Define Pydantic output schema: `{score: int, justification: str}`
- [ ] Implement hybrid scoring: `(heuristic * 0.30) + (llm_score * 0.70)`
- [ ] Add retry logic for Groq API failures
- [ ] Benchmark scoring throughput (target: process 50 candidates in < 30s)

---

## 📚 Phase 2B — Explainer Agent V2

- [ ] Extend Explainer output with full `Technical Deep-Dive`:
  - [ ] Tech stack identification
  - [ ] Core logic entry points
  - [ ] Contribution difficulty assessment
  - [ ] Key file map
- [ ] Include `CONTRIBUTING.md` and file tree as additional context inputs
- [ ] Include recent GitHub Issues as supplementary input
- [ ] Update `repositories` table with new deep-dive columns

---

## 🔗 Phase 2C — RAG Infrastructure

### Embedding Pipeline
- [ ] Integrate `sentence-transformers` with `all-MiniLM-L6-v2` model (local)
- [ ] Implement chunking strategy: 1000-token windows, 200-token overlap
- [ ] Build `embed_repository` job: fetch README + source files → chunk → embed → store
- [ ] Set up ChromaDB with filesystem persistence at `./chroma_db/`
- [ ] Create ChromaDB collection per repository (keyed by `repo_id`)

### Semantic Search API
- [ ] Implement `semantic_vector_search(query, repo_id, k=5)` tool function
- [ ] Add `POST /api/v1/tools/embed/{repo_id}` endpoint to trigger embedding on demand

---

## 💬 Phase 2D — Guide Agent V1

### Backend
- [ ] Implement `WS /api/v1/chat/{repo_id}` WebSocket endpoint
- [ ] Build Guide agent LangGraph graph:
  - [ ] Retrieval node: semantic search for query
  - [ ] Inference node: `llama-3.3-70b-versatile` with system prompt
  - [ ] Tool execution node (max 5 loops — per AGENTS.md safety rule)
- [ ] Implement tools:
  - [ ] `fetch_file_content(repo_id, file_path)` — GitHub raw content
  - [ ] `query_project_issues(repo_id, query)` — GitHub Issues search
  - [ ] `semantic_vector_search(query, repo_id)` — ChromaDB lookup
- [ ] Implement streamed response output (Server-Sent Events or WS chunking)
- [ ] Store user skill level in `preference_profiles` for depth calibration

### Frontend
- [ ] Build chat drawer / panel on the `RepoDetailModal`
- [ ] Implement WebSocket connection manager hook
- [ ] Render streamed Markdown responses with source citations
- [ ] Add typing indicator during inference

---

## 🎯 Phase 2E — Contribute Mode

- [ ] Fetch open `good-first-issue` labelled issues via GitHub API
- [ ] Build issue scoring function: complexity vs. user skill level
- [ ] Rank issues from saved repos by match score
- [ ] Build **Contribute Mode** feed view (same card UX, issue-focused)
- [ ] Implement **Issue Decomposition**: AI analysis of issue body → prerequisites + complexity summary
- [ ] Add "I'll work on this" action → bookmark issue, open on GitHub

---

## ⚖️ Phase 2F — Adaptive Preference Weights

- [ ] Track all `save`, `skip`, `explore` events with timestamps in `feed_items`
- [ ] Register **Weight Sync** APScheduler job (trigger: every 5 interactions)
- [ ] Build weight update algorithm:
  - [ ] Extract topic/language signals from saved/explored repos
  - [ ] Decay weights for topics of skipped repos
  - [ ] Apply normalized delta to `engagement_vectors` in `PreferenceProfile`
- [ ] Expose `GET /api/v1/profile` to return current profile weights
- [ ] Build profile visualization UI (radar chart or tag-weight display)

---

## 📄 Phase 2G — PR Description Generator

- [ ] Implement `POST /api/v1/tools/generate-pr` endpoint
- [ ] Accept: `git diff` text + optional repo context
- [ ] Build prompt: summarize changes, infer intent, format as PR description
- [ ] Return structured PR Markdown (title, summary, changes list, testing notes)
- [ ] Build UI: paste diff input + rendered PR output with copy button

---

## ☁️ Phase 3A — Distributed Vector Persistence

- [ ] Create Pinecone account and index
- [ ] Abstract vector DB behind a `VectorStore` interface (ChromaDB & Pinecone implementations)
- [ ] Implement migration script: export ChromaDB vectors → import to Pinecone
- [ ] Update all semantic search calls to use Pinecone in production
- [ ] Performance test: compare query latency (ChromaDB local vs. Pinecone cloud)

---

## 🚀 Phase 3B — CI/CD & Cloud Deployment

- [ ] Containerize backend with production `Dockerfile` (multi-stage build)
- [ ] Containerize frontend with production `Dockerfile`
- [ ] Write `docker-compose.prod.yml` with Postgres, backend, frontend services
- [ ] Choose cloud target (Railway / Render / GCP Cloud Run / AWS ECS)
- [ ] Configure environment secrets management (e.g., GCP Secret Manager)
- [ ] Set up GitHub Actions deployment pipeline:
  - [ ] On push to `main`: run tests → build Docker images → push to registry → deploy
- [ ] Set up health check endpoint `GET /api/v1/health`
- [ ] Configure domain and TLS (Cloudflare / Let's Encrypt)

---

## 🔭 Phase 3C — Advanced Scout Vectors

- [ ] Implement **Technographic** vector: dependency graph analysis (package overlap)
- [ ] Implement **Emergent (Low-Star Active)** vector: high-activity, low-star filter
- [ ] Implement **Contributor-focused** vector: `good-first-issue` label count threshold
- [ ] Integrate new vectors into parallel Scout LangGraph node
- [ ] Update deduplication and filtration logic to handle higher candidate volumes

---

## 🧬 Phase 3D — Persistent Agent Memory

- [ ] Design `agent_memory` table (user_id, repo_id, session_summary, skill_snapshot, updated_at)
- [ ] Implement session summarization after Guide chat ends (compress context window → store)
- [ ] Load prior session summary as prefix context on Guide reconnect
- [ ] Add **Profile Override** mode: temporary session context for ad-hoc exploration (not persisted to weights)

---

## 🔄 Phase 3E — Automated Lifecycle Sync

- [ ] Register GitHub Webhook for watched repositories (PR open/close, issue events)
- [ ] Build webhook receiver endpoint `POST /api/v1/webhooks/github`
- [ ] Implement event handlers:
  - [ ] PR opened/merged → update saved repo metadata
  - [ ] Issue closed → update Contribute Mode feed
- [ ] Register **Metadata Refresh** job to sync star/commit data for all saved repos (24h)

---

## ⚡ Phase 3F — Performance Calibration

- [ ] Profile embedding pipeline latency end-to-end
- [ ] Implement async job queue (Celery or ARQ) to offload heavy embedding to workers
- [ ] Add caching layer (Redis) for frequently fetched GitHub API responses
- [ ] Add server-side response caching for `GET /api/v1/feed` (short TTL)
- [ ] Run load test (Locust / k6): target 100 concurrent users with < 200ms p95 feed latency
- [ ] Optimize database queries with proper indexing on `feed_items` (user_id, status, created_at)

---

## 🧪 Testing & Quality (Ongoing)

- [ ] Achieve ≥ 80% unit test coverage on all agent logic (pytest)
- [ ] Write integration tests for all API endpoints (httpx test client)
- [ ] Write end-to-end tests for core user flows (Playwright)
- [ ] Set up test fixtures with mocked GitHub API responses
- [ ] Document all public functions and modules (Google-style docstrings)

---

## 📖 Documentation (Ongoing)

- [ ] Write and maintain `README.md` with setup instructions and architecture overview
- [ ] Add inline `CONTRIBUTING.md` guide with PR template and branch naming conventions
- [ ] Generate OpenAPI docs via FastAPI (`/docs` and `/redoc`)
- [ ] Write deployment runbook (environment variables, secrets, migration steps)
