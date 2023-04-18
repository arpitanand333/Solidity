// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/utils/SafeERC20.sol";


library SafeMath {
   
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
   
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
   
        require(b > 0, errorMessage);
        uint256 c = a / b;

        return c;
    }


    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }


    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

contract StakingContract{

    using SafeMath for uint;
    using SafeERC20 for IERC20;

    IERC20 public myPool; 
    
    uint256 private totalSupply;
    uint256 public starttime = 1648025297;
    uint256 public withdrawInterval = 10;
    uint public id =0;
    uint256[] public _amount;
    int ticketCount =0;
    

    mapping(address => uint256) public lastStakedAmount;// last time staked amount by the address
    mapping(address => uint256) public balances;        // it will Map balances of address
    mapping(uint => mapping(address => uint256)) public stakedTime;   // mapping id & address with staked time.
    mapping(uint => uint)public amountStaked;  //  which id stake how much amount of token.
    mapping(address => uint[])public addrToId;   // here address is mapping to the id.
    mapping(address => int) public Ticketcount;



    event Staked(address indexed user, uint256 amount);

    constructor(address _myPool){
        myPool = IERC20(_myPool);
    }

   

    function stake(uint256 amount) public returns(uint){
        require(amount > 100,"you can con't stake less than 100 tokens");   // first time staking amount should be 100 or more than 100.
        require(amount > lastStakedAmount[msg.sender],"error is here");     // 
        totalSupply = totalSupply.add(amount);
        balances[msg.sender] = balances[msg.sender].add(amount);
        stakedTime[id][msg.sender] = block.timestamp;
        lastStakedAmount[msg.sender] = amount;
        myPool.safeTransferFrom(msg.sender, address(this), amount);
        emit Staked(msg.sender, amount);
        amountStaked[id] = amount;
        addrToId[msg.sender].push(id);
        id++;
        return id;
    
    }

    function withdraw(uint256 amount,uint _id) public {
       
        //require(leftTime >= withdrawInterval , "Can remove stake once 24 Hour is over");
        require( withdrawInterval.add(stakedTime[_id][msg.sender]) < block.timestamp,"Problem is here");
        totalSupply = totalSupply.sub(amount);
        balances[msg.sender] = balances[msg.sender].sub(amount);
        myPool.safeTransfer(msg.sender, amount);
    }


    function stakedDetails(uint _id)public view returns(uint,uint){
        return (amountStaked[_id], stakedTime[_id][msg.sender]);
    }


    function stakedDetailId(address _stakedAddr)public view returns(uint[] memory){
        return (addrToId[_stakedAddr]);
    }


    function stakedDetailAmount(address _stakedAddr)public returns(uint256[] memory){
        for(uint i=0;i<addrToId[_stakedAddr].length;i++){
            _amount.push(amountStaked[i]);
        }
        return _amount;
    }

    function stakeTimeOver(uint _id, address _account)public {
        if(block.timestamp > (stakedTime[_id][_account]).add(withdrawInterval)){
            Ticketcount[_account] = ticketCount++;

        }
    }

}

