//
//  MintTokenBuilderParameters.swift
//  
//
//  Created by Michael J. Huber Jr. on 11/7/22.
//

import Foundation
import Solana

struct MintTokenBuilderParameters {
    let payerSigner: Signer
    let mintSigner: Signer
    let destination: PublicKey
    let mintAuthority: Signer
    let amount: UInt64
    let tokenProgramId: PublicKey

    init(
        payerSigner: Signer,
        mintSigner: Signer,
        destination: PublicKey,
        mintAuthority: Signer? = nil,
        amount: UInt64 = 1,
        tokenProgramId: PublicKey = .tokenProgramId
    ) {
        self.payerSigner = payerSigner
        self.mintSigner = mintSigner
        self.destination = destination
        self.mintAuthority = mintAuthority ?? payerSigner
        self.amount = amount
        self.tokenProgramId = tokenProgramId
    }

    // MARK: - Getters

    var mint: PublicKey { mintSigner.publicKey }
    var authority: PublicKey { mintAuthority.publicKey }
}
