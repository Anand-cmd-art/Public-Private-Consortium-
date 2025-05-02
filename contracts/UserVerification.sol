// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IUserVerification.sol";

contract UserVerification is IUserVerification {
    struct VoterInfo {
        uint256 weight;
        bool voted;
        address delegate;
        uint256 vote;
    }

    struct Proposal {
        bytes32 name;
        uint256 voteCount;
    }

    address public override chairperson;
    mapping(address => VoterInfo) public voters;
    Proposal[] public proposals;

    constructor(bytes32[] memory proposalNames) {
        chairperson = msg.sender;
        // Chairperson gets initial weight = 1
        voters[chairperson].weight = 1;

        // Populate proposals
        for (uint i = 0; i < proposalNames.length; i++) {
            proposals.push(Proposal({
                name: proposalNames[i],
                voteCount: 0
            }));
        }
    }

    /// @notice Returns true if user has weight == 1
    function VerifiedPerson(address user) external view override returns (bool) {
        return voters[user].weight == 1;
    }

    function weight(address user) external view override returns (uint256) {
        return voters[user].weight;
    }

    /// @notice Give voting/verification rights to `voter`. Only chairperson may call.
    function grantRights(address voter) external {
        require(msg.sender == chairperson, "Only chairperson");
        require(!voters[voter].voted, "Already voted");
        require(voters[voter].weight == 0, "Already has rights");
        voters[voter].weight = 1;
    }

    /// @notice Delegate your vote to `to`
    function delegate(address to) external {
        VoterInfo storage sender = voters[msg.sender];
        require(!sender.voted, "You already voted");
        require(to != msg.sender, "Cannot self-delegate");

        // Follow delegation chain
        while (voters[to].delegate != address(0)) {
            to = voters[to].delegate;
            require(to != msg.sender, "Loop in delegation");
        }

        sender.voted = true;
        sender.delegate = to;
        if (voters[to].voted) {
            // If `to` already voted, directly add to that proposal
            proposals[voters[to].vote].voteCount += sender.weight;
        } else {
            // Otherwise add weight to delegate
            voters[to].weight += sender.weight;
        }
    }

    /// @notice Cast your vote to proposal `proposalIndex`
    function vote(uint proposalIndex) external {
        VoterInfo storage sender = voters[msg.sender];
        require(sender.weight != 0, "No right to vote");
        require(!sender.voted, "Already voted");
        sender.voted = true;
        sender.vote = proposalIndex;
        proposals[proposalIndex].voteCount += sender.weight;
    }

    /// @notice Returns winning proposal index
    function winningProposal() public view returns (uint256 winningIndex) {
        uint256 highestCount;
        for (uint i = 0; i < proposals.length; i++) {
            if (proposals[i].voteCount > highestCount) {
                highestCount = proposals[i].voteCount;
                winningIndex = i;
            }
        }
    }

    /// @notice Returns name of the winning proposal
    function winnerName() external view returns (bytes32) {
        return proposals[winningProposal()].name;
    }
}
