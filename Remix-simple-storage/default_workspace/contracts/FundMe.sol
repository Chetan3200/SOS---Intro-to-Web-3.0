//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./PriceConverter.sol";

contract FundMe {

using PriceConverter for uint256;
    uint256 public minimumUsd = 50 * 1e18;

    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    //constructor is the function that gets called, whenever you deploy a contract
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function fund() public payable{
        // getConversionRate(msg.value);
        require( msg.value.getConversionRate() >= minimumUsd, "Didn't get enough!"); 
        //Here, we are not passing any variable, even though getConversionRate
        //is expecting a variable. Reason: msg.value is considered the first parameter
        //for any of this library function, so it works!
        funders.push(msg.sender);
        //msg.sender, is the address of whoever is calling the function
        addressToAmountFunded[msg.sender] = msg.value;
        //This way, we are keeping track of each sender to the amount funded

    }
    
    //Below function is going to withdraw all the funded money
    //It is also setting the funders amount in the mappign to 0
    function withdraw() public onlyOwner {

        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }

        funders = new address[](0);

        //transfer
        //msg.sender = address
        //payable(msg.sender) = payable address
        //To send etherium, we need to work with payable address
        payable(msg.sender).transfer(address(this).balance);

        //send
        bool sendSuccess = payable(msg.sender).send(address(this).balance);
        require(sendSuccess, "Send Failed");

        //call
        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        // (bool callSuccess, bytes memory dateReturned) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call Failed");
        //call is the recommended way of transfering eth
        
    }

    modifier  onlyOwner {
        require(msg.sender == owner, "sender is not owner!");
        _;
    }
    //modifier is a way of checking if a certain condition is satified before 
    //calling the function
    //underscore represents doing rest of the code
    //if the require was below the _;, it would run the function first and then
    //check the require condtion
}