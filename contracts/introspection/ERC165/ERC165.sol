pragma solidity >=0.5.0 <0.6.0;

import "./IERC165.sol";

/// @title ERC165
/// @dev EIP165 interface 구현
/// @author jhhong
contract ERC165 is IERC165 {
    
    mapping(bytes4 => bool) private _infcs; // INTERFACE ID별 지원여부를 저장하기 위한 매핑 변수

    /// @author jhhong
    /// @notice 컨트랙트 생성자이다.
    /// @dev bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
    constructor() internal {
        _registerInterface(0x01ffc9a7); // supportsInterface()의 INTERFACE ID 등록
    }

    /// @author jhhong
    /// @notice 컨트랙트가 INTERFACE ID를 지원하는지의 여부를 반환한다.
    /// @param infcid 지원여부를 확인할 INTERFACE ID (Function Selector)
    /// @return 지원여부 (boolean)
    function supportsInterface(bytes4 infcid) external view returns (bool) {
        return _infcs[infcid];
    }

    /// @author jhhong
    /// @notice INTERFACE ID를 등록한다.
    /// @param infcid 등록할 INTERFACE ID (Function Selector)
    function _registerInterface(bytes4 infcid) internal {
        require(infcid != 0xffffffff, "ERC165: invalid interface id");
        _infcs[infcid] = true;
    }
}