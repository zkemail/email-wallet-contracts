// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/access/Ownable.sol";
import "./utils/AnonMap.sol";
import "./utils/Constants.sol";
import "./verifier/IGlobalVerifier.sol";

contract Wallets {
    mapping(address => mapping(address => uint256)) public balancesOfWallet;

    struct TransferRequest {
        address token;
        uint amount;
    }

    function _processTransferRequest(
        TransferRequest memory request,
        address[] memory senders,
        address recipient
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
    }
}
