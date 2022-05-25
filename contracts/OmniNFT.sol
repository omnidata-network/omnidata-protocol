// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.9;

import "@openzeppelin/contracts/token/ERC777/IERC777.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

import "./OmniClient.sol";
import "./interfaces/IOmniNFT.sol";


contract OmniNFT is IOmniNFT, OmniClient, Context {
  using Chainlink for Chainlink.Request;

  uint256 public constant SCALAR = 10000;
  mapping(bytes32 => Request) public requests;
  
  // mapping(uint256 => Chain) nftInfo; // chainId => (contractAddress => (tokenId => INFO))
  mapping(uint256 => Asset) private assetInfo;
  bytes32 private jobId;
  uint256 private fee;

  constructor(address gateway) OmniClient(gateway, _msgSender()) {
    setChainlinkToken(0xa36085F69e2889c224210F603D836748e7dC0088);
    setChainlinkOracle(0x59363B0a8229Ba2dA5FBEf6D36f899351F606a09);
    jobId = "c515bbbf48774d0f97df67333f092d91";
    fee = (1 * LINK_DIVISIBILITY) / 10; // 0,1 * 10**18 (Varies by network and job)
  }

  function sendCollectionUpdateRequest(uint256 _chainId, address _contractAddr) external returns (bytes32) {
    Chainlink.Request memory req = buildChainlinkRequest(jobId, address(this), this.fulfillCollectionRequest.selector);
    req.add("dataSource", "CQT");
    req.add("endpoint", "fetch");
    req.addUint("chainId", _chainId);
    req.add("collection", Strings.toHexString(uint256(uint160(_contractAddr)), 20));
    
    bytes32 _requestId = sendChainlinkRequest(req, fee);
    
    Request storage request = requests[_requestId];
    request.requester = _msgSender();
    request.requestTime = block.timestamp;

    return _requestId;
  }

  // "1","0xbc4ca0eda7647a8ab7c2061c2e118a18a936f13d","123"
  function sendTokenUpdateRequest(uint256 _chainId, address _contractAddr, uint256 _tokenId) external returns (bytes32) {
    Chainlink.Request memory req = buildChainlinkRequest(jobId, address(this), this.fulfillTokenRequest.selector);
    req.add("dataSource", "CQT");
    req.add("endpoint", "nft");
    req.add("chainId", Strings.toString(_chainId));
    req.add("collection", Strings.toHexString(uint256(uint160(_contractAddr)), 20));
    req.add("tokenId", Strings.toString(_tokenId));
    
    bytes32 _requestId = sendChainlinkRequest(req, fee);
    
    Request storage request = requests[_requestId];
    request.requester = _msgSender();
    request.requestTime = block.timestamp;

    return _requestId;
  }

  function setJobId(bytes32 _jobId) external onlyOwner {
    jobId = _jobId;
  }

  function fulfillCollectionRequest(bytes32 _requestId, bytes memory data) public recordChainlinkFulfillment(_requestId) {
    requests[_requestId].responseTime = block.timestamp;
    requests[_requestId].nonce += 1;
    (uint256 ci, address coll, uint256 fp, uint256 hc, uint256 v, uint256 ic, address c) = abi.decode(data, (uint256,address,uint256,uint256,uint256,uint256,address));
    assetInfo[ci].collection[coll] = Collection(fp, hc, v, ic, c, _requestId);
  }

  function fulfillTokenRequest(bytes32 _requestId, bytes memory data) public recordChainlinkFulfillment(_requestId) {
    requests[_requestId].responseTime = block.timestamp;
    requests[_requestId].nonce += 1;
    (uint256 ci, address coll, uint256 ti, uint256 tp, address to) = abi.decode(data, (uint256,address,uint256,uint256,address));
    assetInfo[ci].nft[coll][ti] = NFT(tp, to, _requestId);
  }

  function retrieveCollectionData(uint256 _chainId, address _contract) public view returns (Collection memory collection) {
    collection = assetInfo[_chainId].collection[_contract];
  }

  function retrieveNFTData(uint256 _chainId, address _contract, uint256 _tokenId) public view returns (NFT memory nft) {
    nft = assetInfo[_chainId].nft[_contract][_tokenId];
  }
}
