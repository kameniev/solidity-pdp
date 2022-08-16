// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

contract Tree {
    bytes32[] public hashes;
    string[4] transactions = [
        "TX1",
        "TX2",
        "TX3",
        "TX4"
    ];

    constructor() {
        for(uint i = 0; i < transactions.length; i++) {
            hashes.push(makeHash(transactions[i]));
        }

        uint count = transactions.length;
        uint offset = 0;

        while(count > 0) {
            for (uint i = 0; i < count - 1; i +=2){
                hashes.push(
                    keccak256(abi.encodePacked(
                        hashes[offset + i], hashes[offset + i + 1]
                    ))
                );
            }
            offset +=count;
            count /= 2;
        }
    }

    // "TX3"
    // 2
    // 0xf02660d266c82b19ed6ebf39ef4c898c5ad5fa8944e2faab2c5bf2c9f3a81d49
    // 0x8e52fa588bdaf33422fa2f2ba5f32d83c3ec755d25196f0f4f4605cbdc7cd2cc
    // 0xf056f9f0bb5fd7833fecc23f27ae82b0afc956b4dd4c8b85b48861d159893083

    function verify(string memory transaction, uint index, bytes32 root, bytes32[] memory proof) public pure returns(bool){
        bytes32 hash = makeHash(transaction);
        for(uint i = 0; i < proof.length; i++) {
            bytes32 element = proof[i];
            if (index % 2 == 0) {
                hash = keccak256(abi.encodePacked(hash, element));
            } else {
                hash = keccak256(abi.encodePacked(element, hash));
            }
            index /= 2;
        }
        return hash == root;
    }

    function encode(string memory input) public pure returns(bytes memory) {
        return abi.encodePacked(input);
    }

    function makeHash(string memory input) public pure returns(bytes32){
        return keccak256(encode(input));
    }
}