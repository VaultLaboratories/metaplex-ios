//
//  CreateTokenWithMintBuilderParameters.swift
//  
//
//  Created by Michael J. Huber Jr. on 11/7/22.
//

import Foundation
import Solana

struct CreateTokenWithMintBuilderParameters {
    let payerSigner: Signer
    let mintSigner: Signer
    let associatedAccount: PublicKey

    init(
        payerSigner: Signer,
        mintSigner: Signer,
        associatedAccount: PublicKey
    ) {
        self.payerSigner = payerSigner
        self.mintSigner = mintSigner
        self.associatedAccount = associatedAccount
    }

    // MARK: - Getters

    var createMintParameters: CreateMintBuilderParameters {
        CreateMintBuilderParameters(
            payerSigner: payerSigner,
            mintSigner: mintSigner
        )
    }

    var createTokenParameters: CreateTokenBuilderParameters {
        CreateTokenBuilderParameters(
            payerSigner: payerSigner,
            mint: mintSigner.publicKey,
            associatedAccount: associatedAccount
        )
    }

    var mintTokenParameters: MintTokenBuilderParameters {
        MintTokenBuilderParameters(
            payerSigner: payerSigner,
            mintSigner: mintSigner,
            destination: associatedAccount
        )
    }
}
