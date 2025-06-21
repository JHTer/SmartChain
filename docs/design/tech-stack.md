# Tech Stack & Tooling: SmartSupplyX

## 1. Purpose & Audience

**Purpose**: This document specifies the technology stack, libraries, infrastructure, and tooling for SmartSupplyX. It provides justifications for key technology choices and establishes a standardized set of tools to ensure consistency, maintainability, and developer productivity.

**Audience**:
- **Engineers**: To understand the specific frameworks, libraries, and platforms they will be using for development.
- **DevOps & SREs**: To automate the setup of infrastructure, CI/CD, and observability pipelines.
- **New Team Members**: To quickly get up to speed on the tools and technologies used in the project.

---

## 2. Technology Choices & Justification

This section details the "what" and "why" behind our technology decisions for each layer of the stack.

| Layer             | Technology / Framework       | Justification                                                                                                                                                                                                                               |
| ----------------- | ---------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Frontend**      | **Next.js (React)**          | Chosen for its powerful features like Server-Side Rendering (SSR) for fast initial page loads, static site generation (SSG) for marketing pages, file-system based routing for simplicity, and a strong ecosystem.                             |
| **Backend**       | **NestJS (Node.js)**         | A progressive Node.js framework that imposes a solid architectural pattern (inspired by Angular). It has excellent support for TypeScript, dependency injection, and microservices, making it ideal for building scalable and maintainable services. |
| **Database ORM**  | **Prisma**                   | Provides a best-in-class developer experience with its auto-generated and type-safe query builder. The schema-first approach simplifies database migrations and ensures the database schema is the single source of truth.         |
| **Database**      | **PostgreSQL**               | A battle-tested, open-source relational database known for its reliability, feature robustness, and extensibility. It's perfectly suited for handling the structured, relational data of a supply chain platform.             |
| **Caching**       | **Redis**                    | The de-facto standard for in-memory caching. It will be used to store session data, cache frequent database queries, and reduce application latency.                                                                                   |
| **Message Queue** | **RabbitMQ**                 | A mature and reliable message broker that is easy to deploy and use. It supports various messaging patterns and will be used to decouple long-running background jobs from the main request/response cycle.                          |
| **AI/ML**         | **Python (FastAPI)**         | Python is the lingua franca of machine learning. FastAPI is a modern, high-performance web framework for building APIs with Python 3.7+ based on standard Python type hints, offering speed and ease of development for the AI service. |

---

## 3. Key Libraries & Frameworks

| Area                      | Library/Tool                | Description                                                                                                                                 |
| ------------------------- | --------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| **Frontend State**        | **Zustand**                 | A small, fast, and scalable state management solution for React. Its simplicity and minimal API make it a less-boilerplate alternative to Redux. |
| **Frontend UI**           | **Shadcn/ui & Tailwind CSS** | Shadcn/ui provides beautifully designed, accessible, and unstyled components that we can fully customize. Tailwind CSS enables rapid UI development with a utility-first approach. |
| **API Client (Frontend)** | **Apollo Client**           | A comprehensive state management library for JavaScript that enables you to manage both local and remote data with GraphQL.                     |
| **Authentication**        | **Passport.js**             | A flexible and modular authentication middleware for Node.js. It will be used within our NestJS Auth Service to handle JWT strategy.           |
| **Unit/Integration Tests**| **Jest & React Testing Library** | Jest is the standard for JavaScript testing. React Testing Library provides a user-centric approach to testing components.                |
| **E2E Tests**             | **Playwright**              | A modern, reliable framework for end-to-end testing from Microsoft. It supports all modern rendering engines and has excellent tooling.          |

---

## 4. Deployment & Infrastructure

### 4.1. Deployment Targets
- **Frontend (Next.js)**: **Vercel**. As the creators of Next.js, Vercel provides a seamless, zero-configuration deployment experience with features like automatic deployments, preview URLs for every git push, and a global CDN.
- **Backend Services (NestJS)**: **Render**. A unified cloud platform that is easy to use and scales well. It offers managed PostgreSQL and Redis, private networking, and auto-deploys from Git, making it a strong choice for our backend microservices.
- **AI Service (Python)**: **Railway** or **Google Cloud Run**. Chosen for their ability to easily deploy containerized applications and scale to zero, which is cost-effective for a service that may not be used continuously at first.

### 4.2. CI/CD & Automation
- **CI/CD Tool**: **GitHub Actions**. Integrated directly into our source code repository, it's a natural choice for automating our build, test, and deployment pipelines.
- **Workflows**:
    1.  **On Pull Request**: Run linting, unit tests, and integration tests. Build a preview deployment on Vercel.
    2.  **On Merge to `main`**: Run all tests. If successful, build and deploy to production environments on Vercel and Render.

### 4.3. Containerization
- **Tool**: **Docker**.
- **Usage**: Each backend microservice and the AI service will be containerized using Docker. This ensures a consistent and reproducible environment across development, staging, and production. `Dockerfile`s will be maintained for each service.

---

## 5. Observability

### 5.1. Logging
- **Strategy**: All services will log structured JSON to `stdout`.
- **Aggregator**: **Datadog** or **Logtail**. Cloud-based logging platforms will be used to aggregate logs from all services. This allows for centralized searching, filtering, and alerting on log data.

### 5.2. Monitoring & Alerting
- **Platform**: **Sentry** for error tracking and **Better Uptime** for infrastructure monitoring.
- **Metrics**:
    - **Sentry**: Will be integrated into both the frontend and backend to capture and report unhandled exceptions in real-time, with context like stack traces and user session data.
    - **Better Uptime**: Will monitor the health of our public endpoints (API Gateway, Frontend) and trigger alerts (e.g., via Slack or PagerDuty) if a service becomes unavailable.

---

## 6. Prisma Schema Overview (Logical)

We will adopt a modular approach to our Prisma schema, reflecting the microservice architecture. While physically co-located in a single `schema.prisma` file for simplicity in the MVP, the models will be logically grouped by domain.

- **Core Models**:
    - `Tenant`: Represents a customer company.
    - `User`: Belongs to a Tenant, has a role.
    - `Role`, `Permission`: For RBAC.

- **Inventory Models**:
    - `Product`: The item being tracked (SKU, name, description).
    - `Warehouse`: A physical location where inventory is stored.
    - `InventoryLevel`: A join table tracking the quantity of a `Product` at a `Warehouse`.

- **Order & Shipment Models**:
    - `Order`: Represents a purchase order or sales order.
    - `OrderItem`: Line items within an order.
    - `Shipment`: Tracks the movement of an `Order` from origin to destination.
    - `ShipmentUpdate`: A log of status changes for a shipment.

This structure ensures data is organized logically by service domain, making it easier to manage and reason about as the application grows.

