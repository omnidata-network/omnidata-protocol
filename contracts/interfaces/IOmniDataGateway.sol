// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.9;

interface IOmniDataGateway {
  event OmniEvent(address indexed contractAddress, string indexed cid);
  event OmniEvent(address indexed contractAddress, bytes32 indexed uniqueId, string indexed cid);
  event OmniEvent(address indexed contractAddress, uint256 indexed uniqueId, string indexed cid);

  function triggerEvent(address contractAddress, string calldata cid) external;
  function triggerEvent(address contractAddress, bytes32 uniqueId, string calldata cid) external;
  function triggerEvent(address contractAddress, uint256 uniqueId, string calldata cid) external;
}
