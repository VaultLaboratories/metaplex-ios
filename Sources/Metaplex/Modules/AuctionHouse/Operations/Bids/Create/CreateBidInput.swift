//
//  CreateBidInput.swift
//  
//
//  Created by Michael J. Huber Jr. on 10/26/22.
//

import AuctionHouse
import Foundation
import Solana

struct CreateBidInput {
    let auctionHouse: AuctionhouseArgs
    let buyer: Signer?
    let authority: Signer?
    let auctioneerAuthority: Signer?
    let mintAccount: PublicKey
    let seller: PublicKey?
    let tokenAccountAddress: PublicKey?
    let price: UInt64?
    let tokens: UInt64?
    let printReceipt: Bool
    let bookkeeper: Signer?

    init(
        auctionHouse: AuctionhouseArgs,
        buyer: Signer? = nil,
        authority: Signer? = nil,
        auctioneerAuthority: Signer? = nil,
        mintAccount: PublicKey,
        seller: PublicKey? = nil,
        tokenAccountAddress: PublicKey? = nil,
        price: UInt64? = 0,
        tokens: UInt64? = 1,
        printReceipt: Bool = true,
        bookkeeper: Signer? = nil
    ) {
        self.auctionHouse = auctionHouse
        self.buyer = buyer
        self.authority = authority
        self.auctioneerAuthority = auctioneerAuthority
        self.mintAccount = mintAccount
        self.seller = seller
        self.tokenAccountAddress = tokenAccountAddress
        self.price = price
        self.tokens = tokens
        self.printReceipt = printReceipt
        self.bookkeeper = bookkeeper
    }

    // MARK: - Helpers

    var tokenAccount: PublicKey? {
        let tokenAccountPda: (PublicKey?) -> PublicKey? = { seller in
            if let seller {
                return PublicKey.findAssociatedTokenAccountPda(mint: mintAccount, owner: seller)
            }
            return nil
        }
        return tokenAccountAddress ?? tokenAccountPda(seller)
    }
}
