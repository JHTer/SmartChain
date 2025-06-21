# Task Breakdown & Implementation Plan: SmartSupplyX MVP

## 1. Purpose & Audience

**Purpose**: This document translates the product and system architecture specifications into a sequential, actionable list of engineering tasks. It serves as the primary implementation roadmap for building the SmartSupplyX MVP. Each task is designed to be a discrete unit of work, similar to a well-defined GitHub Issue or Jira ticket.

**Audience**:
- **Engineers**: This is your primary work plan. Pick up tasks in order, follow the steps, and meet the acceptance criteria.
- **Project Managers & Tech Leads**: To track progress, manage dependencies, and ensure the project stays on schedule.
- **AI Agents**: To execute implementation tasks by converting these steps into code.

---

## 2. Implementation Roadmap (Sequential)

This roadmap is broken down by epics. Tasks should be completed in the order they appear, as they often have dependencies on previous tasks.

### Epic 1: Project Setup & Foundational Infrastructure

#### **Task 1: Initialize Monorepo & Core CI/CD**
- **Objective**: Create the foundational code repository and a basic CI/CD pipeline.
- **Steps**:
    1.  Initialize a new monorepo using `pnpm` workspaces.
    2.  Set up top-level `package.json`, `tsconfig.json`, and Prettier/ESLint configurations.
    3.  Create a placeholder directory for each service (`/apps/frontend`, `/services/auth`, etc.).
    4.  Create a basic CI workflow in GitHub Actions (`.github/workflows/ci.yml`) that runs `pnpm install` and `pnpm lint` on every push.
- **Deliverables**: A clonable GitHub repository with a passing CI build.
- **Acceptance Criteria**:
    - A new pull request triggers the CI workflow.
    - The workflow successfully installs dependencies and runs the linter.

#### **Task 2: Provision Cloud Infrastructure**
- **Objective**: Set up the necessary cloud services for hosting our application.
- **Steps**:
    1.  Create a new project on Vercel for the frontend.
    2.  Create a new project on Render.
    3.  Provision a PostgreSQL database and a Redis instance on Render.
    4.  Store all access credentials (database URLs, API keys) securely in project secrets (e.g., GitHub Secrets).
- **Deliverables**: Live, accessible (but empty) instances of our cloud infrastructure.
- **Acceptance Criteria**:
    - The Vercel project is linked to the GitHub repository.
    - Connection strings for Postgres and Redis are available and stored securely.

---

### Epic 2: Authentication & Multi-Tenancy

#### **Task 3: Implement Auth Service & Database Schema**
- **Dependencies**: Task 1, 2
- **Objective**: Build the service responsible for user authentication and define the core database models.
- **Steps**:
    1.  Initialize a new NestJS application in `/services/auth`.
    2.  Set up Prisma and connect it to the provisioned PostgreSQL database.
    3.  Define the initial Prisma schema (`schema.prisma`) with models for `Tenant`, `User`, `Role`, and `Permission`.
    4.  Run `prisma migrate dev` to apply the schema to the database.
    5.  Implement API endpoints for user signup (`/auth/signup`) and login (`/auth/login`).
    6.  Use Passport.js with a JWT strategy. The login endpoint should return an access token and a refresh token.
- **Deliverables**: A containerized Auth service with a running API.
- **Acceptance Criteria**:
    - A new user can be created via the signup endpoint.
    - A registered user can log in and receive a valid JWT containing `userId` and `tenantId`.
    - The database schema is correctly created.

---

### Epic 3: Frontend Scaffolding & Core UI

#### **Task 4: Initialize Next.js Frontend & Connect to Auth**
- **Dependencies**: Task 3
- **Objective**: Set up the frontend application and create a basic login flow.
- **Steps**:
    1.  Initialize a new Next.js application in `/apps/frontend`.
    2.  Install and configure Tailwind CSS and Shadcn/ui.
    3.  Install Apollo Client to act as the GraphQL client.
    4.  Create a login page with a form that calls the `Auth Service` login endpoint.
    5.  On successful login, store the JWT securely in the browser (e.g., in an HttpOnly cookie).
    6.  Create a protected route (e.g., `/dashboard`) that is only accessible to authenticated users.
- **Deliverables**: A deployable Next.js application with a working login page.
- **Acceptance Criteria**:
    - The app is deployed on Vercel.
    - A user can log in, and the token is stored.
    - Unauthenticated users are redirected from `/dashboard` to the login page.
    - Authenticated users can access the `/dashboard` page.

#### **Task 5: Build a Reusable UI Component Library**
- **Dependencies**: Task 4
- **Objective**: Create a set of common, reusable UI components.
- **Steps**:
    1.  Using Shadcn/ui, create and customize the following components: `Button`, `Input`, `Table`, `Card`, `Select`, `DatePicker`.
    2.  Create a `Layout` component that includes a sidebar for navigation and a header.
    3.  The sidebar should display links to `Dashboard`, `Inventory`, `Orders`, and `Shipments`.
    4.  The header should display the current user's name and a logout button.
- **Deliverables**: A set of styled, reusable components and a main application layout.
- **Acceptance Criteria**:
    - Components are visually consistent and adhere to a design system.
    - The main layout is applied to all protected pages.
    - The logout button clears the user's session and redirects to the login page.

---

### Epic 4: MVP Feature Implementation

#### **Task 6: Build Inventory Service & API Endpoints**
- **Dependencies**: Task 3
- **Objective**: Create the service to manage inventory data.
- **Steps**:
    1.  Initialize a new NestJS application in `/services/inventory`.
    2.  Extend the Prisma schema with `Product`, `Warehouse`, and `InventoryLevel` models.
    3.  Run `prisma migrate dev`.
    4.  Create REST API endpoints for CRUD (Create, Read, Update, Delete) on products and warehouses.
    5.  Create an endpoint to view inventory levels, with filtering by product or warehouse.
- **Deliverables**: A containerized Inventory service.
- **Acceptance Criteria**:
    - API endpoints for managing products and warehouses are functional.
    - The inventory level endpoint returns accurate stock counts.

#### **Task 7: Build Inventory Management UI**
- **Dependencies**: Task 5, 6
- **Objective**: Create the frontend interface for managing inventory.
- **Steps**:
    1.  Create a new page at `/inventory`.
    2.  Use the `Table` component to display a list of all products.
    3.  Implement a modal form to add or edit a product.
    4.  Create a detail page for a product that shows its inventory levels across all warehouses.
- **Deliverables**: A functional UI for inventory management.
- **Acceptance Criteria**:
    - Users can view a list of all products.
    - Users can create, update, and delete products through the UI.
    - Users can see where each product is stored and in what quantity.

*... (Tasks for Order Management, Shipment Tracking, and the Dashboard would follow in a similar, detailed format) ...*

