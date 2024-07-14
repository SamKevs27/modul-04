// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.23;

contract VotingSystem {
    struct Candidate {
        uint256 id;
        string name;
        uint256 voteCount;
    }

    mapping(uint256 => Candidate) public candidates;
    uint256 public candidateCount;

    mapping(address => bool) public hasVoted;

    event NewCandidateAdded(uint256 indexed candidateId, string name);
    event VoteCast(address indexed voter, uint256 indexed candidateId);
    event WinnerDeclared(string winnerName);

    constructor() {
        candidateCount = 0;
    }

    function addCandidate(string memory _name) public {
        candidateCount++;
        candidates[candidateCount] = Candidate(candidateCount, _name, 0);
        emit NewCandidateAdded(candidateCount, _name);
    }

    function vote(uint256 _candidateId) public {
        require(!hasVoted[msg.sender], "You have already voted.");
        require(
            _candidateId > 0 && _candidateId <= candidateCount,
            "Invalid candidate ID."
        );

        candidates[_candidateId].voteCount++;
        hasVoted[msg.sender] = true;
        emit VoteCast(msg.sender, _candidateId);
    }

    function getTotalVotes(uint256 _candidateId) public view returns (uint256) {
        require(
            _candidateId > 0 && _candidateId <= candidateCount,
            "Invalid candidate ID."
        );
        return candidates[_candidateId].voteCount;
    }

    function getWinner() public view returns (string memory) {
        uint256 maxVotes = 0;
        string memory winnerName;

        for (uint256 i = 1; i <= candidateCount; i++) {
            if (candidates[i].voteCount > maxVotes) {
                maxVotes = candidates[i].voteCount;
                winnerName = candidates[i].name;
            }
        }

        return winnerName;
    }
}
