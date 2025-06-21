# SmartSupplyX

**SmartSupplyX** is an intelligent, full-stack supply chain management platform designed to provide real-time visibility, optimize logistics, and streamline operations from inventory to final delivery. This repository contains the complete source code, technical documentation, and development roadmap.

This project is built with a modern, scalable architecture, leveraging a microservices-based backend, a reactive frontend, and AI-powered analytics to deliver a robust and efficient solution.

## 📖 Documentation

All technical documentation is located in the `/docs` directory and serves as the single source of truth for understanding the system architecture, product vision, and development tasks. These documents are written to be directly actionable for engineers and AI agents working on the project.

-   **`docs/overview/product-blueprint.md`**: Outlines the product vision, MVP features, user personas, and problems we are solving.
-   **`docs/design/system-architecture.md`**: Provides a detailed breakdown of the system's components, API strategy, and infrastructure.
-   **`docs/design/tech-stack.md`**: Justifies the choice of technologies, frameworks, and services used across the platform.
-   **`docs/planning/task-breakdown.md`**: Contains a sequential, developer-ready list of tasks for implementing the roadmap.

## ✨ Key Features (MVP)

-   **Real-time Inventory Tracking**: Monitor stock levels across multiple warehouses.
-   **Order Management**: Create, process, and track sales orders from creation to fulfillment.
-   **Shipment Logistics**: Plan and manage shipments, including carrier integration and route optimization.
-   **User Authentication**: Secure role-based access for different user personas (e.g., Admins, Warehouse Managers).
-   **AI-Powered Forecasting**: (Future) Predictive analytics for demand forecasting and inventory optimization.

## 🚀 Tech Stack Overview

Our technology choices are guided by principles of scalability, performance, and developer experience.

-   **Frontend**: Next.js, TypeScript, React, Tailwind CSS
-   **Backend**: Node.js, NestJS, TypeScript (Microservices Architecture)
-   **Database**: PostgreSQL with Prisma ORM
-   **API**: GraphQL & REST APIs via an API Gateway
-   **Async Processing**: RabbitMQ for message queuing between services
-   **Authentication**: JWT-based authentication with Auth0/Clerk integration
-   **Deployment**: Vercel (Frontend), Railway/Render (Backend Services), Docker for containerization.
-   **CI/CD**: GitHub Actions

A more detailed justification for each choice is available in `docs/design/tech-stack.md`.

## 🏗️ Project Structure

The repository is a monorepo managed with pnpm workspaces.

```
smartsupplyx/
├── apps/
│   └── frontend/       # Next.js web application
├── packages/           # Shared libraries (e.g., ui, config, logger)
├── services/           # Backend microservices
│   ├── auth/
│   ├── inventory/
│   ├── order/
│   └── shipment/
├── docs/               # All project documentation
├── tsconfig.base.json  # Base TypeScript configuration
└── package.json        # Root package configuration
```

## 🏁 Getting Started

Clone the repository and install the dependencies:

```bash
git clone https://github.com/JHTer/SmartChain.git
cd smartsupplyx
pnpm install
```

To run the development servers:

```bash
pnpm dev
```

(Detailed setup instructions for environment variables and database setup will be added to the respective service `README.md` files).

## 🤝 Contributing

Contributions are welcome! Please refer to `CONTRIBUTING.md` for guidelines on how to submit pull requests, report issues, and propose features. All development should be based on the tasks outlined in `docs/planning/task-breakdown.md`.

## 📄 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
