pragma solidity ^0.8.0;
// pragma experimental ABIEncoderV2;
// SPDX-License-Identifier: MIT

struct ManufacturerInfo {
    uint16 companyPrefix;
    string companyName;
    uint256 expireTime;
    bool isManufacturer;
}

contract ManufacturerManager {
    address private admin;

    constructor() {
        admin = msg.sender;
    }

    mapping(address => ManufacturerInfo) manufacturers;
    mapping(uint16 => address) companyPrefixToAddress;

    function enrollManufacturer(
        address _manufacturerAddress, //manufacturer Address
        uint16 _companyPrefix,
        string memory _companyName, 
        uint256 _validDurationInYear
    ) public onlyAdmin {
        manufacturers[_manufacturerAddress].companyPrefix = _companyPrefix;
        manufacturers[_manufacturerAddress].companyName = _companyName;
        manufacturers[_manufacturerAddress].expireTime = block.timestamp + (_validDurationInYear * 365 days);
        manufacturers[_manufacturerAddress].isManufacturer = true;
        companyPrefixToAddress[_companyPrefix] = _manufacturerAddress;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not Admin");
        _;
    }

    function isValidManufacturer() external view returns (bool) {
        // require(manufacturers[tx.origin].expireTime >= block.timestamp);
        return manufacturers[tx.origin].isManufacturer;
    }
    function getManufacturerDetails(address _addr) external view returns (ManufacturerInfo memory) {
        // require(manufacturers[tx.origin].expireTime >= block.timestamp);
        if (manufacturers[_addr].isManufacturer) {
            return (manufacturers[_addr]);
        } else {
            return (manufacturers[address(0x0)]);
        }
    }

    function checkAuthorship(uint16 _cp) public view returns (bool) {
        //epc sent by the function, used to extract company prefix
        // console.log(msg.sender);
        // uint16 companyPrefix = _cp;

        //comany prefix of sender, retreived from blockchain
        uint16 blockchainPrefix = manufacturers[tx.origin].companyPrefix;

        if (_cp == blockchainPrefix) {
            return true;
        } else {
            return false;
        }
    }

    function getManufacturerAddress(uint16 _companyPrefix)
        external
        view
        returns (address)
    {
        // uint16 cp = uint16(EPC);
        return companyPrefixToAddress[_companyPrefix];
    }
}
