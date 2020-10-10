// SPDX-License-Identifier: MIT

pragma solidity ^0.6.6;


contract TussleValidator {
    
    event InitiateChange(bytes32 indexed parentHash, address[] newSet);
    event ChangeFinalized(address[] newSet);
    event MoCInitializedProxyStorage(address proxyStorage);
    
    struct ValidatorState {
        // Is this a validator.
        bool isValidator;
        // Is a validator finalized.
        bool isValidatorFinalized;
        // Index in the currentValidators.
        uint256 index;
    }
    
    address public systemAddress = 0xffffFFFfFFffffffffffffffFfFFFfffFFFfFFfE;
    
    address[] public currentValidators;
    address[] public pendingList;
    mapping(address => ValidatorState) public validatorsState;
    
    address internal _moc;
    address internal _mocPending;
    address internal _owner;

    bool internal _isMoCRemoved = false;
    bool internal _isMoCRemovedPending = false;

    bool public finalized = false;
    bool public wasProxyStorageSet = false;

    modifier onlySystemAndNotFinalized() {
        require(msg.sender == systemAddress && !finalized);
        _;
    }

    function isMasterOfCeremonyRemoved() public view returns(bool) {
        return _isMoCRemoved;
    }

    function isMasterOfCeremonyRemovedPending() public view returns(bool) {
        return _isMoCRemovedPending;
    }

    function masterOfCeremony() public view returns(address) {
        return _moc;
    }

    function masterOfCeremonyPending() public view returns(address) {
        return _mocPending;
    }

   

    /// Called when an initiated change reaches finality and is activated. 
    /// Only valid when msg.sender == SUPER_USER (EIP96, 2**160 - 2)
    ///
    /// Also called when the contract is first enabled for consensus. In this case,
    /// the "change" finalized is the activation of the initial set.
    
    function finalizeChange() public onlySystemAndNotFinalized {
        finalized = true;
        for (uint256 i = 0; i < pendingList.length; i++) {
            ValidatorState storage state = validatorsState[pendingList[i]];
            if (!state.isValidatorFinalized) {
                state.isValidatorFinalized = true;
            }
        }
        currentValidators = pendingList;
        if (_mocPending != address(0)) {
            _moc = _mocPending;
            _mocPending = address(0);
        }
        if (_isMoCRemovedPending) {
            _isMoCRemoved = true;
            _isMoCRemovedPending = false;
        }

    }

    function addValidator(address _validator, bool _shouldFireEvent)
        public
        returns(bool)
    {
        if (_addValidatorAllowed(_validator)) {
            _addValidator(_validator, _shouldFireEvent);
            return true;
        }
        return false;
    }

    function removeValidator(
        address _validator,
        bool _shouldFireEvent
    ) public  returns(bool) {
        if (_removeValidatorAllowed(_validator)) {
            _removeValidator(_validator, _shouldFireEvent);
            return true;
        }
        return false;
    }

    function swapValidatorKey(address _newKey, address _oldKey)
        public
        returns(bool)
    {
        if (!_removeValidatorAllowed(_oldKey) || !_addValidatorAllowed(_newKey)) return false;
        _removeValidator(_oldKey, false);
        _addValidator(_newKey, false);
        if (_oldKey == _moc) {
            _mocPending = _newKey;
        }
        emit InitiateChange(blockhash(block.number - 1), pendingList);
        return true;
    }

    

    function isValidator(address _someone) public view returns(bool) {
        return validatorsState[_someone].isValidator;
    }

    function isValidatorFinalized(address _someone) public view returns(bool) {
        bool _isValidator = validatorsState[_someone].isValidator;
        bool _isFinalized = validatorsState[_someone].isValidatorFinalized;
        return _isValidator && _isFinalized;
    }


    function getCurrentValidatorsLength() public view returns(uint256) {
        return currentValidators.length;
    }

    function getCurrentValidatorsLengthWithoutMoC() public view returns(uint256) {
        if (_isMoCRemoved) {
            return currentValidators.length;
        }
        if (currentValidators.length == 0) {
            return 0;
        }
        return currentValidators.length - 1; // exclude MoC
    }

    function _addValidatorAllowed(address _validator) private view returns(bool) {
        if (_validator == address(0)) return false;
        if (isValidator(_validator)) return false;
        return true;
    }

    function _addValidator(address _validator, bool _shouldFireEvent) private {
        validatorsState[_validator] = ValidatorState({
            isValidator: true,
            isValidatorFinalized: false,
            index: pendingList.length
        });
        pendingList.push(_validator);
        finalized = false;
        if (_shouldFireEvent) {
            emit InitiateChange(blockhash(block.number - 1), pendingList);
        }
    }

    function _removeValidatorAllowed(address _validator) private view returns(bool) {
        if (pendingList.length == 0) return false;
        if (!isValidator(_validator)) return false;
        return true;
    }

    function _removeValidator(address _validator, bool _shouldFireEvent) private {
        uint256 removedIndex = validatorsState[_validator].index;
        // Can not remove the last validator.
        uint256 lastIndex = pendingList.length - 1;
        address lastValidator = pendingList[lastIndex];
        // Override the removed validator with the last one.
        pendingList[removedIndex] = lastValidator;
        // Update the index of the last validator.
        validatorsState[lastValidator].index = removedIndex;
        pendingList.length;
        validatorsState[_validator].index = 0;
        validatorsState[_validator].isValidator = false;
        validatorsState[_validator].isValidatorFinalized = false;
        finalized = false;
        if (_shouldFireEvent) {
            if (_validator == _moc) {
                _isMoCRemovedPending = true;
            }
            emit InitiateChange(blockhash(block.number - 1), pendingList);
        }
    }
}
