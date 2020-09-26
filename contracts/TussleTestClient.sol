pragma solidity ^0.4.24;

import "chainlink/contracts/ChainlinkClient.sol";

contract TussleTestClient is ChainlinkClient {

  uint256 oraclePayment;

  constructor(uint256 _oraclePayment) public {
    setPublicChainlinkToken();
    oraclePayment = _oraclePayment;
  }
  // Additional functions here:
  
}
