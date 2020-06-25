pragma solidity ^0.4.2;

import "./DappToken.sol";

contract DappTokenSale {
    // here we have not set the admin to public because we don't want to reveal the identity of the admin account. This is why we have no written the test for checking admin.
    address admin;
    //We are adding a refernce to our DappToken contract in this TokenSaleContract
    DappToken public tokenContract;
    uint256 public tokenPrice;
    uint256 public tokensSold;

    event Sell(address _buyer, uint256 _amount);

    function DappTokenSale(DappToken _tokenContract, uint256 _tokenPrice) public {
        //Assign an admin
        admin = msg.sender;
        tokenContract = _tokenContract;
        tokenPrice = _tokenPrice;
    }
    //internal keyword is specifying that this function can't be accessed outside this smart contract
    //pure keyword means that this function does not read/write data from and to the blockchain
    function multiply(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x);
    }
    //The function is defined as payable because we want someone to send ether via transaction with this function 
    function buyTokens(uint256 _numberOfTokens) public payable {
        
        
        
        //Require that value is equal to tokens
        require(msg.value == multiply(_numberOfTokens, tokenPrice));

        //require that contract has enough token. This keyword here is used to say that we need to know
        //the number of tokens in this smart contract
        require(tokenContract.balanceOf(this) >= _numberOfTokens);

        //require that a transfer is successful
        require(tokenContract.transfer(msg.sender, _numberOfTokens));

    //keep track of number of token solds
        tokensSold += _numberOfTokens;
    //Calling the sell event
        Sell(msg.sender, _numberOfTokens);
    }

    function endSale() public {
        //only admin can do this
       
        require(msg.sender == admin);
         //transfer remainning tokens to the admin
        require(tokenContract.transfer(admin, tokenContract.balanceOf(this)));
    //destroy contract.It basically resets all the global variables to their initial value.
        selfdestruct(admin);
    }
}
