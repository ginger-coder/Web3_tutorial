// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

contract UserInfoContact {
    string name;
    uint256 age;

    event Instructor(string name, uint256 age);

    function setInfo(string memory _name, uint256 _age) public {
        name = _name;
        age = _age;
        emit Instructor(_name, _age);
    }

    function sayHi() public pure returns (string memory) {
        return "Hi";
    }

    function getInfo() public view returns (string memory, uint256) {
        return (name, age);
    }
}
