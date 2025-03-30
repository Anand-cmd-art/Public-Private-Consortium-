// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

interface IuserVerification{
    function chairperson() external view returns (address);
    function VerifiedPerson(address user) external  view returns (bool);
}


contract Services{
     IuserVerification public immutable userVerification;

 struct userService{
        uint256 price;
        bool available;
        address provider;      
        string serviceType;
        uint256 qualityScore;  
        uint256 timestamp;
 }

mapping (address => userService) public userServices;

constructor (address _users) {
    userVerification= IuserVerification(_users);
}

bytes32[] public serviceId;

function addService( uint256 _price, bool _availablity, address _provider, string memory _serviceType, uint256 _qualityScore) public {
    require(userVerification.VerifiedPerson(msg.sender), "CSP not verified");
    require(userVerification.VerifiedPerson(_provider), "Provider not verified");
    require(_price > 0, "Price must be greater than 0");
    require(_qualityScore <= 100, "Quality score must be 0-100");
    // require(userVerification.chairperson() == msg.sender, "Only chairperson can add service");
    bytes32 id = keccak256(abi.encodePacked(msg.sender, _provider, _serviceType));
    serviceId.push(id);
    require(userServices[msg.sender].timestamp == 0, "Service already added");

    userServices[id] = userService({
        price: _price,
        available: _availablity,
        provider: _provider,
        serviceType: _serviceType,
        qualityScore: _qualityScore,
        timestamp: block.timestamp
    });
    serviceId.push(id);   
}