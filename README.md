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

### Smart Contracts
- Solidity
- Hardhat
- OpenZeppelin Contracts
- IPFS for metadata storage

### Frontend
- Next.js
- TypeScript
- TailwindCSS
- ethers.js
- wagmi
- RainbowKit

### Backend
- Node.js
- Express
- MongoDB
- IPFS

## Project Structure

```
openevent/
├── contracts/           # Smart contracts
├── frontend/           # Next.js frontend application
├── backend/            # Node.js backend service
├── scripts/            # Deployment and utility scripts
└── docs/              # Documentation
```

## Getting Started

### Prerequisites
- Node.js (v16+)
- npm or yarn
- Hardhat
- MongoDB
- IPFS node

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   # Install contract dependencies
   cd contracts
   npm install

   # Install frontend dependencies
   cd ../frontend
   npm install

   # Install backend dependencies
   cd ../backend
   npm install
   ```

3. Set up environment variables:
   - Create `.env` files in each directory
   - Add required environment variables (see respective README files)

## Development Roadmap

### Phase 1: Smart Contract Development
- [ ] Basic event creation contract
- [ ] Profile NFT contract
- [ ] Ticketing system contract
- [ ] Reputation system contract

### Phase 2: Backend Development
- [ ] API setup
- [ ] IPFS integration
- [ ] Database schema design
- [ ] Authentication system

### Phase 3: Frontend Development
- [ ] Project setup
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
- [ ] Frontend deployment
- [ ] Backend deployment
- [ ] Documentation
- [ ] Launch preparation

## Contributing

Please read CONTRIBUTING.md for details on our code of conduct and the process for submitting pull requests.

## License

This project is licensed under the MIT License - see the LICENSE file for details. 