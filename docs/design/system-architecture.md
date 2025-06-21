# System Architecture: SmartSupplyX

## 1. Purpose & Audience

**Purpose**: This document provides a comprehensive overview of the system architecture for SmartSupplyX. It details the major components, their interactions, and the underlying design principles. This specification is crucial for ensuring the platform is scalable, maintainable, and secure.

**Audience**:
- **Backend & Frontend Engineers**: To understand the system's structure, component responsibilities, and API contracts.
- **DevOps & SREs**: To provision infrastructure, set up CI/CD pipelines, and monitor system health.
- **Architects & Tech Leads**: To review the design, identify potential bottlenecks, and plan future architectural evolutions.

---

## 2. High-Level System Diagram

The SmartSupplyX platform is designed as a modular, service-oriented architecture.

```mermaid
graph TD
    subgraph "Browser & Mobile"
        A[React Web App]
    end

    subgraph "API Layer"
        B[API Gateway]
    end

    subgraph "Backend Services"
        C[Auth Service]
        D[Inventory Service]
        E[Shipment Service]
        F[Order Service]
    end

    subgraph "Async Processing"
        G[Message Queue <br/> (RabbitMQ)]
        H[Reporting Worker]
        I[Notification Worker]
    end

    subgraph "Data & AI"
        J[PostgreSQL DB]
        K[Redis Cache]
        L[AI/ML Service <br/> (Forecasting)]
    end

    subgraph "Third-Party Integrations"
        M[Carrier APIs]
        N[ERP Systems]
    end

    A -- "GraphQL" --> B
    B -- "REST/gRPC" --> C
    B -- "REST/gRPC" --> D
    B -- "REST/gRPC" --> E
    B -- "REST/gRPC" --> F

    D -- "Publishes events" --> G
    E -- "Publishes events" --> G
    F -- "Publishes events" --> G

    G -- "Consumes jobs" --> H
    G -- "Consumes jobs" --> I

    C -- "Reads/Writes" --> J
    D -- "Reads/Writes" --> J
    E -- "Reads/Writes" --> J
    F -- "Reads/Writes" --> J
    H -- "Reads/Writes" --> J

    D -- "Caches" --> K
    E -- "Caches" --> K
    F -- "Caches" --> K

    L -- "Provides predictions" --> D
    D -- "Sends data for analysis" --> L

    E -- "Fetches tracking data" --> M
    F -- "Syncs orders" --> N
```

### Diagram Description

1.  **Client**: A React-based web application serves as the primary user interface.
2.  **API Gateway**: A single, unified entry point for all client requests. It routes traffic to the appropriate backend microservices.
3.  **Backend Microservices**: The core business logic is split into domain-specific services (Auth, Inventory, Shipments, Orders). This promotes separation of concerns and independent scalability.
4.  **Asynchronous Workers**: A message queue (RabbitMQ) decouples long-running or resource-intensive tasks, such as generating reports or sending notifications. Dedicated workers consume these messages and execute the jobs.
5.  **Data Layer**: A primary PostgreSQL database ensures data integrity through its relational structure. A Redis instance is used for caching frequently accessed data to reduce latency.
6.  **AI Microservice**: A dedicated Python-based service will house machine learning models for future features like demand forecasting. It communicates with other services via internal APIs.
7.  **Third-Party Integrations**: The system interacts with external carrier APIs for shipment tracking and can sync with enterprise ERP systems.

---

## 3. Component Breakdown

### 3.1. Frontend
- **Framework**: React with Next.js.
- **Description**: A modern, responsive single-page application (SPA) providing the user interface. Next.js is chosen for its server-side rendering (SSR) capabilities, which improve performance and SEO, and its file-system based routing.

### 3.2. API Gateway
- **Technology**: Apollo Server (if GraphQL is primary) or a dedicated gateway like Kong/Tyk.
- **Description**: Manages routing, rate limiting, and authentication for all incoming API requests. It aggregates responses from various microservices, providing a single GraphQL endpoint to the client.

### 3.3. Backend Modules (Microservices)
- **Language/Framework**: TypeScript with Node.js (NestJS).
- **Description**:
    - **Auth Service**: Manages user identity, authentication (JWTs), and authorization (RBAC).
    - **Inventory Service**: Handles all logic related to stock levels, warehouse data, and product SKUs.
    - **Shipment Service**: Manages tracking information, carrier integrations, and shipment statuses.
    - **Order Service**: Responsible for the entire order lifecycle, from creation to fulfillment.

### 3.4. Asynchronous Workers
- **Technology**: Node.js or Python scripts.
- **Description**: These are background processes that listen for messages on the queue.
    - **Reporting Worker**: Generates PDFs or CSVs for user-requested reports.
    - **Notification Worker**: Sends email or in-app notifications based on system events (e.g., low-stock alerts).

### 3.5. Database
- **Primary DB**: PostgreSQL.
- **Why**: Chosen for its robustness, reliability, and strong support for relational data, which is essential for maintaining integrity in a supply chain system.
- **Caching**: Redis.
- **Why**: An in-memory data store used to cache frequently accessed data, such as user sessions, product details, and recent shipment statuses, dramatically reducing database load and response times.

### 3.6. AI Microservice
- **Technology**: Python with FastAPI, PyTorch/TensorFlow.
- **Description**: A separate service dedicated to computationally intensive AI/ML tasks. For the MVP, this will be dormant but is architected in for future forecasting features. FastAPI is chosen for its high performance and ease of use.

---

## 4. API Strategy

A **hybrid approach** will be adopted:
- **External API (Client-to-Gateway)**: **GraphQL**. This is ideal for the frontend, as it allows the client to request exactly the data it needs in a single round trip, reducing over-fetching and improving performance on the user's device.
- **Internal APIs (Gateway-to-Service)**: **REST** or **gRPC**.
    - **REST**: Simple, well-understood, and sufficient for most internal communication.
    - **gRPC**: A high-performance RPC framework that will be considered for latency-sensitive, high-throughput communication between critical services (e.g., between the API Gateway and the Order Service).

---

## 5. Authentication & Authorization (AuthN/AuthZ)

- **Strategy**: JSON Web Tokens (JWT).
- **Flow**:
    1. User logs in with credentials.
    2. The `Auth Service` validates credentials and issues a short-lived access token and a long-lived refresh token.
    3. The access token is sent in the `Authorization` header of every subsequent GraphQL request.
    4. The API Gateway validates the token before routing the request.
    5. If the token is expired, the client uses the refresh token to obtain a new access token without requiring the user to log in again.
- **Authorization**: Role-Based Access Control (RBAC) will be implemented. User roles (e.g., `Admin`, `Planner`, `Operator`) and associated permissions will be stored in the database. The API Gateway and downstream services will enforce these permissions.

---

## 6. Multi-Tenancy

The system will be designed with multi-tenancy from the start, using a **schema-per-tenant** approach.
- **Data Isolation**: Each tenant (i.e., each customer company) will have its own dedicated schema within the PostgreSQL database. This provides strong data isolation and security.
- **Tenant Identification**: The user's `tenant_id` will be encoded into their JWT upon login.
- **Request Handling**: A middleware will inspect the JWT, identify the tenant, and set the appropriate database schema for the duration of the request. This ensures all database queries are automatically scoped to the correct tenant's data.

This approach balances isolation with cost-effectiveness, avoiding the overhead of provisioning a separate database for each tenant.

