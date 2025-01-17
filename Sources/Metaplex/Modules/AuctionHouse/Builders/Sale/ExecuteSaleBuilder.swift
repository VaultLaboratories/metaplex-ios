//
//  ExecuteSaleBuilder.swift
//  
//
//  Created by Michael J. Huber Jr. on 10/18/22.
//

import AuctionHouse
import Foundation
import Solana

extension TransactionBuilder {
    static func executeSaleBuilder(parameters: ExecuteSaleBuilderParameters) -> TransactionBuilder {
        // MARK: - Accounts

        let saleAccounts = SaleAccounts(
            buyer: parameters.buyer,
            seller: parameters.seller,
            tokenAccount: parameters.tokenAccount,
            tokenMint: parameters.tokenMint,
            metadata: parameters.metadata,
            treasuryMint: parameters.treasuryMint,
            escrowPaymentAccount: parameters.escrowPaymentAccount,
            sellerPaymentReceiptAccount: parameters.sellerPaymentReceiptAccount,
            buyerReceiptTokenAccount: parameters.buyerReceiptTokenAccount,
            authority: parameters.authority,
            auctionHouseAddress: parameters.auctionHouse,
            auctionHouseFeeAccount: parameters.auctionHouseFeeAccount,
            auctionHouseTreasury: parameters.auctionHouseTreasury,
            buyerTradeState: parameters.buyerTradeState,
            sellerTradeState: parameters.sellerTradeState,
            freeTradeState: parameters.freeTradeState,
            programAsSigner: parameters.programAsSigner
        )

        let saleArgs = SaleArgs(
            escrowPaymentBump: parameters.escrowPaymentBump,
            freeTradeStateBump: parameters.freeTradeStateBump,
            programAsSignerBump: parameters.programAsSignerBump,
            buyerPrice: parameters.buyerPrice,
            tokenSize: parameters.tokenSize
        )

        let partialSaleArgs = ExecutePartialSaleInstructionArgs(
            partialOrderSize: parameters.partialOrderSize,
            partialOrderPrice: parameters.partialOrderPrice,
            args: saleArgs
        )

        // MARK: - Sale Instruction

        var executeSaleInstruction = parameters.isPartialSale ? createExecutePartialSaleInstruction(
            accounts: ExecutePartialSaleInstructionAccounts(accounts: saleAccounts),
            args: partialSaleArgs
        ) : createExecuteSaleInstruction(
            accounts: ExecuteSaleInstructionAccounts(accounts: saleAccounts),
            args: ExecuteSaleInstructionArgs(args: saleArgs)
        )

        var saleSigners: [Signer] = []
        parameters.nft.creators.forEach { creator in
            executeSaleInstruction.append(
                AccountMeta(
                    publicKey: creator.address,
                    isSigner: true,
                    isWritable: false
                )
            )

            if !parameters.isNative,
               let publicKey = PublicKey.findAssociatedTokenAccountPda(
                mint: parameters.treasuryMint,
                owner: creator.address
               ) {
                executeSaleInstruction.append(AccountMeta(publicKey: publicKey, isSigner: true, isWritable: false))
            }
        }

        if let auctioneerAuthoritySigner = parameters.auctioneerAuthoritySigner,
           let auctioneerPda = parameters.auctioneerPda {
            executeSaleInstruction = createAuctioneerExecuteSaleInstruction(
                accounts: AuctioneerExecuteSaleInstructionAccounts(
                    auctioneerAuthority: auctioneerAuthoritySigner.publicKey,
                    auctioneerPda: auctioneerPda,
                    accounts: saleAccounts
                ),
                args: AuctioneerExecuteSaleInstructionArgs(args: saleArgs)
            )
            saleSigners.append(auctioneerAuthoritySigner)
        }

        // MARK: - Receipt Instruction

        let printReceipt: (shouldPrintReceipt: Bool, instruction: InstructionWithSigner?) = {
            guard let receipt = parameters.receipt,
                    let listingReceiptAddress = parameters.listingReceiptAddress,
                    let bidReceiptAddress = parameters.bidReceiptAddress else {
                return (false, nil)
            }

            let printReceiptAccounts = PrintPurchaseReceiptInstructionAccounts(
                purchaseReceipt: receipt.publicKey,
                listingReceipt: listingReceiptAddress,
                bidReceipt: bidReceiptAddress,
                bookkeeper: parameters.bookkeeper,
                instruction: PublicKey.sysvarInstructionsPublicKey
            )
            let printReceiptArgs = PrintPurchaseReceiptInstructionArgs(purchaseReceiptBump: receipt.bump)

            let shouldPrintReciept = parameters.shouldPrintReceipt && !parameters.isPartialSale
            let instruction = InstructionWithSigner(
                instruction: createPrintPurchaseReceiptInstruction(
                    accounts: printReceiptAccounts,
                    args: printReceiptArgs
                ),
                signers: [parameters.bookkeeperSigner],
                key: "printPurchaseReceipt"
            )

            return (shouldPrintReciept, instruction)
        }()

        // MARK: - Transaction Builder

        return TransactionBuilder
            .build()
            .add(
                InstructionWithSigner(
                    instruction: executeSaleInstruction,
                    signers: saleSigners,
                    key: "executeSale"
                )
            )
            .when(
                printReceipt.shouldPrintReceipt,
                instruction: printReceipt.instruction
            )
    }
}
