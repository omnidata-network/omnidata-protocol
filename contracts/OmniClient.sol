// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.9;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import "@chainlink/contracts/src/v0.8/ConfirmedOwner.sol";

import "./interfaces/IOmniDataGateway.sol";

contract OmniClient is ChainlinkClient, ConfirmedOwner {
  address public omniGateway;

  constructor(address _gateway, address _msgSender) ConfirmedOwner(_msgSender) {
    omniGateway = _gateway;
  }

  function sendOmniEvent(address contractAddress, string memory cid) internal {
    IOmniDataGateway(omniGateway).triggerEvent(contractAddress, cid);
  }

  function sendOmniEvent(address contractAddress, bytes32 uniqueId, string memory cid) internal {
    IOmniDataGateway(omniGateway).triggerEvent(contractAddress, uniqueId, cid);
  }

  function sendOmniEvent(address contractAddress, uint256 uniqueId, string memory cid) internal {
    IOmniDataGateway(omniGateway).triggerEvent(contractAddress, uniqueId, cid);
  }

  /**
   * Allow withdraw of Link tokens from the contract
   */
  function withdrawLink() public onlyOwner {
    LinkTokenInterface link = LinkTokenInterface(chainlinkTokenAddress());
    require(link.balanceOf(address(this)) > 0, "Insufficient LINK left!");
    require(link.transfer(msg.sender, link.balanceOf(address(this))), "Unable to transfer");
  }
}
