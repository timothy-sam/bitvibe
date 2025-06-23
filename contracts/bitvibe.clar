;; BitVibe - Bitcoin-Secured Creator Economy Platform
;;
;; Summary:
;; A revolutionary creator monetization platform built on Stacks L2, leveraging 
;; Bitcoin's security to create a trustless ecosystem where creators and communities 
;; thrive through verifiable reputation, engagement rewards, and NFT-backed memberships.
;;
;; Description:
;; BitVibe transforms the creator economy by establishing a decentralized platform 
;; where authentic engagement translates to tangible value. Built on Stacks with 
;; Bitcoin finality, this protocol creates a sustainable ecosystem where creators 
;; earn from genuine community interaction while users build verifiable digital 
;; reputation through meaningful participation.
;;
;; The platform features dynamic reputation scoring with time-based decay to ensure 
;; active participation, multi-tiered membership systems backed by NFTs, and 
;; sophisticated engagement tracking that rewards quality interactions over quantity.
;; Creators can configure their own monetization parameters while the protocol 
;; maintains fairness through automated reward distribution and anti-spam mechanisms.
;;
;; Core Capabilities:
;; - Time-weighted reputation system with natural decay mechanisms
;; - Multi-tier engagement rewards (tips, likes, shares, comments, follows)
;; - NFT-based reputation certificates and membership badges
;; - Creator-controlled monetization settings and reward structures
;; - Anti-spam cooldown periods and engagement validation
;; - Governance-ready treasury management and emergency controls
;; - Bitcoin-secured transaction finality through Stacks L2
;;
;; Built for the future of decentralized content creation and community building.

;; ERROR CONSTANTS

(define-constant ERR-UNAUTHORIZED (err u100))
(define-constant ERR-ALREADY-EXISTS (err u101))
(define-constant ERR-NOT-FOUND (err u102))
(define-constant ERR-INSUFFICIENT-BALANCE (err u103))
(define-constant ERR-INVALID-AMOUNT (err u104))
(define-constant ERR-INVALID-THRESHOLD (err u105))
(define-constant ERR-INVALID-TIER (err u106))
(define-constant ERR-COOLDOWN-ACTIVE (err u107))
(define-constant ERR-EXPIRED-REPUTATION (err u108))

;; CONTRACT CONSTANTS

(define-constant CONTRACT-OWNER tx-sender)
(define-constant REPUTATION-DECAY-PERIOD u144)        ;; ~24 hours in blocks
(define-constant ENGAGEMENT-COOLDOWN u6)              ;; ~1 hour in blocks
(define-constant MIN-TIP-AMOUNT u1000000)             ;; 1 STX in microSTX
(define-constant MAX-REPUTATION-SCORE u10000)         ;; Maximum achievable reputation

;; DATA VARIABLES

(define-data-var contract-paused bool false)
(define-data-var total-reputation-nfts uint u0)
(define-data-var total-membership-nfts uint u0)
(define-data-var treasury-balance uint u0)

;; NFT DEFINITIONS

(define-non-fungible-token reputation-nft uint)
(define-non-fungible-token membership-nft uint)

;; DATA MAPS

(define-map user-profiles 
  principal 
  {
    reputation-score: uint,
    last-activity-block: uint,
    total-earnings: uint,
    engagement-count: uint,
    reputation-nft-id: (optional uint),
    membership-nft-id: (optional uint)
  }
)

(define-map creator-settings
  principal
  {
    earnings-threshold: uint,
    reward-per-engagement: uint,
    is-active: bool,
    total-distributed: uint
  }
)

(define-map engagement-history
  {user: principal, target: principal, stacks-block-height: uint}
  {
    engagement-type: (string-ascii 20),
    amount: uint,
    processed: bool
  }
)

(define-map membership-tiers
  uint
  {
    tier-name: (string-ascii 50),
    min-reputation: uint,
    benefits: (string-ascii 200),
    access-level: uint
  }
)

(define-map reputation-nft-metadata
  uint
  {
    owner: principal,
    reputation-score: uint,
    minted-at: uint,
    last-updated: uint
  }
)

(define-map membership-nft-metadata
  uint
  {
    owner: principal,
    tier-level: uint,
    granted-at: uint,
    expires-at: (optional uint)
  }
)

;; HELPER FUNCTIONS

(define-private (min-uint (a uint) (b uint))
  (if (< a b) a b)
)

(define-private (max-uint (a uint) (b uint))
  (if (> a b) a b)
)

;; READ-ONLY FUNCTIONS

(define-read-only (get-user-profile (user principal))
  (map-get? user-profiles user)
)

(define-read-only (get-creator-settings (creator principal))
  (map-get? creator-settings creator)
)

(define-read-only (get-current-reputation (user principal))
  (let (
    (profile (unwrap! (map-get? user-profiles user) (err u0)))
    (last-activity (get last-activity-block profile))
    (current-block stacks-block-height)
    (blocks-since-activity (- current-block last-activity))
    (base-reputation (get reputation-score profile))
  )
    (if (> blocks-since-activity REPUTATION-DECAY-PERIOD)
      (let ((decay-factor (/ blocks-since-activity REPUTATION-DECAY-PERIOD)))
        (if (>= decay-factor base-reputation)
          (ok u0)
          (ok (- base-reputation (min-uint decay-factor base-reputation)))
        )
      )
      (ok base-reputation)
    )
  )
)

(define-read-only (get-membership-tier (tier-id uint))
  (map-get? membership-tiers tier-id)
)

(define-read-only (get-reputation-nft-info (nft-id uint))
  (map-get? reputation-nft-metadata nft-id)
)

(define-read-only (get-membership-nft-info (nft-id uint))
  (map-get? membership-nft-metadata nft-id)
)

(define-read-only (calculate-tier-for-reputation (reputation uint))
  (if (>= reputation u8000)
    u4 ;; Platinum
    (if (>= reputation u5000)
      u3 ;; Gold
      (if (>= reputation u2000)
        u2 ;; Silver
        u1 ;; Bronze
      )
    )
  )
)