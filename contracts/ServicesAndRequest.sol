// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IUserVerification.sol";

contract Services {
    IUserVerification public immutable userVerification;

    struct ServiceInfo {
        uint256 price;
        bool available;
        address provider;
        string serviceType;
        uint256 qualityScore;  // 0–100
        uint256 timestamp;
    }

    // Map each service ID to its info
    mapping(bytes32 => ServiceInfo) public services;
    // List of all service IDs
    bytes32[] public serviceIds;

    event ServiceAdded(
        bytes32 indexed serviceId,
        address indexed owner,
        address indexed provider,
        string serviceType,
        uint256 price,
        uint256 qualityScore
    );

    constructor(address verificationContract) {
        userVerification = IUserVerification(verificationContract);
    }

    /// @notice Add a new service. Caller and `provider` must both be verified.
    function addService(
        uint256 price,
        bool available,
        address provider,
        string calldata serviceType,
        uint256 qualityScore
    ) external {
        require(userVerification.VerifiedPerson(msg.sender), "You are not verified");
        require(userVerification.VerifiedPerson(provider), "Provider not verified");
        require(price > 0, "Price must be > 0");
        require(qualityScore <= 100, "Quality 0-100");

        bytes32 id = keccak256(
            abi.encodePacked(msg.sender, provider, serviceType, block.timestamp)
        );
        require(services[id].timestamp == 0, "Service already exists");

        services[id] = ServiceInfo({
            price: price,
            available: available,
            provider: provider,
            serviceType: serviceType,
            qualityScore: qualityScore,
            timestamp: block.timestamp
        });
        serviceIds.push(id);

        emit ServiceAdded(id, msg.sender, provider, serviceType, price, qualityScore);
    }

    /// @notice Fetch all service IDs
    function getAllServiceIds() external view returns (bytes32[] memory) {
        return serviceIds;
    }
}
