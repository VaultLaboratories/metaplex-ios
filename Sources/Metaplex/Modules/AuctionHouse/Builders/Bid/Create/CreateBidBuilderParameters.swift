//
//  CreateBidBuilderParameters.swift
//  
//
//  Created by Michael J. Huber Jr. on 10/25/22.
//

import AuctionHouse
import Foundation
import Solana

struct CreateBidBuilderParameters {
    // MARK: - Initialization

    private let createBidInput: CreateBidInput
    private let escrowPaymentPda: Pda
    private let buyerTradePda: Pda
    private let defaultIdentity: Signer

    let paymentAccount: PublicKey
    let metadata: PublicKey
    let auctionHouse: PublicKey
    let buyerTokenAccount: PublicKey

    init(
        createBidInput: CreateBidInput,
        escrowPaymentPda: Pda,
        buyerTradePda: Pda,
        defaultIdentity: Signer,
        paymentAccount: PublicKey,
        metadata: PublicKey,
        auctionHouse: PublicKey,
        buyerTokenAccount: PublicKey
    ) {
        self.createBidInput = createBidInput
        self.escrowPaymentPda = escrowPaymentPda
        self.buyerTradePda = buyerTradePda
        self.defaultIdentity = defaultIdentity
        self.paymentAccount = paymentAccount
        self.metadata = metadata
        self.auctionHouse = auctionHouse
        self.buyerTokenAccount = buyerTokenAccount
    }

    // MARK: - Getters

    var shouldPrintReceipt: Bool { createBidInput.printReceipt }
    var receipt: Pda? { shouldPrintReceipt ? try? Bidreceipt.pda(tradeStateAddress: buyerTradeState).get() : nil }
    var buyer: PublicKey { buyerSigner.publicKey }

    // MARK: - Accounts

    var wallet: PublicKey { buyerSigner.publicKey }
    var transferAuthority: PublicKey { buyerSigner.publicKey }
    var treasuryMint: PublicKey { createBidInput.auctionHouse.treasuryMint }
    var escrowPaymentAccount: PublicKey { escrowPaymentPda.publicKey }
    var authority: PublicKey { authoritySigner?.publicKey ?? createBidInput.auctionHouse.authority }
    var auctionHouseFeeAccount: PublicKey { createBidInput.auctionHouse.auctionHouseFeeAccount }
    var buyerTradeState: PublicKey { buyerTradePda.publicKey }
    var auctioneerPda: PublicKey? {
        guard let auctioneerAuthoritySigner else { return nil }
        return try? Auctionhouse.auctioneerPda(
            auctionHouse: auctionHouse,
            auctioneerAuthority: auctioneerAuthoritySigner.publicKey
        ).get()
    }
    var tokenAccount: PublicKey? { createBidInput.tokenAccount }
    var bookkeeper: PublicKey { bookkeeperSigner.publicKey }

    // MARK: - Args

    var tradeStateBump: UInt8 { buyerTradePda.bump }
    var escrowPaymentBump: UInt8 { escrowPaymentPda.bump }
    var buyerPrice: UInt64 { createBidInput.price ?? 0 }
    var tokenSize: UInt64 { createBidInput.tokens ?? 1 }

    // MARK: - Signers

    var buyerSigner: Signer { createBidInput.buyer ?? defaultIdentity }
    var authoritySigner: Signer? { createBidInput.authority }
    var auctioneerAuthoritySigner: Signer? { createBidInput.auctioneerAuthority }
    var bookkeeperSigner: Signer { createBidInput.bookkeeper ?? defaultIdentity }
}
