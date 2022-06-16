// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract Voting {

    struct Voter{
        bool isAVoter;
        string voterName;
        address voterAddress;
        bool voted;
    }


   struct Vote{
        address voterAddress;
        string symbol;
    }

    struct Candidate{
        string candidateName;
        address candidateAddress;
        uint256 numberOfVotes;
        string symbol;
    }

    mapping (address => Voter) public AddressToVoter;
    mapping (address => Vote) public AddressToVote;


    mapping (uint256 => Vote) Votes;


    mapping (uint256 => address) public VoterList;
    mapping (uint256 => string) public CandidateList;
    mapping (string => Candidate) public SymbolToCandidate;

    mapping (string => uint256) public symbolToVotes;


    uint256 public candidatesCount;


    uint256 public totalVoters;
    uint256 public totalVotes;

    enum State { Created, Voting, Ended }
    State public state;

    address public OragnizerAddress;      
    string public  ElectionName;


    constructor(string memory _electionName){
        OragnizerAddress = msg.sender;
        ElectionName = _electionName;

        state = State.Created;


    }

    function addCandidates(address _candidateAddress, string memory _candidateName, string memory _symbol) public InState(State.Created) OfficialOnly{
        Candidate memory candidate;
        candidate.candidateAddress = _candidateAddress;
        candidate.candidateName = _candidateName;
        candidate.symbol = _symbol;
        CandidateList[candidatesCount] = _symbol;

        SymbolToCandidate[_symbol] = candidate;
        candidatesCount = candidatesCount + 1;

    }


    function getCandidates() public view returns (Candidate[] memory){
      Candidate[] memory trrips = new Candidate[](candidatesCount);
      for (uint i = 0; i < candidatesCount; i++) {
          Candidate storage candidate = SymbolToCandidate[CandidateList[i]];
          trrips[i] = candidate;
      }
      return trrips;

    }


    function getCandidate(string memory _symbol) public view returns(Candidate memory){
        return SymbolToCandidate[_symbol];
    }

    function addVoter(address _voterAddress, string memory _voterName) public InState(State.Created) OfficialOnly {
        Voter memory voter;
        voter.isAVoter = true;
        voter.voterAddress = _voterAddress;
        voter.voterName = _voterName;
        voter.voted = false;

        AddressToVoter[_voterAddress] = voter;
        VoterList[totalVoters] = _voterAddress;
        totalVoters = totalVoters + 1;
    
    }


    function makeVote(string memory _voteSymbol) public {
        require(AddressToVoter[msg.sender].isAVoter,"Not registered");
        if(AddressToVoter[msg.sender].voted == false){
        Vote memory vote;
        vote.voterAddress = msg.sender;
        vote.symbol = _voteSymbol;

        AddressToVote[msg.sender] = vote;

        SymbolToCandidate[_voteSymbol].numberOfVotes = SymbolToCandidate[_voteSymbol].numberOfVotes + 1;
        symbolToVotes[_voteSymbol] = symbolToVotes[_voteSymbol] + 1;





        AddressToVoter[msg.sender].voted = true;
        }
    }




    modifier InState(State _state){
        require(state == _state);
        _;
    }

    modifier OfficialOnly (){
        require( OragnizerAddress == msg.sender);
        _;
    }



}



