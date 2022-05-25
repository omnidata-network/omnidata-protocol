// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.9;

import "./interfaces/IOmniDataGateway.sol";

contract OmniDataGateway is IOmniDataGateway {
  function triggerEvent(address contractAddress, string calldata cid) external {
    emit OmniEvent(contractAddress, cid);
  }

  function triggerEvent(address contractAddress, bytes32 uniqueId, string calldata cid) external {
    emit OmniEvent(contractAddress, uniqueId, cid);
  }

  function triggerEvent(address contractAddress, uint256 uniqueId, string calldata cid) external {
    emit OmniEvent(contractAddress, uniqueId, cid);
  }
}
