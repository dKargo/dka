pragma solidity >=0.5.0 <0.6.0;

/// @title DkargoPrefix
/// @notice 디카르고 컨트랙트 여부 식별용 prefix 컨트랙트 정의
/// @author jhhong
contract DkargoPrefix {
    
    string internal _dkargoPrefix; // 디카르고-프리픽스
    
    /// @author jhhong
    /// @notice 디카르고 프리픽스를 반환한다.
    /// @return 디카르고 프리픽스 (string)
    function getDkargoPrefix() public view returns(string memory) {
        return _dkargoPrefix;
    }

    /// @author jhhong
    /// @notice 디카르고 프리픽스를 설정한다.
    /// @param prefix 설정할 프리픽스
    function _setDkargoPrefix(string memory prefix) internal {
        _dkargoPrefix = prefix;
    }
}