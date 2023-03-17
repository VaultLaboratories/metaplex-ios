//
//  CreateTokenBuilderParameters.swift
//  
//
//  Created by Michael J. Huber Jr. on 11/7/22.
//

import Foundation
import Solana

struct CreateTokenBuilderParameters {
    let payerSigner: Signer
    let owner: PublicKey
    let mint: PublicKey
    let associatedAccount: PublicKey
    let newAccountSigner: Signer?
    let programId: PublicKey
    let associatedProgramId: PublicKey

    init(
        payerSigner: Signer,
        owner: PublicKey? = nil,
        mint: PublicKey,
        associatedAccount: PublicKey,
        newAccountSigner: Signer? = nil,
        programId: PublicKey = .tokenProgramId,
        associatedProgramId: PublicKey = .splAssociatedTokenAccountProgramId
    ) {
        self.payerSigner = payerSigner
        self.owner = owner ?? payerSigner.publicKey
        self.mint = mint
        self.associatedAccount = associatedAccount
        self.newAccountSigner = newAccountSigner
        self.programId = programId
        self.associatedProgramId = associatedProgramId
    }

    // MARK: - Getters

    var payer: PublicKey { payerSigner.publicKey }

    var createAccountParameters: CreateAccountBuilderParameters {
        CreateAccountBuilderParameters(
            payerSigner: payerSigner,
            lamports: MIN_RENT_FOR_ACCOUNT,
            space: ACCOUNT_SIZE
        )
    }
}
