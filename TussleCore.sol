pragma solidity >=0.7.0 <0.8.0;

contract Tussle {

    struct TussleSet {
        string TussleLeaderName;
        string TussleTeamName;
        uint256 TussleRound;
    }

    address public owner;
    address public syncer;

    modifier onlyOwner () {
      require(msg.sender == owner, "Restricted Access");
      _;
    }

    modifier onlySyncer () {
      require(msg.sender == syncer, "Restricted Access");
      _;
    }

    constructor(address _syncerAddress) {
        owner = msg.sender;
        syncer = _syncerAddress;
    }

    function updateSyncer(address _newSyncer)
        public onlyOwner
    {
        syncer = _newSyncer;
    }

    function updateTussleData(
        uint256 _index,
        string memory _ccIsoAlpha2,
        string memory _ccIsoAlpha3,
        uint256 _exchangeRate,
        uint256 _ppp,
        uint256 _pppConversionFactor
    )
        public onlySyncer
    {

        parityData[_index].ccIsoAlpha2 = _ccIsoAlpha2;
        parityData[_index].ccIsoAlpha3 = _ccIsoAlpha3;
        parityData[_index].exchangeRate = _exchangeRate;
        parityData[_index].ppp = _ppp;
        parityData[_index].pppConversionFactor = _pppConversionFactor;

    }

    function getTussleData(uint256 _index)
        public view
        returns (
            string memory ccIsoAlpha2, string memory ccIsoAlpha3, uint256 exchangeRate, uint256 ppp, uint256 pppConversionFactor
        )
    {
        return (
            parityData[_index].ccIsoAlpha2,
            parityData[_index].ccIsoAlpha3,
            parityData[_index].exchangeRate,
            parityData[_index].ppp,
            parityData[_index].pppConversionFactor
        );
    }

    function getConversionFactor(uint256 _index)
        public view
        returns (uint256 pppConversionFactor)
    {
        return parityData[_index].pppConversionFactor;
    }

}
