// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IUserVerification {
    function chairperson() external view returns (address);
    function VerifiedPerson(address user) external view returns (bool);
    function weight(address user) external view returns (uint256);
}
