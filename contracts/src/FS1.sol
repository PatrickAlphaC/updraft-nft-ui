// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Challenge} from "lib/ctf/src/protocol/Challenge.sol";

contract FS1 is Challenge {
    constructor(address registry) Challenge(registry, ATTRIBUTE, DESCRIPTION, IMAGE_URI) {}

    /**
     * CALL THIS FUNCTION!
     *
     * @param yourTwitterHandle - Your twitter handle. Can be a blank string.
     */
    function solveChallenge(string memory yourTwitterHandle) external {
        _updateAndRewardSolver(yourTwitterHandle);
    }

    /*//////////////////////////////////////////////////////////////
                                HELPERS
    //////////////////////////////////////////////////////////////*/
    string private constant ATTRIBUTE = "Getting learned!";
    string private constant DESCRIPTION = "Section 1: Blockchain Basics";
    string private constant IMAGE_URI = "ipfs://QmYNk9TaRp9QDRjDZYxrwh5xQGMeC9zY23tB4fs5qby6KT";
}
