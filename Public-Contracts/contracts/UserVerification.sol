// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Voter {
    // Renamed struct to avoid shadowing the contract name.
    struct VoterInfo {
        uint256 weight; // to show whether you have rights or not.
        bool voted;
        address member;
        uint256 vote;
    }

    struct Proposal {    // to accept proposals 
        bytes32 name;
        uint256 voteCount;
    }
    
    address public chairperson;
    Proposal[] public _proposal;
    mapping (address => VoterInfo) public _Voter;  // mapping is used to convert one datatype to another here address is mapped to VoterInfo and has a new name _Voter

    // Constructor takes an array of proposal names in bytes32 format.
    constructor (bytes32[] memory proposalnames) {
        chairperson = msg.sender;  // Set the chairperson.
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
    function rightsGiven(address voteraddress ) public returns( address ) {
        require(msg.sender == chairperson, "Only chairperson can give rights");  // setting the The apex Rights to the chairperson
        require(!_Voter[voteraddress].voted, "You have already voted");  
        require(_Voter[voteraddress].weight == 0, "Voter already has weight");
        _Voter[voteraddress].weight = 1; // increment it by 1 if the require statement fails 
        require(_Voter[voteraddress].weight==1,"You have rights");
        return voteraddress;
    }

    // Private function for casting a vote or delegating.
    function CastVote(address votedTO) public   {   //t the function to vote someone else 
        VoterInfo storage sender = _Voter[msg.sender];  // _Voter[msg.sender] i used to asign address to vote 
        require(!sender.voted, "You have already voted");  
        require(votedTO != msg.sender, "Self voting isn't allowed"); //  self voting is not allowed 
        
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
    function vote(uint proposal_) public {                              // for certain proposals 
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
}
