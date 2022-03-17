pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;
// SPDX-License-Identifier: MIT

import "./ManufacturerManager.sol";

interface IManufacturerManager{
    function checkAuthorship(uint96 EPC)  
    external
    view
    returns(bool);

    function isValidManufacturer() external returns (bool);
}

contract ProductManager{
    enum ProductStatus {Shipped, Owned, Disposed}
    
    struct ProductInfo {
        address owner;
        address recipient;
        ProductStatus status;
        uint creationTime;
        uint8 nTransferred;
        bool isUsed;
    }

    
    uint private constant MAXTRANSFER = 5;
    mapping (uint96 => ProductInfo) products;

    modifier onlyNotExist(uint96 EPC){
        //allow only non existing epc to be registered
        require(!products[EPC].isUsed, "EPC is alredy present");
        _;
    }
    modifier onlyManufacturer(address mmAddr){
        bool isManufac = IManufacturerManager(mmAddr).isValidManufacturer();
        require(isManufac, "Not a manufacturer");
    _;
    }
    modifier onlyExist(uint96 EPC){
        require(products[EPC].isUsed, "Product EPC does not exist");
    _;
    }
    modifier onlyOwner(uint96 EPC){
    require(products[EPC].owner == msg.sender, "Not the original owner");
    _;
    }
    modifier onlyStatusIs(uint96 EPC, ProductStatus _status){
    require(products[EPC].status == _status, "Status mismatch");
    _;
    }
    modifier onlyRecipient(uint96 EPC){
    require(products[EPC].recipient==msg.sender, "Not authorised receiver");
    _;
    }

    function enrollProduct(address mmAddr, uint96 EPC) 
    public 
    onlyNotExist(EPC) 
    onlyManufacturer(mmAddr)
    {
        MaufacturerManager mm = MaufacturerManager(mmAddr);
        // if (mm.checkAuthorship(EPC)) {
            require(mm.checkAuthorship(EPC), "Invalid check authorship");
            products[EPC].owner = tx.origin;
            products[EPC].status = ProductStatus.Owned;
            products[EPC].creationTime = block.timestamp;
            products[EPC].nTransferred = 0;
            products[EPC].isUsed = true;
        // }
    }
    
    function shipProduct(address recipient,uint96 EPC) 
    public 
    onlyExist(EPC) 
    onlyOwner(EPC) 
    onlyStatusIs(EPC, ProductStatus.Owned) 
    {
        // require(recipient == products[EPC].owner);
        products[EPC].status =ProductStatus.Shipped;
        products[EPC].recipient = recipient;
    }

    function receiveProduct(uint96 EPC) 
    public
    onlyExist(EPC)
    onlyRecipient(EPC)
    onlyStatusIs(EPC, ProductStatus.Shipped) {
        products[EPC].owner = msg.sender;
        products[EPC].status = ProductStatus.Owned;
        products[EPC].nTransferred = products[EPC].nTransferred + 1;
        if (products[EPC].nTransferred <= MAXTRANSFER) {
            // msg.sender.send(transferReward);
        }
    }

    function getCurrentOwner(uint96 EPC) 
    public view
    onlyExist(EPC)
    returns (address) {
        return products[EPC].owner;
    }

    function getRecipient(uint96 EPC) 
    public view
    onlyExist(EPC)
    onlyStatusIs(EPC, ProductStatus.Shipped)
    returns (address) {
        return products[EPC].recipient;
    }

    function getProductStatus(uint96 EPC) 
    public view
    onlyExist(EPC) 
    returns (ProductStatus) {
        return products[EPC].status;
    }

}