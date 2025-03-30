// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IuserVerification {
    function chairperson() external view returns (address);  // the master address verifying the users
    function VerifiedPerson(address users) external view returns (bool); // checks whether a user is verified
    function weight(address _user) external view returns (uint256); // returns the weight of the user
}

contract UserVerification is IuserVerification {
    // Renamed struct to avoid shadowing the contract name.
    struct VoterInfo {
        uint256 weight; // shows whether you have voting rights (1) or not (0)
        bool voted;
        address member;
        uint256 vote;
    }

    struct Proposal {
        bytes32 name;
        uint256 voteCount;
    }
    
    // The chairperson is the one who can give voting rights.
    address public override chairperson;
    Proposal[] public _proposal;
    mapping (address => VoterInfo) public _Voter;

    // Constructor takes an array of proposal names in bytes32 format.
    constructor(bytes32[] memory proposalnames) {
        chairperson = msg.sender; // Set the chairperson.
        _Voter[chairperson].weight = 1;

        // Populate the proposals array.
        for (uint256 i = 0; i < proposalnames.length; i++) {
            _proposal.push(Proposal({
                name: proposalnames[i],
                voteCount: 0
            }));
        }
    }

    // Give rights to vote.
    function rightsGiven(address voteraddress) public returns (address) {
        require(msg.sender == chairperson, "Only chairperson can give rights");
        require(!_Voter[voteraddress].voted, "You have already voted");
        require(_Voter[voteraddress].weight == 0, "Voter already has weight");
        _Voter[voteraddress].weight = 1;
        require(_Voter[voteraddress].weight == 1, "You have rights");
        return voteraddress;
    }

    // Private function for casting a vote or delegating.
    function CastVote(address votedTO) public {
        VoterInfo storage sender = _Voter[msg.sender];
        require(!sender.voted, "You have already voted");
        require(votedTO != msg.sender, "Self voting isn't allowed");
        
        // Follow the delegation chain.
        while (_Voter[votedTO].member != address(0)) {
            votedTO = _Voter[votedTO].member;
            require(votedTO != msg.sender, "Loop delegation is not allowed");
        }

        sender.voted = true;
        sender.member = votedTO;
        VoterInfo storage member_ = _Voter[votedTO];
        if (member_.voted) {
            _proposal[member_.vote].voteCount += sender.weight;
        } else {
            member_.weight += sender.weight;
        }
    }

    // Public function to cast a vote.
    function vote(uint proposal_) public {
        VoterInfo storage sender_ = _Voter[msg.sender];
        require(sender_.weight != 0, "You have no right to vote");
        require(!sender_.voted, "You have already voted");

        sender_.voted = true;
        sender_.vote = proposal_;
        _proposal[proposal_].voteCount += sender_.weight;
    }

    // Function to determine the winning delegate.
    function winningDeligate() public view returns (uint256 winingdelegate_) {
        uint256 winningVoteCount = 0;
        for (uint256 i = 0; i < _proposal.length; i++) {
            if (_proposal[i].voteCount > winningVoteCount) {
                winningVoteCount = _proposal[i].voteCount;
                winingdelegate_ = i;
            }
        }
    }

    // Function to return the winner's name.
    function winnerName() public view returns (bytes32 winnername_) {
        winnername_ = _proposal[winningDeligate()].name;
    }

    // --- Functions required by IuserVerification interface ---

    /// @notice Checks if a user is verified (i.e., has been given voting rights).
    /// @param user The address to check.
    /// @return True if the user's weight is 1, otherwise false.
    function VerifiedPerson(address user) external view override returns (bool) {
        return _Voter[user].weight == 1;
    }

    /// @notice Returns the voting weight of the specified user.
    /// @param _user The address to check.
    /// @return The weight of the user.
    function weight(address _user) external view override returns (uint256) {
        return _Voter[_user].weight;
    }
}
