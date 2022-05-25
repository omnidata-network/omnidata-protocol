// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.9;

interface IOmniNFT {
  struct Request {
    uint256 nonce;
    address requester;
    uint256 requestTime;
    uint256 responseTime;
  }

  struct NFT {
    uint256 tokenPrice;
    address tokenOwner;
    // uint256[] historyPrices;
    bytes32 requestId;
  }

  struct Collection {
    uint256 floorPrice;
    uint256 holderCount;
    uint256 volume;
    uint256 itemCount;
    // uint256 transactionCount;
    address creator;
    bytes32 requestId;
  }

  struct Asset {
    mapping(address => Collection) collection;
    mapping(address => mapping(uint256 => NFT)) nft;
  }

  /**
   * @notice send request to update Collection information.
   *
   * @param _chainId the chainId of the NFT on
   * @param _contractAddr the contract address of the NFT collection
   */
  function sendCollectionUpdateRequest(uint256 _chainId, address _contractAddr) external returns (bytes32);

  /**
   * @notice send request to update NFT token data.
   *
   * @param _chainId the chainId where the NFT on
   * @param _contractAddr the contract address of the NFT
   * @param _tokenId the tokenId of the NFT
   */
  function sendTokenUpdateRequest(uint256 _chainId, address _contractAddr, uint256 _tokenId) external returns (bytes32);

  /**
   * @notice fetch the collection data.
   * 
   */
  function retrieveCollectionData(uint256 _chainId, address _contract) external view returns (Collection memory collection);

  /**
   * @notice fetch the token data.
   * 
   */
  function retrieveNFTData(uint256 _chainId, address _contract, uint256 _tokenId) external view returns (NFT memory nft);

}
