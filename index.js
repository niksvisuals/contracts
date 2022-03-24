


// const Web3 = require('web3');
// const abi2=require('./abb').abi2;
// const HDWalletProvider = require('@truffle/hdwallet-provider');

// const address1='0xccdb17b8eF68ffFdbCA4bf4AB6B765e41d61733A';
// // const address2='0x8DADF9aCaBEe5595a55eaF41c074d8e60A1bC3f8';
// const address3='0x1d7f71e9dd4283B5b4431e7a51498f4C14b18715'; //contract address
// const privateKey1="c244b6e8ae351e71fa353515c55a4e0be82fb5bf7186c18419f89421805f74b7";
// // var _beneficiary='0xccdb17b8eF68ffFdbCA4bf4AB6B765e41d61733A';
// // var _assetContract='0xf075a6f1e11BF42b961b4976618E78a7872815e4';
// // var _biddingTime=60;
// // var _tokenId=106;

// const init = async() => {
//     const provider = new  HDWalletProvider(
//         privateKey1,
//         'https://mumbai.polygonscan.com/address/0x1d7f71e9dd4283B5b4431e7a51498f4C14b18715#events`'
//         );
//         const web3 = new Web3(provider);
//         // const accounts= await web3.eth.getAccounts();
//         // contractInstance = new web3.eth.Contract(bytecode);
//         // var string = JSON.stringify(bytecode);
//         // let deploy_contract=new web3.eth.Contract(JSON.parse(string));
//         let contract = new web3.eth.Contract(abi2, address3);
//         // var bidAuctionReceipt = contract.methods.createCustomer("abhishek", "nike","99").send({from: address1});
//         await contract.getPastEvents('Transfer',
//         {
//             // Using an array means OR: e.g. 20 or 23
//             fromBlock:  25635493,
//             toBlock: 25635655
//         }, function(error, events){ console.log(events); });

//         return 1;
//     };

//     init();

const Web3 = require("web3");
// const { Contract } = require("web3-eth-contract");
const web3 = new Web3('https://speedy-nodes-nyc.moralis.io/895a8af903ae14b116cdc7d3/polygon/mumbai/archive')

const abi =         [{ "anonymous": false, "inputs": [{ "indexed": true, "internalType": "address", "name": "from", "type": "address" }, { "indexed": true, "internalType": "address", "name": "to", "type": "address" }, { "indexed": false, "internalType": "uint96", "name": "EPC", "type": "uint96" }], "name": "Transfer", "type": "event" }, { "inputs": [{ "internalType": "string", "name": "_name", "type": "string" }, { "internalType": "string", "name": "_phone", "type": "string" }], "name": "createCustomer", "outputs": [{ "internalType": "bool", "name": "", "type": "bool" }], "stateMutability": "payable", "type": "function" }, { "inputs": [{ "internalType": "address", "name": "mmAddr", "type": "address" }, { "internalType": "uint96", "name": "EPC", "type": "uint96" }], "name": "enrollProduct", "outputs": [], "stateMutability": "nonpayable", "type": "function" }, { "inputs": [{ "internalType": "uint96", "name": "EPC", "type": "uint96" }], "name": "getCurrentOwner", "outputs": [{ "internalType": "address", "name": "", "type": "address" }], "stateMutability": "view", "type": "function" }, { "inputs": [{ "internalType": "address", "name": "_addr", "type": "address" }], "name": "getCustomerDetails", "outputs": [{ "components": [{ "internalType": "string", "name": "name", "type": "string" }, { "internalType": "string", "name": "phone", "type": "string" }, { "internalType": "uint96[]", "name": "productsOwned", "type": "uint96[]" }, { "internalType": "bool", "name": "isCustomer", "type": "bool" }], "internalType": "struct ProductManager.customerInfo", "name": "", "type": "tuple" }], "stateMutability": "view", "type": "function" }, { "inputs": [{ "internalType": "uint96", "name": "EPC", "type": "uint96" }], "name": "getProductStatus", "outputs": [{ "internalType": "enum ProductManager.ProductStatus", "name": "", "type": "uint8" }], "stateMutability": "view", "type": "function" }, { "inputs": [{ "internalType": "uint96", "name": "EPC", "type": "uint96" }], "name": "getRecipient", "outputs": [{ "internalType": "address", "name": "", "type": "address" }], "stateMutability": "view", "type": "function" }, { "inputs": [{ "internalType": "uint96", "name": "EPC", "type": "uint96" }], "name": "receiveProduct", "outputs": [], "stateMutability": "nonpayable", "type": "function" }, { "inputs": [{ "internalType": "address", "name": "recipient", "type": "address" }, { "internalType": "uint96", "name": "EPC", "type": "uint96" }], "name": "shipProduct", "outputs": [], "stateMutability": "nonpayable", "type": "function" }];
const address = "0x1d7f71e9dd4283B5b4431e7a51498f4C14b18715"

const myContract = new web3.eth.Contract(abi, address)

myContract.getPastEvents("Transfer", { fromBlock: 25635490, toBlock: 25635656 }).then(function (event) {
    console.log(event);
})
