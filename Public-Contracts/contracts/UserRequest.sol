// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

interface IuserVerification{
    function chairperson() external view returns (address);  // this is the master address that is verifing the users 
    function VerifiedPerson(address users ) external view returns (bool); // this is to check whether the user is verified or not
    function weight (address _weight ) external view returns (uint256); // this is to check the weight of the user
}


contract UserRequest  {

    IuserVerification public userVerification;   // this is to create an instance and use all the instance that is mentioned in the UserVerification.sol

    struct  Request{ 
        address incommingReq;
        address user;
        uint256 weight;
        bytes32 name;
        uint256 timestamp;
        bool isVerified;  // this is to check whether the user is verified or not
                          // the default vaule is false
    }

    Request[] public Request_; // this is the array of Request

    mapping(address => Request) public _Request;
    
    struct VerificationCount
    {
        uint256 requestCount;
        uint256 verifiedCount;
        uint256 NonverifiedCount;
    }
    
    // address public chairperson;
    mapping (address => uint256)  addvariable;
    
    VerificationCount[] public _VerificationCount;  // this is to store all different verification counts in array

    mapping ( uint256 => VerificationCount) public _VerificationCountMap;

    constructor (address _users) {   // to take all the address (_users) from the UserVerification contract and store it in userverification 
        userVerification = IuserVerification(_users);
    } 
      

    function ToVerify(address _user) public view returns (bool, address) { // this function is to accept the request


        require(_Request[_user].user != address(0), "User is not in the request list"); // this is to check whether the user is in the request list or not

        require (userVerification.VerifiedPerson(_user), "User is not verified");

         if (userVerification.weight(_user) == 1) {  
            return (true, _Request[_user].user);
        } 


          
        revert ("User is not verified");
    }

    modifier onlyChairperson() {
    require(msg.sender == userVerification.chairperson(), "Not authorized: caller is not the chairperson");
    _;
    
    
    }   
        // chairperson = userVerification.chairperson(); // this is to get the chairperson address
            

    function ToAcceptUser(address _user, bytes32 name) public onlyChairperson() returns (address, bytes32, bool, uint256, uint256, uint256, uint256) {  // this function is to verify the user 
            
        require(userVerification.VerifiedPerson(_user), "User is not verified");  // the User is not verified 
        
        Request memory newReq = Request({   // pushes to the Request struct with vaule, Request(main struct) is storing in a new Instence newReq.
            incommingReq: msg.sender,
            user: _user,
            weight: userVerification.weight(_user),
            name: name,
            timestamp: block.timestamp,
            isVerified: false
        });
        Request_.push(newReq);  // to push the values of newreq to the Request_ array
        _Request[_user] = newReq; //  to store the value of the newReq to mapped Request, The _Request is used to store the address value,  in Request_(array) is used used to storea all the references
                                // this is to prevent data loss and inconstincy

        
        _VerificationCount.push(VerificationCount(0,0,0)); // The default value is 0
        uint256 index = _VerificationCount.length - 1; // use the latest VerificationCount
        
        // _Verification.Length gives the number of Members.
        if (_Request[_user].isVerified) {
            _VerificationCount[index].verifiedCount += 1;    // this finalizes the accepted request 
            _Request[_user].isVerified = true;
        } else {
            _VerificationCount[index].NonverifiedCount += 1;
        }
    
        _VerificationCount[index].requestCount += 1;
            
        for (uint256 i = 0; i < _VerificationCount.length; i++) {  
            if (_Request[_user].isVerified) {  // the balue is True then the name is stored 
                _Request[_user].name = name;
            } else {
                revert("only Verified Users name will be stored");
            }
        }
    
        // to Store the timestamp of the TO accept the user.
        for (uint256 i = 0; i < _VerificationCount.length; i++) {
            if (_Request[_user].isVerified) {
                _Request[_user].timestamp = block.timestamp;
            } else {
                revert("only Verified Users timestamp will be stored");
            }
        }
    
        return (
            _Request[_user].user,                   // this is used to be used in the function ToFinalizeReq, to Destructure the funciton, ToAcceptUser
            _Request[_user].name, 
            _Request[_user].isVerified, 
            _Request[_user].timestamp, 
            _VerificationCount[index].requestCount, 
            _VerificationCount[index].verifiedCount, 
            _VerificationCount[index].NonverifiedCount
        );
    } 
    
        function ToFinalizeReq(address _user, bytes32 name) public returns(address, bytes32){
        
        (address userAddr, bytes32 userName, bool verified, uint256 timestamp, uint256 reqCount, uint256 verifiedCount, uint256 nonVerifiedCount) = ToAcceptUser(_user, name );
        

            

        }

    
}


    