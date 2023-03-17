//
//  CreateCandyMachineInput.swift
//  
//
//  Created by Michael J. Huber Jr. on 11/3/22.
//

import CandyMachine
import Foundation
import Solana

struct CreateCandyMachineInput {
    let candyMachine: Signer
    let wallet: Signer?
    let payer: Signer?
    let authority: Signer?
    let collection: PublicKey?
    let tokenMint: PublicKey?
    let candyMachineConfig: CandyMachineConfig

    init(
        candyMachine: Signer = HotAccount()!,
        wallet: Signer? = nil,
        payer: Signer? = nil,
        authority: Signer? = nil,
        collection: PublicKey? = nil,
        tokenMint: PublicKey? = nil,
        candyMachineConfig: CandyMachineConfig
    ) {
        self.candyMachine = candyMachine
        self.wallet = wallet
        self.payer = payer
        self.authority = authority
        self.collection = collection
        self.tokenMint = tokenMint
        self.candyMachineConfig = candyMachineConfig
    }

    // MARK: - Getters

    var data: CandyMachineData {
        CandyMachineData(
            address: candyMachine.publicKey,
            config: candyMachineConfig
        )
    }

    var accountSize: UInt64 {
        Candymachine.getAccountSizeFrom(data)
    }
}
