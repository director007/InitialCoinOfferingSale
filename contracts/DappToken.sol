pragma solidity ^0.4.2;

contract DappToken {
    string  public name = "DApp Token";
    string  public symbol = "DAPP";
    string  public standard = "DApp Token v1.0";
    uint256 public totalSupply;

    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 _value
    );
    // event that is triggered when Account A approves Acount B to spend some fixed Dapp tokens on it's behalf
    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    function DappToken (uint256 _initialSupply) public {
        balanceOf[msg.sender] = _initialSupply;
        totalSupply = _initialSupply;
    }
    //Transfer functions transfer tokens from one account to another.
       //It has to return an exception if the number of tokens to be transferred exceed the available no. of tokens in the sender's account
       //it also triggers a trigger event
       //it also returns a boolean value which tells whether a transaction was successful or not



    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value);

        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;

        Transfer(msg.sender, _to, _value);

        return true;
    }
    //this approve function approves account B to spend certain tokens on your behalf(i.e. Account A)
    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;

        Approval(msg.sender, _spender, _value);

        return true;
    }
   
    //this function actually enambles Account B to transfer the allowed number of tokens from account A
    //we will
    //1.Update allowance
    //2.change balance
    //3.transfer event
    //4.return a boolean value
    //5.check whether the Account A has enough token
    //6.check whether the token to be transfered are less than or equal to thae number of token in allowance
      
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value <= balanceOf[_from]);
        require(_value <= allowance[_from][msg.sender]);

        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;

        allowance[_from][msg.sender] -= _value;

        Transfer(_from, _to, _value);

        return true;
    }
}


