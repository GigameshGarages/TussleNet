pragma solidity ^0.4.24;

import "chainlink/contracts/ChainlinkClient.sol";

contract TussleClient is ChainlinkClient {
  
  uint256 TussleTimer;

  constructor(uint256 _TussleTimer) public {
    setPublicChainlinkToken();
    TussleTimer = _TussleTimer;
  }
  
