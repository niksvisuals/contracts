pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;
// SPDX-License-Identifier: MIT


struct ManufacturerInfo {
uint40 companyPrefix;
bytes32 companyName;
uint expireTime;
bool isManufacturer;
}

contract MaufacturerManager{

    address private admin;
    
    constructor(){
        admin = msg.sender;
    }

    mapping (address => ManufacturerInfo) manufacturers;
    mapping (uint40 => address) companyPrefixToAddress;

    function enrollManufacturer(
    address m,                  //manufacturer Address
    uint40 companyPrefix, 
    bytes32 companyName,        //0x60298f78cc0b47170ba79c10aa3851d7648bd96f2f8e46a19dbc777c36fb0c00 - keccak256(solidity)
    uint validDurationInYear) 
    public onlyAdmin {
        manufacturers[m].companyPrefix =companyPrefix;
        manufacturers[m].companyName =companyName;
        manufacturers[m].expireTime = block.timestamp +validDurationInYear;
        manufacturers[m].isManufacturer = true;
        companyPrefixToAddress[companyPrefix] = m;
    }
    
    modifier onlyAdmin(){
        require(msg.sender==admin,"Unauthorised Access");_;
    }

    function isValidManufacturer() external view returns (bool){
        return manufacturers[tx.origin].isManufacturer;
    }

    function checkAuthorship(uint96 EPC)  
    public
    view
    returns(bool){
        //epc sent by the function, used to extract company prefix
        uint40 companyPrefix = uint40(EPC);

        //comany prefix of sender, retreived from blockchain
        uint40 companyEpc = manufacturers[msg.sender].companyPrefix;
        
        if(companyPrefix == companyEpc){
            return true;
        }else{
            return false;}
    }

    function getManufacturerAddress(uint96 EPC)
    external 
    view 
    returns (address) {
        uint40 cp = uint40(EPC);
        return companyPrefixToAddress[cp];
    }

}
