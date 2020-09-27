pragma solidity ^0.6.6;

import "chainlink/contracts/ChainlinkClient.sol";

contract TussleTestClient is ChainlinkClient {

  uint256 oraclePayment;

  constructor(uint256 _oraclePayment) public {
    setPublicChainlinkToken();
    oraclePayment = _oraclePayment;
  }
  // Additional functions here:
  
}
