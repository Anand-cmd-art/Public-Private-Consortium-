// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IUserVerification.sol";

contract UserRequest {
    IUserVerification public immutable userVerification;

    struct Request {
        address requester;
        address user;
        uint256 weight;
        bytes32 name;
        bytes32 federationId;
        uint256 timestamp;
        bool isVerified;
    }

    Request[] public requests;
    mapping(address => Request) public requestByUser;

    struct VerificationCount {
        uint256 requestCount;
        uint256 verifiedCount;
        uint256 nonVerifiedCount;
    }

    VerificationCount[] public counts;

    event RequestSubmitted(
        address indexed requester,
        address indexed user,
        bool isVerified,
        uint256 timestamp
    );

    modifier onlyChairperson() {
        require(msg.sender == userVerification.chairperson(), "Not chairperson");
        _;
    }

    constructor(address verificationContract) {
        userVerification = IUserVerification(verificationContract);
    }

    /// @notice Any verified person can submit a request for another user
    function submitRequest(
        address user,
        bytes32 name,
        bytes32 federationId
    ) external {
        require(userVerification.VerifiedPerson(msg.sender), "Not verified");
        bool verified = userVerification.VerifiedPerson(user);

        Request memory req = Request({
            requester: msg.sender,
            user: user,
            weight: userVerification.weight(user),
            name: name,
            federationId: federationId,
            timestamp: block.timestamp,
            isVerified: verified
        });

        requests.push(req);
        requestByUser[user] = req;

        // update counts
        VerificationCount storage vc = counts.push();
        vc.requestCount = 1;
        if (verified) vc.verifiedCount = 1;
        else vc.nonVerifiedCount = 1;

        emit RequestSubmitted(msg.sender, user, verified, block.timestamp);
    }

    /// @notice Chairperson can finalize a request (example usage)
    function finalizeRequest(address user) external onlyChairperson {
        Request storage req = requestByUser[user];
        require(req.user != address(0), "No such request");
        // your finalization logic here...
    }
}
