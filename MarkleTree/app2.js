const MerkleMultiProof = artifacts.require('MerkleMultiProof')
const { MerkleTree } = require('merkletreejs')
const keccak256 = require('keccak256')

const contract = await MerkleMultiProof.new()

const leaves = ['a', 'b', 'c', 'd', 'e', 'f'].map(keccak256).sort(Buffer.compare)
const tree = new MerkleTree(leaves, keccak256, { sort: true })

const root = tree.getRoot()
const proofLeaves = ['b', 'f', 'd'].map(keccak256).sort(Buffer.compare)
const proof = tree.getMultiProof(proofLeaves)
const proofFlags = tree.getProofFlags(proofLeaves, proof)

const verified = await contract.verifyMultiProof.call(root, proofLeaves, proof, proofFlags)
console.log(verified) // true