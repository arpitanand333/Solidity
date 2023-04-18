const { MerkleTree } = require('merkletreejs')
const keccak256 = require('keccak256')
//const leavess = ["0x5B38Da6a701c568545dCfcB03FcB875f56beddC4","0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2","0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db","0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB","0x617F2E2fD72FD9D5503197092aC168c91465E7f2","0x17F6AD8Ef982297579C203069C1DbfFE4348c372","0x5c6B0f7Bf3E7ce046039Bd8FABdfD3f9F5021678","0x1aE0EA34a72D944a8C7603FfB3eC30a6669E454C"]
const leavess = [];
for (let i = 0; i < 15; i++) {
    leavess[i] = '' + i //i.toString(); 
}
const leaves = leavess.map(x => keccak256(x))
console.log("****************Leaves**********************************");
leaves.map(x => console.log(x.toString("hex")));
console.log("****************Leaves***********************************");
const tree = new MerkleTree(leaves, keccak256,{sort: true})
//console.log(tree)
const root = tree.getRoot().toString('hex')
console.log("*******Root****")
console.log(root)
const leaf = keccak256("0")
console.log("*******leaf****")
console.log(leaf.toString('hex'))
const proof = tree.getProof(leaf)
console.log("*********** Proof path **************");
proof.map(x => console.log(x.data.toString("hex")));
console.log("*************************")
console.log(tree.toString("hex"))

["0x13600b294191fc92924bb3ce4b969c1e7e2bab8f4c93c3fc6d0a51733df3c060","0xc5710bab0f533404b5c2bc4ffc7dc63e88b44a95a3d6379919968cec307eadc0","0x8aede1b3d181c52630bce0cf1aded5291199dccf2bb394c9bf69e1790fd36c0a","0x7eb7fc6dbe77e173facdd68eb2576700309fc3efc5842e8fe7e1c088030a99ce"]