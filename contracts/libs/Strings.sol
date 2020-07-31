pragma solidity >=0.5.0 <0.6.0;

/// @title Strings
/// @dev 스트링 타입 변수에 대한 제어/검사를 위한 라이브러리
/// @author jhhong
library Strings {
    /// @author jhhong
    /// @notice 문자열의 길이을 반환한다.
    /// @param str 문자열
    /// @return 문자열의 길이
    function strlen(string memory str) internal pure returns (uint256) {
        bytes memory buf = bytes(str);
        return buf.length;
    }

    /// @author jhhong
    /// @notice 문자열을 bytes32 타입으로 변환한다.
    /// @param str 문자열
    /// @return 변환된 bytes32 타입 변수
    function convertStrToBytes32(string memory str) internal pure returns (bytes32 result) {
        bytes memory buf = bytes(str);
        if (buf.length == 0) {
            return 0x0;
        }
        assembly {
            result := mload(add(str, 32))
        }
    }
}