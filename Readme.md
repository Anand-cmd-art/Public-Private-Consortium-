Hyperledger fabric
to create a network you need to lay down the policies during the config of the channel(https://hyperledger-fabric.readthedocs.io/en/latest/policies/policies.html    how the policies are difnd in the channel)
create the CAs for the organizations( https://hyperledger-fabric-ca.readthedocs.io/en/latest/deployguide/ca-deploy-topology.html)

create the channels and layout the principles of the channel (https://hyperledger-fabric.readthedocs.io/en/latest/commands/configtxgen.html)

Laydown the MSP for the fabric (https://hyperledger-fabric.readthedocs.io/en/latest/membership/membership.html)


importent pointers 
the transaction context is given by the contract api contractapi.TransactionContext as it provides all the necessary functions for interacting with the world state. Taking directly contractapi.TransactionContext does however pose some problems, what if we were to write unit tests for our contract? We would have to create an instance of that type which would then require a stub instance and would end up making our tests complex. Instead what we can do is take an interface which the transaction context meets; fortunately the contractapi package defines one: contractapi.TransactionContextInterface. This means if we were to write unit tests we could send a mock transaction context which could then be used to track calls or just simplify our test setup. As the function is intended to write rather than return data it will only return the error type.




The Project Flow and the list of things that need to be done.

1) docker
	app
	need to create the contents of app.py	
docker-compose.yaml
to run this file you need flex api, created a app folder that has app.py

2) scripts
	deploy.sh
	need to complete the deploy.sh waiting for completing of smart contract 
	need to add the commands for the private blockchain network
	

3) check if for the number of smartcontracts that are written should we write script files for each of the contracts?

4) edit the Userverifcation in such a way that it can be incoprated in the Cloud federation.						

							                        IMPORTENT NOTE
In many cross-chain designs, the “transfer” step is managed off‑chain via event listeners. When the PropagationContract emits a verification event, a middleware component picks it up and then invokes the corresponding transaction in the private blockchain.

Together, these contracts create a two‑phase process:

Request Reception: The UserRequestContract gathers the consumer’s input.
Verification and Forwarding: The PropagationContract (with or without a dedicated forwarding contract) verifies the request through consortium endorsements and signals that it should now be processed on the private blockchain.






Solidity

addresses: the actors that take part in the contracts.

mapping: is the process that takes one variable type and typecast to another variable type 
	Syntaz:
		mapping(address=>Voter)public voters; // address->variable type 1 Voter-> structure datatype voters -> object of 
												     the mapped vars

Structure: custome datatype that is a collection of other datatetypes
	syntax
	 struct Voter {
		uint256 name;
		bool votedl
		address delegate;
		uint256 vote;
	}
	
	Voter[]public votie;



// this smart contract is orginally used for voting system,
// you can change this voting smart contracts to a verification smart contracts to provide rights and do necessary transactions
// possiably try to intigerate this voting solution in the Cloud Federation.





// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;
contract Voter {    // to make a custome data type
   
   
    struct Voter{
    uint256 weight;
    bool voted;
    address member;
    uint256 vote;
    }


    struct Proposal {
    bytes32 name;
    uint256 voteCount;
}
address chairperson;
Proposal[] public _proposal;
mapping (address => Voter) public _Voter;



constructor (bytes32[] memory  proposalnames)   // this constructor is used to take all the proposal name  in byte32 format
{
    chairperson = msg.sender;  // making it public 
    _Voter[chairperson].weight= 1;

for(uint256 i = 0 ; i < proposalnames.length; i++){   // always when you use i<proposalname.length in "<" when you need to iterate arrays tjat has byte32,string,char...
    _proposal.push(Proposal({
        name: proposalnames,
        voteCount:0
    }));
}

}



 // '==' equals to opperator '=' assignment opperator 

function rightsGiven(address voteraddress) public {                   
    require(msg.sender==chairperson,"only can give rights");

    require(!_Voter[voteraddress].voted,"you have already voded");

    require(_Voter[voteraddress].weight==0,_Voter[voteraddress].weight=1);
    
}

function CastVote(address votedTO) private{
    Voter storage sender = _Voter[msg.sender]; // this is to store all the sender address 

    require(!sender.voted,"you have voted") ; // check the output 

    require(votedTO != msg.sender,"self voting aint allowed son!");
    
    while (_Voter[votedTO].member!=address(0)){
        votedTO =_Voter[votedTO].member;
        require(votedTO != msg.sender,"uh uh uh Loop aint allowed!");
    }

    sender.voted = true;  // we are setting the default value of the addres of the casted votes to true as they already have voted.
    sender.member = votedTO;  // sender.member stores the value of votedTO (meaning the votes that the delegate receive) 
    Voter storage member_ = _Voter[votedTO];  
    if (member_.voted) { //  the member_.voted is false(default value) 
         _proposal[member_.vote].voteCount += sender.weight;  // _proposal[member_.vote].voteCount , _proposal[member_.vote].voteCount = _proposal[member_.vote].voteCount+sender
    } else {
        member_.weight += sender.weight;
    }
}

function vote ( uint proposal_) public {  // to check first whether the person can vote if rights are given.
    Voter storage sender_;
    sender_ = _Voter[msg.sender];
    require(sender_.weight!=0,"You got no rights LOL");
    require(!sender_.voted,"Kitne baar vote karega Bhai");

    sender_.voted=true;
    sender_.vote=proposal_;
    _proposal[proposal_].voutCount+=sender_.weight;

}

function winningDeligate() public view returns(uint256 winingdelegate_){  // the follwing function is used to calculate the winning delegate which is in public bire form and returns a uint254 value
    
    uint256 winningVoteCount = 0;

    for (uint256 i=0; i< _proposal.length; i++){    // the iteration should not be garater than the number of addresses participating in the voting 
        if(_proposal[i].voteCount > winningVoteCount){
            winningVoteCount = _proposal[i].voteCount; 
           winingdelegate_= i;
        }

}    
}

function winnerName() public view returns (bytes32 winnername_){
    winnername_ = _proposal[winningDeligate()].name;
}

}



COMMANDSSSS


