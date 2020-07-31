pragma solidity >=0.5.0 <0.6.0;

/// @title Onwership
/// @dev 오너 확인 및 소유권 이전 처리
/// @author jhhong
contract Ownership {
    address private _owner;

    event OwnershipTransferred(address indexed old, address indexed expected);

    /// @author jhhong
    /// @notice 소유자만 접근할 수 있음을 명시한다.
    modifier onlyOwner() {
        require(isOwner() == true, "Ownership: only the owner can call");
        _;
    }

    /// @author jhhong
    /// @notice 컨트랙트 생성자이다.
    constructor() internal {
        emit OwnershipTransferred(_owner, msg.sender);
        _owner = msg.sender;
    }

    /// @author jhhong
    /// @notice 소유권을 넘겨준다.
    /// @param expected 새로운 오너 계정
    function transferOwnership(address expected) public onlyOwner {
        require(expected != address(0), "Ownership: new owner is the zero address");
        emit OwnershipTransferred(_owner, expected);
        _owner = expected;
    }

    /// @author jhhong
    /// @notice 오너 주소를 반환한다.
    /// @return 오너 주소
    function owner() public view returns (address) {
        return _owner;
    }

    /// @author jhhong
    /// @notice 소유자인지 확인한다.
    /// @return 확인 결과 (boolean)
    function isOwner() public view returns (bool) {
        return msg.sender == _owner;
    }
}