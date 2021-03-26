// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

import "./mock/JPYC.sol";

import "hardhat/console.sol";

contract Nozei {
    using SafeMath for uint256;

    event Deposit(address sender, uint256 cryptoCurrencyAmount, uint256 fiatAmount, bytes32 transaction);
    event Withdraw(address sender, uint256 fiatAmount);

    address payable public stableCoinAddress;
    mapping(address => uint256) public balanceOf;
    mapping(address => bytes32[]) public transactions;

    constructor(address payable _stableCoinAddress) {
        stableCoinAddress = _stableCoinAddress;
    }

    function deposit(bytes32 _transaction) public payable {
        require(msg.value > 0, "msg value be more than 0");
        transactions[msg.sender].push(_transaction);
        uint256 current = IERC20(stableCoinAddress).balanceOf(address(this));
        uint256 fiatAmount = IERC20(stableCoinAddress).balanceOf(address(this)).sub(current);
        JPYC(stableCoinAddress).deposit{value: msg.value}();
        balanceOf[msg.sender] = balanceOf[msg.sender].add(fiatAmount);
        emit Deposit(msg.sender, msg.value, fiatAmount, _transaction);
    }

    function withdraw() public payable {
        uint256 amount = balanceOf[msg.sender];
        require(amount > 0, "amount must be more than 0");
        delete balanceOf[msg.sender];
        IERC20(stableCoinAddress).transfer(msg.sender, amount);
        emit Withdraw(msg.sender, amount);
    }
}
