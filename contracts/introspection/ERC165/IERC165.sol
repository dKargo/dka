pragma solidity >=0.5.0 <0.6.0;

/// @title IERC165
/// @dev EIP165 interface 선언
/// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
/// @author jhhong
interface IERC165 {
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}