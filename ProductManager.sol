pragma solidity ^0.8.0;

// pragma experimental ABIEncoderV2;
// SPDX-License-Identifier: MIT

// import "./ManufacturerManager.sol";

interface IManufacturerManager {
    function checkAuthorship(uint96 EPC) external view returns (bool);

    function isValidManufacturer() external returns (bool);
}

contract ProductManager {
    address private mmAddr;

    constructor(address _mmAddr) {
        mmAddr = _mmAddr;
    }

    event Transfer(address indexed from, address indexed to, uint96 EPC);

    enum ProductStatus {
        Shipped,
        Owned,
        Disposed
    }

    struct customerInfo {
        string name;
        string phone;
        uint96[] productsOwned;
        bool isCustomer;
    }
    mapping(address => customerInfo) CustomerOwnedItems;

    struct ProductInfo {
        address owner;
        address recipient;
        ProductStatus status;
        uint256 creationTime;
        uint8 nTransferred;
        bool isUsed;
    }

    uint256 private constant MAXTRANSFER = 5;
    mapping(uint96 => ProductInfo) products;

    modifier onlyNotExist(uint96 EPC) {
        //allow only non existing epc to be registered
        require(!products[EPC].isUsed, "EPC is alredy present");
        _;
    }
    modifier onlyManufacturer() {
        bool isManufac = IManufacturerManager(mmAddr).isValidManufacturer();
        require(isManufac, "Not a manufacturer");
        _;
    }
    modifier onlyExist(uint96 EPC) {
        require(products[EPC].isUsed, "Product EPC does not exist");
        _;
    }
    modifier onlyOwner(uint96 EPC) {
        require(products[EPC].owner == msg.sender, "Not the original owner");
        _;
    }
    modifier onlyStatusIs(uint96 EPC, ProductStatus _status) {
        require(products[EPC].status == _status, "Status mismatch");
        _;
    }
    modifier onlyRecipient(uint96 EPC) {
        require(
            products[EPC].recipient == msg.sender,
            "Not authorised receiver"
        );
        _;
    }

    // add customer
    function createCustomer(string memory _name, string memory _phone)
        public
        payable
        returns (bool)
    {
        if (CustomerOwnedItems[msg.sender].isCustomer) {
            return false;
        }
        customerInfo memory newCustomer;
        newCustomer.name = _name;
        newCustomer.phone = _phone;
        newCustomer.isCustomer = true;

        CustomerOwnedItems[msg.sender] = newCustomer;
        return true;
    }

    function getCustomerDetails(address _addr)
        public
        view
        returns (customerInfo memory)
    {
        if (CustomerOwnedItems[_addr].isCustomer) {
            return (CustomerOwnedItems[_addr]);
        } else {
            return (CustomerOwnedItems[address(0x0)]);
        }
    }

    function enrollProduct(uint96 EPC)
        public
        onlyNotExist(EPC)
        onlyManufacturer
    {
        IManufacturerManager mm = IManufacturerManager(mmAddr);
        // MaufacturerManager mm = MaufacturerManager(mmAddr);
        // if (mm.checkAuthorship(EPC)) {
        require(mm.checkAuthorship(EPC), "Invalid check authorship");
        products[EPC].owner = tx.origin;
        products[EPC].status = ProductStatus.Owned;
        products[EPC].creationTime = block.timestamp;
        products[EPC].nTransferred = 0;
        products[EPC].isUsed = true;
        emit Transfer(address(0), msg.sender, EPC);
        // }
    }

    function shipProduct(address recipient, uint96 EPC)
        public
        onlyExist(EPC)
        onlyOwner(EPC)
        onlyStatusIs(EPC, ProductStatus.Owned)
    {
        // require(recipient == products[EPC].owner);
        products[EPC].status = ProductStatus.Shipped;
        products[EPC].recipient = recipient;
    }

    function receiveProduct(uint96 EPC)
        public
        onlyExist(EPC)
        onlyRecipient(EPC)
        onlyStatusIs(EPC, ProductStatus.Shipped)
    {
        emit Transfer(products[EPC].owner, msg.sender, EPC);
        products[EPC].owner = msg.sender;
        products[EPC].status = ProductStatus.Owned;
        products[EPC].nTransferred = products[EPC].nTransferred + 1;
        CustomerOwnedItems[msg.sender].productsOwned.push(EPC);
        // CustomerOwnedItems[msg.sender].productsOwned.push(products[EPC]);
        // return true;
        // if (products[EPC].nTransferred <= MAXTRANSFER) {
        // msg.sender.send(transferReward);
        // }
    }

    function getCurrentOwner(uint96 EPC)
        public
        view
        onlyExist(EPC)
        returns (address)
    {
        return products[EPC].owner;
    }

    function getRecipient(uint96 EPC)
        public
        view
        onlyExist(EPC)
        onlyStatusIs(EPC, ProductStatus.Shipped)
        returns (address)
    {
        return products[EPC].recipient;
    }

    function getProductStatus(uint96 EPC)
        public
        view
        onlyExist(EPC)
        returns (ProductStatus)
    {
        return products[EPC].status;
    }
}
