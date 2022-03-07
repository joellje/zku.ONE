const { MerkleTree } = require("merkletreejs");
const keccak256 = require("keccak256");
const { soliditySha3 } = require("web3-utils");

const merkleLeaves = [
  {
    msgSender: "0x5B38Da6a701c568545dCfcB03FcB875f56beddC4",
    receipient: "0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2",
    tokenId: 1,
    tokenURI:
      "eyJuYW1lIjogIk1lcmtsZSAjMSIiZGVzY3JpcHRpb24iOiAiTWVya2xlIE5GVCBDb2xsZWN0aW9uIn0=",
  },
  {
    msgSender: "0x5B38Da6a701c568545dCfcB03FcB875f56beddC4",
    receipient: "0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db",
    tokenId: 2,
    tokenURI:
      "eyJuYW1lIjogIk1lcmtsZSAjMiIiZGVzY3JpcHRpb24iOiAiTWVya2xlIE5GVCBDb2xsZWN0aW9uIn0=",
  },
  {
    msgSender: "0x5B38Da6a701c568545dCfcB03FcB875f56beddC4",
    receipient: "0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB",
    tokenId: 3,
    tokenURI:
      "eyJuYW1lIjogIk1lcmtsZSAjMyIiZGVzY3JpcHRpb24iOiAiTWVya2xlIE5GVCBDb2xsZWN0aW9uIn0=",
  },
  {
    msgSender: "0x5B38Da6a701c568545dCfcB03FcB875f56beddC4",
    receipient: "0x617F2E2fD72FD9D5503197092aC168c91465E7f2",
    tokenId: 4,
    tokenURI:
      "eyJuYW1lIjogIk1lcmtsZSAjNCIiZGVzY3JpcHRpb24iOiAiTWVya2xlIE5GVCBDb2xsZWN0aW9uIn0=",
  },
];

const leaves = merkleLeaves.map((leaf) => {
  const hash = soliditySha3(
    leaf.msgSender,
    leaf.receipient,
    leaf.tokenId,
    leaf.tokenURI
  );
  return hash;
  //   return keccak256(encodedPacked);
});
console.log("Leaves: ", leaves); // logs all the leaves

// Creating Merkle Tree with Leaves and keccak256 hashing algorithm:
const tree = new MerkleTree(leaves, keccak256, {
  sortLeaves: true,
});
const root = tree.getRoot().toString("hex");
// Retrieving a Bytes32 format for MerkleRoot:
const Bytes32root = tree.getHexRoot();
console.log("Bytes32Root: ", Bytes32root); // logs the Merkle Root

for (let i = 0; i < leaves.length; i++) {
  let currentLeaf = soliditySha3(
    merkleLeaves[i].msgSender,
    merkleLeaves[i].receipient,
    merkleLeaves[i].tokenId,
    merkleLeaves[i].tokenURI
  );

  const current_BYTES32_Proof = tree.getHexProof(currentLeaf);
  console.log(`Proof ${i + 1}: `, current_BYTES32_Proof); // logs all proofs for each leaf
}
