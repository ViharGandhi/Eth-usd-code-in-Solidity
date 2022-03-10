 // SPDX-License-Identifier: MIT
pragma solidity >=0.6.6 < 0.9.0;
//Importing data feed from chain link for latest price
import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";

contract fundme{

    mapping(address => uint) public addrestoamnt;
    address public owner;
    address[] public funders;
    constructor() public{
        owner = msg.sender;

    }
    function fund() public payable{
        //Lets add minimu value
        uint minimumusd = 50 * 10**18;//eth in wei;
        //Kepping the conditon
        require(getconversionrate(msg.value) >= minimumusd,"You need to spend more eth");
        //Here address of sender is mapped with the value whihc is funded to that address
        addrestoamnt[msg.sender] += msg.value;
        //Adding the sender's address  in array
        funders.push(msg.sender); 
    
    }
    function getversion() public view returns(uint){
        //intialsing the contract 
        AggregatorV3Interface pricefeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);//placing the address of where this contract is  located
        //the above line says that there is contract names "AggregatorV3Interface" which is located at this addreess
        return pricefeed.version();

    }
    //Price of etherum in usd
    function getprice() public view returns(uint){
        AggregatorV3Interface pricefeed =  AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        
      
      (,int256 answer,,,)= pricefeed.latestRoundData();
        return uint256(answer * 10000000000);//here we are converting our answer into dolloer with gwei
    }
    ///Here onne thing to note i am taking the amount not in  ehtereum but in in its lower unit that is wei and gewi.
    function getconversionrate(uint ethamount) public view returns(uint){//here in get eth amount we are acctuall giving it in wei and not in eth
        uint ethprice = getprice();
        uint ethamountinuse = ((ethprice * ethamount)/1000000000000000000);
        return ethamountinuse;

    }
    modifier onlyowner{
         require(msg.sender == owner,"YOU ARE NOT THE OWNER OF THIS ACCOUNT");
         _;
        
    }
    function withdraw() payable onlyowner public{
        //this line of code helps us to verify if this the owner or not
       
        // with this line we say that the tranfer all the balance of fthat address to them
         msg.sender.transfer(address(this).balance);
        //the above  is not a good way of doing this as bczz anyone can withdraw we only want the owner to withdraw and also not to withdraw all the money
        //After withdrawing the funds becomes 0 so doing that
        for(uint i = 0;i<funders.length;i++){
            address funder = funders[i];
            //Here after withdrawl removing the amount from that address
            addrestoamnt[funder] = 0;

        }
        //reseting the funder array
        funders = new address[](0);
    }
  
    
}