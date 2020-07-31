pragma solidity >=0.5.0 <0.6.0;

/**
 * @dev Collection of functions related to the address type,
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * This test is non-exhaustive, and there may be false-negatives: during the
     * execution of a contract's constructor, its address will be reported as
     * not containing a contract.
     *
     * > It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies in extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }

    /// @dev jhhong add features
    /// add useful functions and modifier definitions
    /// date: 2020.02.24

    /// @author jhhong
    /// @notice call 방식의 간접 함수 호출을 수행한다.
    /// @param addr 함수 호출할 컨트랙트 주소
    /// @param rawdata Bytes타입의 로우데이터 (함수셀렉터 + 파라메터들)
    /// @return 처리 결과 (bytes type) => abi.decode로 디코딩해줘야 함
    function _call(address addr, bytes memory rawdata) internal returns(bytes memory) {
        (bool success, bytes memory data) = address(addr).call(rawdata);
        require(success == true, "Address: function(call) call failed");
        return data;
    }

    /// @author jhhong
    /// @notice delegatecall 방식의 간접 함수 호출을 수행한다.
    /// @param addr 함수 호출할 컨트랙트 주소
    /// @param rawdata Bytes타입의 로우데이터 (함수셀렉터 + 파라메터들)
    /// @return 처리 결과 (bytes type) => abi.decode로 디코딩해줘야 함
    function _dcall(address addr, bytes memory rawdata) internal returns(bytes memory) {
        (bool success, bytes memory data) = address(addr).delegatecall(rawdata);
        require(success == true, "Address: function(delegatecall) call failed");
        return data;
    }

    /// @author jhhong
    /// @notice staticcall 방식의 간접 함수 호출을 수행한다.
    /// @dev bool 타입 값을 반환하는 view / pure 함수 CALL 시 사용된다.
    /// @param addr 함수 호출할 컨트랙트 주소
    /// @param rawdata Bytes타입의 로우데이터 (함수셀렉터 + 파라메터들)
    /// @return 처리 결과 (bytes type) => abi.decode로 디코딩해줘야 함
    function _vcall(address addr, bytes memory rawdata) internal view returns(bytes memory) {
        (bool success, bytes memory data) = address(addr).staticcall(rawdata);
        require(success == true, "Address: function(staticcall) call failed");
        return data;
    }
}