// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract NFT is ERC721, Ownable {
    using Strings for uint256;

    // Set a counter for TokenID enumeration to optimise gas fees for minting:
    using Counters for Counters.Counter;
    Counters.Counter private totalMinted;

    uint256 public cost = 0.05 ether;
    uint256 public maxSupply = 10000;
    uint256 public maxMintAmount = 20;

    // Variable to save merkle root:
    bytes32 public merkleRoot;

    constructor(
        string memory _name,
        string memory _symbol,
    ) ERC721(_name, _symbol) {
    }

    // public mint function
    function mint(
        bytes32[] calldata _merkleProof,
        uint256 _tokenId,
        address _recipient
    ) public payable {
        require(!paused);
        require(totalMinted.current() + 1 <= maxSupply);
        require(_recipient != address(0));

        // Check if the price was paid corrected for the minted NFT:
        require(msg.value == cost, "Invalid amount.");

        string memory currentTokenURI = tokenURI(_tokenId);

        // Get the Hash for this particular mint transaction:
        bytes32 merkleLeaf = keccak256(
            abi.encodePacked(msg.sender, _recipient, _tokenId, currentTokenURI)
        );

        // Verify merkleHash with Merkle Tree:
        require(MerkleProof.verify(_merkleProof, merkleRoot, merkleLeaf));

        _safeMint(_recipient, _tokenId);

        // Update the respective state counters:
        totalMinted.increment();
    }

    // function to get tokenURI
    function tokenURI(uint256 tokenId)
        public
        pure
        override
        returns (string memory)
    {
        bytes memory dataURI = abi.encodePacked(
            '{',
                '"name": "Merkle #', tokenId.toString(), '"',
                '"description": "Merkle Tree NFT Collect
                ion"'
            '}'
        );

        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(dataURI)
            )
        );
    }
    
    // function to get currentSupply
    function currentSupply() public view returns (uint256) {
        return totalMinted.current();
    }

    // function to set new MerkleRoot
    function setMerkleRoot(bytes32 _newMerkleRoot) public onlyOwner {
        merkleRoot = _newMerkleRoot;
    }
}