// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.4;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
interface IWETHGateway {
    function depositETH(
        address lendingPool,
        address onBehalfOf,
        uint16 referralCode
    ) external payable;
    function withdrawETH(
        address lendingPool,
        uint256 amount,
        address onBehalfOf
    ) external;
    function repayETH(
        address lendingPool,
        uint256 amount,
        uint256 rateMode,
        address onBehalfOf
    ) external payable;
    function borrowETH(
        address lendingPool,
        uint256 amount,
        uint256 interesRateMode,
        uint16 referralCode
    ) external;
    function getWETHAddress() external view returns (address);
}
interface IPoolAddressesProvider {
    function getLendingPool() external view returns (address);
}
contract ICOLaunchpad is ReentrancyGuard{
    using SafeMath for uint;
    address private manager;
    address poolAddress;
    IWETHGateway ethContract;
    event lProject(address _projectAdd,uint noTokens,uint _rate,uint _Tokens,uint sD,uint eD);
    event cal(uint );
    event buyT (address buyer,uint numberofTokens);
    event refundevent(address paddress,address baddress,uint amount);
    event fundtransferevent(address paddress,address tokenOwneraddress,uint amount,uint remainingToken);
    struct Project{
        address projectAdd;
        address payable owner;
        string description;
        uint startDate;
        uint endDate;
        uint listDate;
        uint targetAmount;
        uint noTokens;
        uint rate;
        uint Tokens;
        uint amountGenerated;
    }
    struct buyerData{
        // address buyer;
        uint amount;
        uint tokens;
        uint date ;
        // bool refund;
        // bool reward;
    }
    mapping(address => Project) public projects;
    // mapping(address => buyerData) public buyers;
    Project[] public  parr;
    mapping(address => mapping (address=>buyerData)) public buyers;
    constructor(){
        manager = msg.sender;
    }
     modifier onlyManger{
        require(manager == msg.sender,"Only authorize manager access it");
        _;
    }
    modifier lock1(address _projectAdd){
        Project storage p = projects[_projectAdd];
        uint timePeriod = 60 + p.endDate;
        require(block.timestamp > timePeriod);
        _;
    }
    function listProject(address _projectAdd,uint noTokens,uint _rate,uint _Tokens,uint sD,uint eD) external {
        Project  storage newP = projects[_projectAdd];
        newP.projectAdd = _projectAdd;
        newP.owner = payable(msg.sender);
        newP.listDate = block.timestamp;
        newP.startDate = sD;
        newP.endDate = eD;
        newP.rate = _rate;
        newP.Tokens = _Tokens;
        parr.push(newP);
        IERC20(_projectAdd).transferFrom(msg.sender,address(this),noTokens);
        emit lProject (_projectAdd,noTokens, _rate, _Tokens, sD, eD);
    }
    function caculate(uint amountTokens,address _projectAdd) external  {
         Project  storage p = projects[_projectAdd];
        uint amount =amountTokens;
        // p.amountGenerated += msg.value;
        // contributors[_projectAdd][msg.sender].amount = amountTokens;
        uint eth = amount.mul(p.rate);
        eth = eth.div(p.Tokens);
        emit cal (eth);
    }
    function BuyToken(address _projectAdd) public payable{
        Project  storage p = projects[_projectAdd];
        require(block.timestamp > p.startDate);
        require(block.timestamp < p.endDate);
        uint amount =msg.value;
        p.amountGenerated += msg.value;
        buyers[_projectAdd][msg.sender].amount = msg.value;
        uint noTokens = amount.mul(p.Tokens);
        noTokens = noTokens.div(p.rate);
        buyers[_projectAdd][msg.sender].tokens= noTokens;
        buyers[_projectAdd][msg.sender].date = block.timestamp;
        // emit Fproject(msg.sender,noTokens);
        IERC20(_projectAdd).transfer(msg.sender,noTokens);
        emit buyT (msg.sender,noTokens);
    }
    function refund(address _projectAdd,address buyeradd) external{
        Project  storage p = projects[_projectAdd];
        require(block.timestamp > p.startDate);
        require(block.timestamp < p.endDate);
        buyerData storage b = buyers[_projectAdd][msg.sender];
        require( b.amount > 0);
        address payable buyer = payable(msg.sender);
        IERC20(_projectAdd).transferFrom(msg.sender,address(this),b.tokens);
        buyer.transfer(b.amount);
        b.amount=0;
        emit refundevent(_projectAdd,buyeradd,b.amount);
    }
    receive() external payable {
    }
    function fundTransfer(address _projectAdd) public lock1(_projectAdd){
        Project storage p = projects[_projectAdd];
        require(p.owner == msg.sender);
        p.owner.transfer(p.amountGenerated);
        p.amountGenerated = 0;
        IERC20(_projectAdd).transfer(msg.sender,IERC20(_projectAdd).balanceOf(address(this)));
        uint remainingT = IERC20(_projectAdd).balanceOf(address(this));
        emit fundtransferevent(_projectAdd,msg.sender,p.amountGenerated,remainingT);
    }
    function depositETH() public payable onlyManger{
        poolAddress = IPoolAddressesProvider(0x88757f2f99175387aB4C6a4b3067c77A695b0349).getLendingPool();
        ethContract = IWETHGateway(0xA61ca04DF33B72b235a8A28CfB535bb7A5271B70);
        ethContract.depositETH{value: address(this).balance}(poolAddress, address(this), 0);
    }
    function withdrawETH(uint256 _amount) public onlyManger{
        IERC20(0x87b1f4cf9BD63f7BBD3eE1aD04E8F52540349347).approve(
            0xA61ca04DF33B72b235a8A28CfB535bb7A5271B70,
            _amount
        );
        ethContract.withdrawETH(poolAddress, _amount,address(this));
        uint profit = address(this).balance.sub(_amount);
        payable(manager).transfer(profit);
    }
    function cbalance(address add)external view returns(uint){
        return add.balance;
    }
}