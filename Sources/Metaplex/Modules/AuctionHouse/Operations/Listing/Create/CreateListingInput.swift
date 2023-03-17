//
//  CreateListingInput.swift
//  
//
//  Created by Michael J. Huber Jr. on 10/26/22.
//

import AuctionHouse
import Foundation
import Solana

struct CreateListingInput {
    let auctionHouse: AuctionhouseArgs
    let seller: Signer?
    let authority: Signer?
    let auctioneerAuthority: Signer?
    let mintAccount: PublicKey
    let tokenAccount: PublicKey?
    let price: UInt64
    let tokens: UInt64
    let printReceipt: Bool
    let bookkeeper: Signer?

    init(
        auctionHouse: AuctionhouseArgs,
        seller: Signer? = nil,
        authority: Signer? = nil,
        auctioneerAuthority: Signer? = nil,
        mintAccount: PublicKey,
        tokenAccount: PublicKey? = nil,
        price: UInt64,
        tokens: UInt64 = 1,
        printReceipt: Bool = true,
        bookkeeper: Signer? = nil
    ) {
        self.auctionHouse = auctionHouse
        self.seller = seller
        self.authority = authority
        self.auctioneerAuthority = auctioneerAuthority
        self.mintAccount = mintAccount
        self.tokenAccount = tokenAccount
        self.price = price
        self.tokens = tokens
        self.printReceipt = printReceipt
        self.bookkeeper = bookkeeper
    }
}
