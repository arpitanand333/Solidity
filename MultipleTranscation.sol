// SPDX-License-Identifier:MIT

pragma solidity ^0.8.4;
contract MultisenderApp {

    function multisendEther(address[] calldata _contributors, uint256[] calldata _balances) external payable {
        uint256 total = msg.value;
        uint256 i = 0;
        for (i; i < _contributors.length; i++) {
            require(total >= _balances[i]);
            assert(total - _balances[i] > 0);
            total = total - _balances[i];
            (bool success, ) = _contributors[i].call{value:_balances[i],gas:2800}("");
            require(success, "Transfer failed.");
        }
    }    
}