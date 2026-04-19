# Scout Agent
**Task**: Find new repos.
- **Search Vectors**: Topic, Org, Dependencies, Low-star active, Good-first-issue, Star velocity.
- **Process**: Runs parallel searches via GitHub API.
- **Output**: List of repo IDs and metadata.
- **Latency**: 5-10s (parallel API calls).
- **Failure logic**: On rate limit, use cached results from trending.

# Ranker Agent
**Task**: Filter and score candidates.
- **Model**: `llama-3.1-8b-instant` (Fast/cheap scoring).
- **Input**: User `PreferenceProfile` + Repo data.
- **Logic**: Hybrid (Math for stars/recency + LLM for readme-interest match).
- **Output**: Score (0-100) + justification.
- **Constraint**: Must use Pydantic for output schema.

# Explainer Agent
**Task**: Summarize codebases.
- **Model**: `llama-3.3-70b-versatile`.
- **Method**: Map-reduce. Summarizes 1k token chunks then reduces into final card and deep-dive markdown.
- **Input**: README, CONTRIBUTING, File tree, Issues.
- **Output**: 2-sentence card summary + detailed Markdown deep-dive.

# Guide Agent
**Task**: RAG Chatbot for specific repos.
- **Model**: `llama-3.3-70b-versatile`.
- **Tools**:
  - `fetch_file_content`: Read source code.
  - `query_project_issues`: Search GitHub issues.
  - `semantic_vector_search`: Search repo embeddings in ChromaDB.
- **Memory**: Context window (session) + User skill level (long-term).
- **Latency**: ~1s stream start.
- **Safety**: Max 5 tool-call loops to prevent infinite recursing.

# Prompt Templates (Abstracted)
- **Ranker**: "Score this repo [0-100] for a dev with this profile: {profile}. Use this README: {readme}."
- **Explainer**: "Analyze this repo. Identify tech stack, core logic entry points, and contribution difficulty. Context: {chunks}."
- **Guide**: "You are a maintainer for {repo}. Answer user queries using your search tools. RAG context: {retrieved_code}."
