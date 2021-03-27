// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/proxy/Clones.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/cryptography/draft-EIP712.sol";

contract RoyalityBoxFactory is EIP712 {
    using Address for address;
    using Clones for address;
    using ECDSA for bytes32;

    event Deployed(
        address indexed deployedContract,
        address indexed implementation,
        address indexed owner,
        bytes32 salt,
        uint256 royaltyRatio,
        uint256 price,
        string name,
        string symbol
    );

    constructor(string memory _name, string memory _version) EIP712(_name, _version) {}

    function verifyTypedSig(
        address _implementation,
        address _owner,
        bytes32 _salt,
        uint256 _royaltyRatio,
        uint256 _price,
        string memory _name,
        string memory _symbol,
        bytes memory _signature
    ) public view returns (bool) {
        bytes32 digest =
            _hashTypedDataV4(
                keccak256(
                    abi.encode(
                        keccak256(
                            "RoyaltyBox(address implementation,uint256 salt,uint256 royaltyRatio,uint256 price,string name,string symbol)"
                        ),
                        _implementation,
                        _salt,
                        _royaltyRatio,
                        _price,
                        keccak256(bytes(_name)),
                        keccak256(bytes(_symbol))
                    )
                )
            );
        address recovered = digest.recover(_signature);
        return _owner == recovered;
    }

    function deploy(
        address _implementation,
        address _owner,
        bytes32 _salt,
        uint256 _royaltyRatio,
        uint256 _price,
        string memory _name,
        string memory _symbol,
        bytes memory _signature
    ) public payable {
        require(
            verifyTypedSig(_implementation, _owner, _salt, _royaltyRatio, _price, _name, _symbol, _signature),
            "signature must be valid"
        );
        bytes memory data =
            abi.encodeWithSignature(
                "initialize(address,uint256,uint256,string,string)",
                _owner,
                _royaltyRatio,
                _price,
                _name,
                _symbol
            );
        bytes32 salt = keccak256(abi.encodePacked(_salt, _owner));
        address deployedContract = _implementation.cloneDeterministic(salt);
        deployedContract.functionCallWithValue(data, msg.value);
        emit Deployed(deployedContract, _implementation, _owner, _salt, _royaltyRatio, _price, _name, _symbol);
    }

    function predictDeployResult(
        address _implementation,
        address _owner,
        bytes32 _salt
    ) public view returns (address) {
        bytes32 salt = keccak256(abi.encodePacked(_salt, _owner));
        return _implementation.predictDeterministicAddress(salt, address(this));
    }
}
