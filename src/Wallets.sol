// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/access/Ownable.sol";
import "./utils/AnonMap.sol";
import "./utils/Constants.sol";
import "./verifier/IGlobalVerifier.sol";

contract Wallets {
    mapping(address => mapping(address => uint256)) public balancesOfWallet;
    mapping(uint => DeferredTransfer[]) public deferredTransfersOfBlockNumber;
    uint public lastProcessedBlockNumber;

    struct TransferRequest {
        address token;
        uint amount;
    }

    struct DeferredTransfer {
        address token;
        uint amount;
        address sender;
        address recipient;
    }

    constructor() {
        lastProcessedBlockNumber = block.number;
    }

    function _processTransferRequest(
        TransferRequest memory request,
        address[] memory senders,
        address recipient,
        uint deferredBlockNumber
    ) internal {
        uint remaining = request.amount;
        for (uint i = 0; i < senders.length; i++) {
            uint balance = balancesOfWallet[senders[i]][request.token];
            require(balance != 0, "balance must not be zero");
            if (balance >= remaining) {
                balancesOfWallet[senders[i]][request.token] -= remaining;
                remaining = 0;
                break;
            } else {
                balancesOfWallet[senders[i]][request.token] = 0;
                remaining -= balance;
            }
        }
        require(remaining == 0, "balance is not sufficient");
        balancesOfWallet[recipient][request.token] += request.amount;
        if (deferredBlockNumber < type(uint).max) {
            DeferredTransfer memory deferredTransfer = DeferredTransfer(
                request.token,
                request.amount,
                senders[0],
                recipient
            );
            deferredTransfersOfBlockNumber[block.number + deferredBlockNumber]
                .push(deferredTransfer);
        }
    }

    function _refundDeferredTransfers(
        address[] memory recipients,
        bool[] memory isInitialized
    ) internal {
        require(recipients.length == isInitialized.length, "length mismatch");
        uint isInitializedIdx = 0;
        while (lastProcessedBlockNumber <= block.number) {
            for (
                uint i = 0;
                i <
                deferredTransfersOfBlockNumber[lastProcessedBlockNumber].length;
                i++
            ) {
                DeferredTransfer
                    memory deferredTransfer = deferredTransfersOfBlockNumber[
                        lastProcessedBlockNumber
                    ][i];
                require(
                    recipients[isInitializedIdx] == deferredTransfer.recipient,
                    "recipient mismatch"
                );
                if (!isInitialized[isInitializedIdx]) {
                    balancesOfWallet[deferredTransfer.sender][
                        deferredTransfer.token
                    ] += deferredTransfer.amount;
                    balancesOfWallet[deferredTransfer.recipient][
                        deferredTransfer.token
                    ] -= deferredTransfer.amount;
                }
                isInitializedIdx++;
            }
            delete deferredTransfersOfBlockNumber[lastProcessedBlockNumber];
            lastProcessedBlockNumber++;
        }
    }
}
