pragma solidity ^0.6.6;	
	
	contract TussleStream {
	
	struct TussleStream {
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
	
	constructor(address _syncerAddress) public {
	owner = msg.sender;
	syncer = _syncerAddress;
	}
	
	function updateSyncer(address _newSyncer)
	public onlyOwner
	{
	syncer = _newSyncer;
	}
	
	function updateTussleData(
	uint256 constant _index, 
	string memory _ccIsoAlpha2,
	string memory _ccIsoAlpha3,
	uint256 _exchangeRate,
	uint256 _ppp
	)
	public onlySyncer
	{
	
	TussleStream[_index].ccIsoAlpha2 = _ccIsoAlpha2;
	TussleStream[_index].ccIsoAlpha3 = _ccIsoAlpha3;
	TussleStream[_index].exchangeRate = _exchangeRate;
	TussleStream[_index].ppp = _ppp;
	
	}
	
	function getTussleData(uint256 _index)
	public view
	returns (
	string memory ccIsoAlpha2, string memory ccIsoAlpha3, uint256 exchangeRate, uint256 ppp
	)
	{
	return (
	TussleStream[_index].ccIsoAlpha2,
	TussleStream[_index].ccIsoAlpha3,
	TussleStream[_index].exchangeRate,
	TussleStream[_index].ppp,
	);
	}
	
	}
