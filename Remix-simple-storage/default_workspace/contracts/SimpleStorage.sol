// SPDX-License-Identifier: MIT // Optional, but some compilers may flag you a warning if you don't have one
// pragma solidity >=0.8.7 <0.9.0; //Any version between the 2 will work.
// pragma solidity ^0.8.7; //Any version above this will work.
pragma solidity ^0.8.7; //Every complete sentence needs to end with ;

contract SimpleStorage {
    //boolean, uint, int, address, bytes
    //This gets initialized to zero.
    uint256 public favoriteNumber;

    People[] public people; 

    mapping(string => uint256) public nameToFavoriteNumber;

    struct People {
        uint256 favoriteNumber;
        string name;
    }

    function store(uint256 _favoriteNumber) public {
        favoriteNumber = _favoriteNumber;
    }

    function retrieve() public view returns(uint256) {
        return favoriteNumber;
    }

    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        People memory newPeople = People(_favoriteNumber, _name);
        people.push(newPeople);
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }
}

//0xd9145CCE52D386f254917e481eB44e9943F39138
//When we deploy a contract, its actually the same as sending a transaction
//Deploying a contract is modifying the blockchain to have this contract
//If we had deployed it on a real network, it would have cost us Gas
