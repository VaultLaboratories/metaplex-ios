//
//  CreateAccountBuilderParameters.swift
//  
//
//  Created by Michael J. Huber Jr. on 11/7/22.
//

import Foundation
import Solana

struct CreateAccountBuilderParameters {
    let payerSigner: Signer
    let newAccountSigner: Signer
    let lamports: UInt64
    let space: UInt64
    let program: PublicKey

    init(
        payerSigner: Signer,
        newAccountSigner: Signer = HotAccount()!,
        lamports: UInt64,
        space: UInt64,
        program: PublicKey = .tokenProgramId
    ) {
        self.payerSigner = payerSigner
        self.newAccountSigner = newAccountSigner
        self.lamports = lamports
        self.space = space
        self.program = program
    }

    //  MARK: - Getters

    var payer: PublicKey { payerSigner.publicKey }
    var newAccount: PublicKey { newAccountSigner.publicKey }
}
