pragma solidity >=0.5.0 <0.6.0;

import "./DkargoPrefix.sol";
import "./authority/Ownership.sol";
import "./chain/AddressChain.sol";
import "./introspection/ERC165/ERC165.sol";
import "./token/ERC20/ERC20Safe.sol";

/// @title DkargoToken
/// @notice 디카르고 토큰 컨트랙트 정의 (메인넷 deploy용)
/// @dev burn 기능 추가 (public)
/// @author jhhong
contract DkargoToken is Ownership, ERC20Safe, AddressChain, ERC165, DkargoPrefix {
    
    string private _name; // 토큰 이름
    string private _symbol; // 토큰 심볼
    
    /// @author jhhong
    /// @notice 컨트랙트 생성자이다.
    /// @dev 초기 발행량이 있을 경우, msg.sender를 홀더 리스트에 추가한다.
    /// @param name 토큰 이름
    /// @param symbol 토큰 심볼
    /// @param supply 초기 발행량
    constructor(string memory name, string memory symbol, uint256 supply) ERC20(supply) public {
        _setDkargoPrefix("token"); // 프리픽스 설정 (token)
        _registerInterface(0x946edbed); // INTERFACE ID 등록 (getDkargoPrefix)
        _name = name;
        _symbol = symbol;
        _linkChain(msg.sender);
    }

    /// @author jhhong
    /// @notice 본인의 보유금액 중 지정된 금액만큼 소각한다.
    /// @param amount 소각시킬 통화량
    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }

    /// @author jhhong
    /// @notice 토큰을 전송한다. (전송주체: msg.sender)
    /// @dev 전송 후 변경된 토큰 홀더 상태를 체인에 기록한다.
    /// @param to 토큰을 받을 주소
    /// @param value 전송 금액 (토큰량)
    function transfer(address to, uint256 value) public returns (bool) {
        bool ret = super.transfer(to, value);
        if(isLinked(msg.sender) && balanceOf(msg.sender) == 0) {
            _unlinkChain(msg.sender);
        }
        if(!isLinked(to) && balanceOf(to) > 0) {
            _linkChain(to);
        }
        return ret;
    }

    /// @author jhhong
    /// @notice 토큰을 전송한다. (전송주체: from)
    /// @dev 전송 후 변경된 토큰 홀더 상태를 체인에 기록한다.
    /// @param from 토큰을 보낼 계정
    /// @param to 토큰을 받을 계정
    /// @param value 전송 금액 (토큰량)
    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        bool ret = super.transferFrom(from, to, value);
        if(isLinked(from) && balanceOf(from) == 0) {
            _unlinkChain(from);
        }
        if(!isLinked(to) && balanceOf(to) > 0) {
            _linkChain(to);
        }
        return ret;
    }

    /// @author jhhong
    /// @notice 토큰의 이름을 반환한다.
    /// @return 토큰 이름
    function name() public view returns(string memory) {
        return _name;
    }
    
    /// @author jhhong
    /// @notice 토큰의 심볼을 반환한다.
    /// @return 토큰 심볼
    function symbol() public view returns(string memory) {
        return _symbol;
    }

    /// @author jhhong
    /// @notice 토큰 데시멀을 반환한다.
    /// @dev 데시멀 값은 18 (wei) 로 고정이다.
    /// @return 토큰 데시멀
    function decimals() public pure returns(uint256) {
        return 18;
    }
}