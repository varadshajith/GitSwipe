# GitSwipe

GitSwipe is a repo discovery tool. It uses multiple agents to find, rank, and summarize GitHub projects based on your preferences.

## Primary Features

### Discovery and Curation
*   **Intelligent Feed**: A personalized repository feed utilizing asynchronous multi-vector scouting.
*   **Automated Technical Summarization**: Instant generation of project scope, architectural overviews, and contribution prerequisites using Llama 3 agents.
*   **Adaptive Ranking Engine**: A scoring system that adjusts candidate relevance based on historical interaction patterns and defined developer profiles.

### Contribution Support
*   **Guide Agent (RAG)**: A Retrieval-Augmented Generation agent providing real-time technical consultation via source code and issue analysis.
*   **Contribute Mode**: Automated identification and ranking of "good first issues" aligned with user skill levels and technology stacks.
*   **Contextual Issue Analysis**: Detailed decomposition of GitHub issues, highlighting affected files, required expertise, and predicted complexity.
*   **Pull Request Generation**: Automated generation of professional PR documentation derived from local git diffs.
*   **Contribution Pipeline**: An integrated Kanban system for managing the full lifecycle of open-source contributions.

## System Architecture

```text
       ┌───────────────────┐
       │   Flutter Client  │ (UI Layer, State Management, Real-time Communication)
       └─────────┬─────────┘
                 │ Secure REST / WebSockets
       ┌─────────▼─────────┐
       │   FastAPI Backend │ (Async Core, Auth, Job Scheduling, API Gateway)
       └─────────┬─────────┘
                 │
       ┌─────────▼─────────┐
       │ LangGraph Engine  │ (Agentic State Orchestration, Conditional Logic)
       └─────────┬─────────┘
                 │
     ┌───────────┼───────────┬───────────┐
┌────▼────┐ ┌────▼────┐ ┌────▼────┐ ┌────▼─────┐
│ Groq API│ │GitHub API│ │ChromaDB │ │PostgreSQL│
└─────────┘ └─────────┘ └─────────┘ └──────────┘
(Inference) (Data Source) (Vector)   (Relational)
```

## Technical Stack

| Category | Component | Rationale |
| :--- | :--- | :--- |
| **Frontend** | Flutter SDK | Cross-platform consistency with high-performance rendering. |
| **Backend** | FastAPI | Asynchronous Python framework optimized for high-throughput AI workloads. |
| **Orchestration** | LangGraph | Support for cyclic graphs, explicit state, and complex agent workflows. |
| **LLM Inference** | Groq (Llama 3.3) | Sub-second latency for complex reasoning and summarization tasks. |
| **Vector Storage** | ChromaDB | Lightweight, high-performance local vector storage for repo embeddings. |
| **Relational DB** | PostgreSQL | Robust persistence for user state, preferences, and contribution tracking. |

## Deployment and Setup

### Prerequisites
*   Python 3.11 or higher
*   Flutter Desktop/Mobile environment
*   PostgreSQL 14+
*   Groq API Authorization Key
*   GitHub OAuth Application Credentials

### Installation

1.  **Backend Initialization**
    ```bash
    cd backend
    python -m venv .venv
    source .venv/bin/activate
    pip install -r requirements.txt
    cp .env.example .env # Configure environment variables
    uvicorn app.main:app --host 0.0.0.0 --port 8000
    ```

2.  **Frontend Initialization**
    ```bash
    cd app
    flutter pub get
    flutter run
    ```

## Environment Configuration

| Variable | Type | Description |
| :--- | :--- | :--- |
| `DATABASE_URL` | String | PostgreSQL connection DSN. |
| `GROQ_API_KEY` | Secret | Authentication token for Groq inference services. |
| `GITHUB_TOKEN` | Secret | Personal Access Token or OAuth token for GitHub API. |
| `CHROMA_PATH` | Path | Filesystem path for vector database persistence. |

## Directory Structure

```text
.
├── app/                # Flutter frontend implementation
│   ├── lib/features/   # Domain-driven feature modules
│   └── lib/shared/     # Core UI components and design tokens
├── backend/            # Python backend implementation
│   ├── app/agents/     # LangGraph agent definitions and nodes
│   ├── app/jobs/       # Asynchronous background tasks
│   └── app/db/         # Persistence layer (SQL and Vector)
├── ARCHITECTURE.md     # In-depth technical documentation
├── AGENTS.md           # Agent specifications and prompt structures
├── DESIGN_SYSTEM.md    # UI/UX design specifications
└── ROADMAP.md          # Project milestones and delivery schedule
```

## Contributing

Refer to [CONTRIBUTING.md](CONTRIBUTING.md) for detailed development workflows and contribution standards.

## License
MIT
