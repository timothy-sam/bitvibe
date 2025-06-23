# BitVibe - Bitcoin-Secured Creator Economy Platform

[![Stacks](https://img.shields.io/badge/Built%20on-Stacks-blue)](https://stacks.co)
[![Bitcoin](https://img.shields.io/badge/Secured%20by-Bitcoin-orange)](https://bitcoin.org)
[![Clarity](https://img.shields.io/badge/Language-Clarity-green)](https://clarity-lang.org)

## Overview

BitVibe is a revolutionary decentralized creator economy platform built on Stacks Layer 2, leveraging Bitcoin's security to create a trustless ecosystem where creators and communities thrive through verifiable reputation, engagement rewards, and NFT-backed memberships.

The platform transforms traditional creator monetization by establishing a decentralized system where authentic engagement translates to tangible value, creators earn from genuine community interaction, and users build verifiable digital reputation through meaningful participation.

## Key Features

🎯 **Dynamic Reputation System**

- Time-weighted scoring with natural decay mechanisms
- Anti-spam cooldown periods and engagement validation
- Verifiable on-chain reputation certificates

💰 **Multi-Tier Monetization**

- Creator-configurable reward parameters
- Direct STX tipping with reputation bonuses
- Automated engagement reward distribution

🏆 **NFT-Based Memberships**

- Four-tier membership system (Bronze, Silver, Gold, Platinum)
- Reputation-gated access levels
- Transferable membership certificates

🔒 **Bitcoin Security**

- All transactions secured by Bitcoin finality
- Built on Stacks L2 for programmability
- Emergency controls and pause mechanisms

## System Overview

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│                 │    │                 │    │                 │
│     Users       │    │    Creators     │    │   Platform      │
│                 │    │                 │    │                 │
└─────────┬───────┘    └─────────┬───────┘    └─────────┬───────┘
          │                      │                      │
          │ Engage & Tip         │ Create & Earn        │ Govern & Secure
          │                      │                      │
          ▼                      ▼                      ▼
    ┌─────────────────────────────────────────────────────────────┐
    │                                                             │
    │                   BitVibe Smart Contract                    │
    │                                                             │
    │  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
    │  │ Reputation  │  │ Engagement  │  │ NFT Certificates    │ │
    │  │ Management  │  │ Tracking    │  │ & Memberships       │ │
    │  └─────────────┘  └─────────────┘  └─────────────────────┘ │
    │                                                             │
    └─────────────────────────────────────────────────────────────┘
                                   │
                                   ▼
                          ┌─────────────────┐
                          │                 │
                          │  Bitcoin L1     │
                          │  (Security)     │
                          │                 │
                          └─────────────────┘
```

## Contract Architecture

### Core Components

#### 1. **User Profile Management**

```clarity
user-profiles: {
  reputation-score: uint,
  last-activity-block: uint,
  total-earnings: uint,
  engagement-count: uint,
  reputation-nft-id: (optional uint),
  membership-nft-id: (optional uint)
}
```

#### 2. **Creator Settings**

```clarity
creator-settings: {
  earnings-threshold: uint,
  reward-per-engagement: uint,
  is-active: bool,
  total-distributed: uint
}
```

#### 3. **Engagement Tracking**

```clarity
engagement-history: {
  user: principal,
  target: principal,
  stacks-block-height: uint
} -> {
  engagement-type: string,
  amount: uint,
  processed: bool
}
```

#### 4. **NFT Systems**

- **Reputation NFTs**: Certificates proving user reputation milestones
- **Membership NFTs**: Tiered access tokens with benefits and privileges

### Data Flow

```
1. User Registration
   ┌─────────────┐
   │ User joins  │ ──► initialize-user-profile() ──► Profile created with base reputation
   └─────────────┘

2. Creator Setup
   ┌─────────────┐
   │ Creator     │ ──► setup-creator-profile() ──► Monetization parameters set
   │ onboarding  │
   └─────────────┘

3. Engagement Flow
   ┌─────────────┐     ┌─────────────┐     ┌─────────────┐
   │ User        │ ──► │ Engage or   │ ──► │ Reputation  │
   │ interacts   │     │ tip creator │     │ updated     │
   └─────────────┘     └─────────────┘     └─────────────┘
                              │
                              ▼
                       ┌─────────────┐
                       │ Rewards     │
                       │ distributed │
                       └─────────────┘

4. Reputation Progression
   ┌─────────────┐     ┌─────────────┐     ┌─────────────┐
   │ Reputation  │ ──► │ Milestone   │ ──► │ NFT         │
   │ threshold   │     │ reached     │     │ certificate │
   │ reached     │     │             │     │ minted      │
   └─────────────┘     └─────────────┘     └─────────────┘
```

## Getting Started

### Prerequisites

- [Stacks CLI](https://docs.stacks.co/docs/write-smart-contracts/clarinet)
- [Clarinet](https://github.com/hirosystems/clarinet)
- Stacks wallet (Hiro Wallet or Xverse)

### Installation

1. **Clone the repository**

```bash
git clone https://github.com/timothy-sam/bitvibe.git
cd bitvibe
```

2. **Initialize Clarinet project**

```bash
clarinet new bitvibe-contract
cd bitvibe-contract
```

3. **Add the contract**

```bash
cp bitvibe.clar contracts/
```

4. **Configure Clarinet.toml**

```toml
[contracts.bitvibe]
path = "contracts/bitvibe.clar"
```

### Deployment

#### Testnet Deployment

```bash
clarinet deploy --testnet
```

#### Mainnet Deployment

```bash
clarinet deploy --mainnet
```

## Usage Examples

### Initialize User Profile

```clarity
(contract-call? .bitvibe initialize-user-profile)
```

### Setup Creator Profile

```clarity
(contract-call? .bitvibe setup-creator-profile u1000000 u50000)
;; threshold: 1 STX, reward-per-engagement: 0.05 STX
```

### Tip a Creator

```clarity
(contract-call? .bitvibe tip-creator 'SP1234...CREATOR 1000000)
;; Tip 1 STX to creator
```

### Engage with Creator

```clarity
(contract-call? .bitvibe engage-with-creator 'SP1234...CREATOR "like")
```

### Mint Reputation Certificate

```clarity
(contract-call? .bitvibe mint-reputation-certificate)
;; Requires 500+ reputation
```

## Security Features

### 🛡️ **Built-in Protections**

- **Cooldown Mechanisms**: Prevents spam engagement
- **Reputation Decay**: Ensures active participation
- **Amount Validation**: Minimum tip amounts and thresholds
- **Access Controls**: Admin functions restricted to contract owner

### 🔐 **Emergency Controls**

- **Contract Pausing**: Halt all operations if needed
- **Emergency Withdrawal**: Owner can recover contract funds
- **Upgrade Path**: Designed for future enhancements

### ⚡ **Anti-Spam Measures**

- Engagement cooldown periods
- Reputation-based rate limiting
- Valid engagement type checking
- Self-interaction prevention

## Membership Tiers

| Tier | Min Reputation | Benefits | Access Level |
|------|----------------|----------|--------------|
| 🥉 **Bronze** | 1,000 | Basic access to creator content | 1 |
| 🥈 **Silver** | 2,000 | Enhanced access + exclusive content | 2 |
| 🥇 **Gold** | 5,000 | Premium access + governance rights | 3 |
| 💎 **Platinum** | 8,000 | Full access + revenue sharing | 4 |

## API Reference

### Read-Only Functions

- `get-user-profile(user: principal)` - Retrieve user profile data
- `get-creator-settings(creator: principal)` - Get creator configuration
- `get-current-reputation(user: principal)` - Calculate current reputation with decay
- `get-membership-tier(tier-id: uint)` - Get tier information
- `calculate-tier-for-reputation(reputation: uint)` - Determine tier from reputation

### Public Functions

- `initialize-user-profile()` - Create new user profile
- `setup-creator-profile(threshold: uint, reward: uint)` - Configure creator settings
- `tip-creator(creator: principal, amount: uint)` - Send STX tip to creator
- `engage-with-creator(creator: principal, type: string)` - Record engagement
- `mint-reputation-certificate()` - Mint reputation NFT
- `mint-membership-certificate()` - Mint membership NFT

## Contributing

We welcome contributions to BitVibe! Please read our [Contributing Guidelines](CONTRIBUTING.md) and follow our [Code of Conduct](CODE_OF_CONDUCT.md).

### Development Setup

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## Roadmap

- [x] Core reputation system
- [x] NFT-based memberships
- [x] Creator monetization
- [ ] Mobile app integration
- [ ] Advanced analytics dashboard
- [ ] Multi-chain expansion
- [ ] DAO governance implementation
