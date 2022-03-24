
    
    
    const Web3 = require('web3');
    const abi2=require('./abb').abi2;
    const HDWalletProvider = require('@truffle/hdwallet-provider');
    
    const address1='0xccdb17b8eF68ffFdbCA4bf4AB6B765e41d61733A';
    // const address2='0x8DADF9aCaBEe5595a55eaF41c074d8e60A1bC3f8';
    const address3='0xD3B462CbF6244ed21CD3cF334Bf8CB44A28795A9';
    const privateKey1="c244b6e8ae351e71fa353515c55a4e0be82fb5bf7186c18419f89421805f74b7";
    var _beneficiary='0xccdb17b8eF68ffFdbCA4bf4AB6B765e41d61733A';
    var _assetContract='0xf075a6f1e11BF42b961b4976618E78a7872815e4';
    var _biddingTime=60;
    var _tokenId=106;
    
    const init = async() => {
        const provider = new  HDWalletProvider(
            privateKey1,
            'wss://ropsten.infura.io/ws/v3/1693cef23bd542968df2435f25726d39'
            );
            const web3 = new Web3(provider);
            const accounts= await web3.eth.getAccounts();
            // contractInstance = new web3.eth.Contract(bytecode);
            // var string = JSON.stringify(bytecode);
            // let deploy_contract=new web3.eth.Contract(JSON.parse(string));
            let contract = new web3.eth.Contract(abi2, address3);
            contract.getPastEvents('allEvents', function(error, events){ console.log(events); })
            .then(function(events){
                console.log(events) // same results as the optional callback above
            });
            
            
        // console.log(bidAuctionReceipt)
        // return bidAuctionReceipt;	
        return 1;
        };
    
        init();
        
        
    
    
    
    
    //--------------------------------------part 2

    const init = async() => {
        const provider = new  HDWalletProvider(
            privateKey1,
            'wss://ropsten.infura.io/ws/v3/1693cef23bd542968df2435f25726d39'
            );
            const web3 = new Web3(provider);
            const accounts= await web3.eth.getAccounts();
            // contractInstance = new web3.eth.Contract(bytecode);
            // var string = JSON.stringify(bytecode);
            // let deploy_contract=new web3.eth.Contract(JSON.parse(string));
            let contract = new web3.eth.Contract(abi2, address3);
            // var bidAuctionReceipt = contract.methods.createCustomer("abhishek", "nike","99").send({from: address1});
            var bidAuctionReceipt = contract.methods.addRetailerToCode("abhishek", "nike").send({from: address1}, (err, result) => { console.log(result) });
            console.log(bidAuctionReceipt);
            
        console.log(bidAuctionReceipt)
        return bidAuctionReceipt;	
        };
    
        init();
        