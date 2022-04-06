pragma solidity ^0.8.0;
//https://github.com/ethers-io/ethers.js/issues/368
// pragma experimental ABIEncoderV2;
// SPDX-License-Identifier: MIT
// import "./ManufacturerManager.sol";

interface IManufacturerManager {
    function checkAuthorship(uint16 _companyPrefix) external view returns (bool);

    function isValidManufacturer() external returns (bool);
}

contract ProductManager {
    address private mmAddr; //manufacturer manager contract address

    constructor(address _mmAddr) {
        mmAddr = _mmAddr;
    }

    event Transfer(address indexed from, address indexed to, uint32 indexed EPC);

    enum ProductStatus {
        Owned,
        Shipped,
        Disposed
    }

    struct customerInfo {
        string name;
        string phone;
        uint32[] productsOwned;
        bool isCustomer;
    }
    mapping(address => customerInfo) CustomerOwnedItems;

    struct ProductInfo {
        address owner;
        address recipient;
        ProductStatus status;
        uint256 creationTime;
        uint8 nTransferred;
        bool isEpcUsed;
    }

    // uint256 private constant MAXTRANSFER = 5;
    mapping(uint32 => ProductInfo) products;

    modifier onlyNotExist(uint32 EPC) {
        //allow only non existing epc to be registered
        require(!products[EPC].isEpcUsed, "EPC is alredy present");
        _;
    }
    modifier onlyManufacturer() {
        bool isManufacturer = IManufacturerManager(mmAddr).isValidManufacturer();
        require(isManufacturer, "Not a manufacturer");
        _;
    }
    modifier onlyExist(uint32 EPC) {
        require(products[EPC].isEpcUsed, "Product EPC does not exist");
        _;
    }
    modifier onlyOwner(uint32 EPC) {
        require(products[EPC].owner == msg.sender, "Not the original owner");
        _;
    }
    modifier onlyStatusIs(uint32 EPC, ProductStatus _status) {
        require(products[EPC].status == _status, "Status mismatch");
        _;
    }

    modifier onlyRecipient(uint32 EPC) {
        require(
            products[EPC].recipient == msg.sender,
            "Not authorised receiver"
        );
        _;
    }

    // add customer
    function createCustomer(string memory _name, string memory _phone)
        public
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

    function enrollProduct(uint32 EPC, uint16 _cp)
        public
        onlyNotExist(EPC)
        onlyManufacturer
    {
        IManufacturerManager mm = IManufacturerManager(mmAddr);
        // ManufacturerManager mm = ManufacturerManager(mmAddr);
        // if (mm.checkAuthorship(EPC)) {
        require(mm.checkAuthorship(_cp), "Company Prefix not owned by you.");
        products[EPC].owner = tx.origin;
        products[EPC].status = ProductStatus.Owned;
        products[EPC].creationTime = block.timestamp;
        products[EPC].nTransferred = 0;
        products[EPC].isEpcUsed = true;
        emit Transfer(address(0), msg.sender, EPC);
        // }
    }

    function shipProduct(address recipient, uint32 EPC)
        public
        onlyExist(EPC)
        onlyOwner(EPC)
        onlyStatusIs(EPC, ProductStatus.Owned)
    {
        // require(recipient == products[EPC].owner);
        products[EPC].status = ProductStatus.Shipped;
        products[EPC].recipient = recipient;
    }
    

    function receiveProduct(uint32 EPC)
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

    function getCurrentOwner(uint32 EPC)
        public
        view
        onlyExist(EPC)
        returns (address)
    {
        return products[EPC].owner;
    }

    function getRecipient(uint32 EPC)
        public
        view
        onlyExist(EPC)
        onlyStatusIs(EPC, ProductStatus.Shipped)
        returns (address)
    {
        return products[EPC].recipient;
    }

    function getProductStatus(uint32 EPC)
        public
        view
        onlyExist(EPC)
        returns (ProductStatus)
    {
        return products[EPC].status;
    }
}
