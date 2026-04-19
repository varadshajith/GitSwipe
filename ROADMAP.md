# GitSwipe Development Roadmap

This document outlines the strategic milestones for the development and scaling of the GitSwipe platform.

---

## Phase 1: Operational Foundation (V1)
*Objective: Establishing secure authentication and core discovery mechanics.*

- [ ] **GitHub OAuth 2.0 Integration**: Secure authentication flow with scope management. [Complexity: Medium]
- [ ] **Scout Agent V1**: Implementation of first three search vectors (Topic, Organization, Momentum). [Complexity: Medium]
- [ ] **Heuristic Ranking Engine**: Deterministic candidate scoring based on metadata metrics. [Complexity: Medium]
- [ ] **Explainer V1**: Generation of concise, two-sentence repository summaries. [Complexity: Medium]
- [ ] **Core Interaction Loop**: Server-side and client-side implementation of Save/Skip logic. [Complexity: Medium]
- [ ] **Backend Architecture**: Scalable FastAPI structure with PostgreSQL persistence. [Complexity: Medium]
- [ ] **Frontend MVP**: Implementation of card-based feed and authentication views. [Complexity: High]

---

## Phase 2: Behavioral Intelligence (V2)
*Objective: Implementation of advanced agentic reasoning and interactive features.*

- [ ] **LLM-driven Ranking**: Incorporation of `llama-3.1-8b` for nuanced relevance scoring. [Complexity: High]
- [ ] **Explainer V2**: Implementation of comprehensive technical deep-dive generation. [Complexity: High]
- [ ] **RAG Infrastructure**: Development of the embedding pipeline and semantic search interface. [Complexity: High]
- [ ] **Guide Agent V1**: Interactive repository consultation via WebSocket-based chat. [Complexity: High]
- [ ] **Contribute Mode**: Algorithm for ranking issues by verified developer skill metrics. [Complexity: High]
- [ ] **Issue Decomposition**: AI-driven analysis of project issue complexity and prerequisites. [Complexity: Medium]
- [ ] **Adaptive Preference Weights**: Automated refinement of user profiles based on interaction history. [Complexity: Medium]
- [ ] **Documentation Assistance**: automated generation of PR descriptions from code delta analysis. [Complexity: Medium]

---

## Phase 3: Infrastructure Scaling (V3)
*Objective: Global performance optimization and automated pipeline management.*

- [ ] **Distributed Vector Persistence**: Migration to Pinecone for high-scale semantic retrieval. [Complexity: High]
- [ ] **Continuous Deployment**: Implementation of automated CI/CD pipelines for cloud environments. [Complexity: Medium]
- [ ] **Advanced Scout Vectors**: Integration of technographic and star-velocity discovery modes. [Complexity: High]
- [ ] **Persistent Agent Memory**: Cross-session context retention for the Guide agent. [Complexity: Medium]
- [ ] **Profile Overrides**: Temporary session context for ad-hoc repository exploration. [Complexity: Medium]
- [ ] **Automated Lifecycle Sync**: Webhook-driven synchronization of PR and issue status. [Complexity: High]
- [ ] **Performance Calibration**: Low-level optimization of embedding latency and job scheduling. [Complexity: Medium]
