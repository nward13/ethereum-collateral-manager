pragma solidity ^0.5.0;

// Ownable and Auth are both used to differentiate between external owners
// and smart contracts that are authorized to change data, transfer funds, etc.
// Ownable / owner refers to externally owned accounts. The only role of the
// owner is to update the auth addresses so that the smart contracts can all talk
// to one another.
// Auth refers to other smart contracts in the system

// OpenZeppelin Ownable Contract, with small change of event OwnershipTransferred
// to TransferOwnership and added revert strings
/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
    address private _owner;

    event TransferOwnership(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
     * account.
     */
    constructor () internal {
        _owner = msg.sender;
        emit TransferOwnership(address(0), _owner);
    }

    /**
     * @return the address of the owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(isOwner(), "ecm-ownable-onlyOwner");
        _;
    }

    /**
     * @return true if `msg.sender` is the owner of the contract.
     */
    function isOwner() public view returns (bool) {
        return msg.sender == _owner;
    }

    /**
     * @dev Allows the current owner to relinquish control of the contract.
     * @notice Renouncing to ownership will leave the contract without an owner.
     * It will not be possible to call the functions with the `onlyOwner`
     * modifier anymore.
     */
    function renounceOwnership() public onlyOwner {
        emit TransferOwnership(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "ecm-ownable-invalid-transfer-address");
        emit TransferOwnership(_owner, newOwner);
        _owner = newOwner;
    }
}



contract AuthAndOwnable is Ownable {
    event AddAuth(
        address indexed added,
        address indexed adder
    );
    event RemoveAuth(
        address indexed removed,
        address indexed remover
    );

    mapping (address => uint) public auths;
    modifier auth { require(auths[msg.sender] == 1, "ecm-auth"); _; }
    function addAuth(address guy) public onlyOwner {
        auths[guy] = 1; 
        emit AddAuth(guy, msg.sender);
    }
    function removeAuth(address guy) public onlyOwner { 
        auths[guy] = 0; 
        emit RemoveAuth(guy, msg.sender);
    }
    
}