// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

contract SendEth{

    address payable public recipient;

   

    function checkBal() public view returns(uint){
        return(address(this).balance);
    }

    function SendEther(address _recipient,uint _amount)public payable  {
        recipient = payable(_recipient);
        bool sent = recipient.send(_amount);
        require(sent,"transcation is fail");
    }

    function TRANSFER(address _recipient,uint _amount)public payable {
        recipient = payable(_recipient);
        recipient.transfer(_amount);

    }

    function CALL(address _recipient,uint _amount) public {
        recipient = payable(_recipient);
        (bool sent,) = recipient.call{value:_amount,gas:2800}("");
        require(sent,"transcation is fail");
    }
    // This function directly transfer the ETH to recipient address 
    function callTimeSentEtherToAddress(address _recipient) public payable {
        recipient = payable(_recipient);
        (bool sent,) = recipient.call{value:msg.value,gas:2800}("");
        require(sent,"transcation is fail");
    }
    receive() external payable{}

}