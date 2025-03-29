# OpenEvent

OpenEvent is a decentralized platform for event management and participation, leveraging web3 identity primitives to create a seamless experience for event organizers and participants.

## Project Overview

OpenEvent aims to revolutionize event participation by providing:
- Event creation and management through smart contracts
- On-chain reputation building
- Efficient participant onboarding
- Integrated ticketing system
- Automated payouts
- Smart networking capabilities

## Tech Stack

### Full Stack (Next.js)
- Next.js 14 with App Router
- TypeScript
- TailwindCSS
- Prisma (Database ORM)
- React Query
- React Hook Form
- Zod (Schema Validation)

### Web3 Integration
- RainbowKit
- wagmi
- viem
- ethers.js
- Web3Modal

### Smart Contracts
- Solidity
- Hardhat
- OpenZeppelin Contracts
- IPFS for metadata storage

## Project Structure

```
openevent/
├── src/
│   ├── app/                 # Next.js App Router pages and layouts
│   │   ├── (auth)/         # Authentication related pages
│   │   ├── (dashboard)/    # Dashboard pages
│   │   ├── (events)/       # Event related pages
│   │   └── api/            # API routes
│   ├── components/         # Reusable React components
│   │   ├── ui/            # UI components
│   │   ├── forms/         # Form components
│   │   └── web3/          # Web3 related components
│   ├── lib/               # Utility functions and configurations
│   │   ├── web3/         # Web3 configurations
│   │   ├── db/           # Database configurations
│   │   └── utils/        # Helper functions
│   ├── hooks/            # Custom React hooks
│   ├── types/            # TypeScript type definitions
│   └── styles/           # Global styles
├── prisma/               # Database schema and migrations
├── contracts/            # Smart contracts
├── public/              # Static assets
└── scripts/             # Utility scripts
```

## Getting Started

### Prerequisites
- Node.js (v18+)
- npm or yarn
- Hardhat
- IPFS node

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   npm install
   ```

3. Set up environment variables:
   ```bash
   cp .env.example .env.local
   ```
   Add required environment variables (see .env.example)

4. Set up the database:
   ```bash
   npx prisma generate
   npx prisma db push
   ```

5. Run the development server:
   ```bash
   npm run dev
   ```

## Development Roadmap

### Phase 1: Smart Contract Development
- [ ] Basic event creation contract
- [ ] Profile NFT contract
- [ ] Ticketing system contract
- [ ] Reputation system contract

### Phase 2: Core Features Development
- [ ] Authentication system
- [ ] Database schema design
- [ ] API routes implementation
- [ ] Web3 integration
- [ ] IPFS integration

### Phase 3: Frontend Development
- [ ] Layout and navigation
- [ ] Wallet connection
- [ ] Event creation interface
- [ ] Profile management
- [ ] Event discovery
- [ ] Ticketing interface

### Phase 4: Integration & Testing
- [ ] Contract testing
- [ ] Integration testing
- [ ] Security audits
- [ ] Performance optimization

### Phase 5: Deployment & Launch
- [ ] Contract deployment
- [ ] Application deployment
- [ ] Documentation
- [ ] Launch preparation

## Contributing

Please read CONTRIBUTING.md for details on our code of conduct and the process for submitting pull requests.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
