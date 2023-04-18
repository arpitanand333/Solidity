const { MerkleTree } = require('merkletreejs')
const keccak256 = require('keccak256')
//const leavess = ["0x5B38Da6a701c568545dCfcB03FcB875f56beddC4","0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2","0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db","0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB","0x617F2E2fD72FD9D5503197092aC168c91465E7f2","0x17F6AD8Ef982297579C203069C1DbfFE4348c372","0x5c6B0f7Bf3E7ce046039Bd8FABdfD3f9F5021678","0x1aE0EA34a72D944a8C7603FfB3eC30a6669E454C"]
const leavess = [];
for (let i = 0; i < 15; i++) {
    leavess[i] = '' + i //i.toString(); 
}
console.log(leavess.length)
let leavesinfo = [];
for(let i=0;i<leavess.length; i++){
    // console.log("ARPIT"+leavess[i])
    leavesinfo.push(leavess[i])
}
const arp = leavess.length;
console.log(arp);

const leaves = leavesinfo.map(x => keccak256(x))
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
let proof2 = [];
for(i = 0; i<leavesinfo.length; i++){
    let test ;
    test = leaves[i].toString('hex');
    
    let proof1= [];
    proof1 = tree.getProof(test)
    proof2[i] = proof1.map(x => "0x" + x.data.toString("hex"));

}
console.log(proof2)
console.log(proof2.length)

// console.log(tree.verify(proof, leaf, root)) // true

// console.log(root)
// console.log("*********************")
// // console.log(leaf.toString('hex'))
// console.log("*************************")
// console.log(proof);
console.log("*********** Proof path **************");
proof.map(x => console.log(x.data.toString("hex")));
console.log("*************************")
console.log(tree.toString("hex"))



