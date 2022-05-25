// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "@openzeppelin/contracts/utils/Strings.sol";

import "../OmniClient.sol";

contract OracleRequest is OmniClient {
  using Chainlink for Chainlink.Request;

  bytes32 private jobId;
  uint256 private fee;

  mapping(uint256 => string) public hashes;
  uint256 public idx;

  constructor(address gateway) OmniClient(gateway, msg.sender) {
      setChainlinkToken(0xa36085F69e2889c224210F603D836748e7dC0088);
      setChainlinkOracle(0x59363B0a8229Ba2dA5FBEf6D36f899351F606a09);
      jobId = "ac6a1b84264645f2bd372a4752dfc0ce";
      fee = (1 * LINK_DIVISIBILITY) / 10; // 0,1 * 10**18 (Varies by network and job)
  }

  event RequestFulfilled(bytes32 indexed requestId, bytes indexed data);

  function stateUpdateAndSaveToIPFS(
      string memory _val1,
      string memory _val2,
      string memory _val3
  ) public payable returns (bytes32) {
    /// @notice you can add other logics here

    // Build Chainlink Request
    Chainlink.Request memory req = buildChainlinkRequest(jobId, address(this), this.fulfill.selector);
    req.add("msgSender", Strings.toHexString(uint256(uint160(msg.sender)), 20));
    req.add("key1", _val1);
    req.add("key2", _val2);
    req.add("key3", _val3);
    
    req.add("targetChain", "96");
    req.add("contractAddress", "0x2f864f861b5339c74267c5c28f210252528e0b1a");
    req.addBytes("funcSig", abi.encodeWithSignature("releaseFund", 1 * 10 ** 18));
    
    return sendChainlinkRequest(req, fee);
  }

  /**
   * Receive the response in the form of string
   */
  function fulfill(bytes32 _requestId, string memory _cid) public recordChainlinkFulfillment(_requestId) {
    hashes[idx++] = _cid;
    sendOmniEvent(address(this), _requestId, _cid);
  }

  function setJobId(bytes32 _jobId) external {
    jobId = _jobId;
  }
}
