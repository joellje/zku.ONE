// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/** 
 * @title HelloWorld
 * @dev Implements Hello World smart contract: store an unsigned integer and then retrieve it.
 */
contract HelloWorld {
    uint value; // declares state variable called value of type uint

    constructor(uint _value) { // constructor that sets initial value to _value
        value = _value;
    }

    function set(uint x) public { // setter function that sets value to x
        value = x;
    }

    function get() public view returns (uint) { // getter function that returns value
        return value;
    }
}