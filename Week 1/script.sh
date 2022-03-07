circom circuit.circom --r1cs --wasm --sym --c
cd circuit_js

# Generate the witness
node generate_witness.js circuit.wasm ../input.json witness.wtns

# Use snarkjs to generate and validate a proof. groth16 zk-snark protocol requires a trusted setup for each circuit which consists of
# 1. Powers of Tau

# Create new powersoftau ceremony
snarkjs powersoftau new bn128 15 pot12_0000.ptau -v

# Contribute to the created economy. Use -e to provide some input text.
snarkjs powersoftau contribute pot12_0000.ptau pot12_0001.ptau --name="First contribution" -v -e="randomtext"

# 2. Phase 2
# Prepare for start of phase 2
snarkjs powersoftau prepare phase2 pot12_0001.ptau pot12_final.ptau -v

# Generate zkey file that contains the proving and verification keys together with phase 2 contributions
snarkjs groth16 setup ../circuit.r1cs pot12_final.ptau circuit_0000.zkey
snarkjs zkey contribute circuit_0000.zkey circuit_0001.zkey --name="1st Contributor Name" -v -e="randomtext"

# Export verification key to json file
snarkjs zkey export verificationkey circuit_0001.zkey verification_key.json

# Generate ZK proof using zkey and witness
# This outputs a proof file and a public file containing the public inputs and outputs
snarkjs groth16 prove circuit_0001.zkey witness.wtns proof.json public.json

# Use the verification key, proof and public file to verify if proof is valid
snarkjs groth16 verify verification_key.json public.json proof.json

# snarkjs zkey export solidityverifier multiplier2_0001.zkey verifier.sol

# Generate and print parameters of call
# snarkjs generatecall | tee parameters.txt

