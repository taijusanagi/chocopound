// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract JPYC is ERC20 {
    using SafeMath for uint256;

    string private _name = "JPY Coin";
    string private _symbol = "JPYC";

    uint256 constant mockRate = 250;

    uint256 _supplyYen = 100000000e18; /* One-Oku-Yen */

    constructor() ERC20(_name, _symbol) {
        _mint(address(this), _supplyYen);
    }

    receive() external payable {
        deposit();
    }

    function deposit() public payable {
        // this is just mock, so using 1:1 ratio
        _transfer(address(this), msg.sender, msg.value);
    }
}
