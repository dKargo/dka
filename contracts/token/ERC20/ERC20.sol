pragma solidity >=0.5.0 <0.6.0;

import "./IERC20.sol";
import "../../libs/refs/SafeMath.sol";

/// @title ERC20
/// @notice EIP20 interface 정의 및 mint/burn (internal) 함수 구현
/// @author jhhong
contract ERC20 is IERC20 {
    using SafeMath for uint256;
    
    uint256 private _supply; // 총 통화량
    mapping(address => uint256) private _balances; // 계정별 통화량 저장소
    mapping(address => mapping(address => uint256)) private _allowances; // 각 계정에 대해 "계정별 위임량"을 저장
    
    /// @author jhhong
    /// @notice 컨트랙트 생성자이다.
    /// @param supply 초기 발행량
    constructor(uint256 supply) internal {
        uint256 pebs = supply;
        _mint(msg.sender, pebs);
    }
    
    /// @author jhhong
    /// @notice 계정(spender)에게 통화량(value)을 위임한다.
    /// @param spender 위임받을 계정
    /// @param amount 위임할 통화량
    /// @return 정상처리 시 true
    function approve(address spender, uint256 amount) public returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }
    
    /// @author jhhong
    /// @notice 계정(recipient)에게 통화량(amount)을 전송한다.
    /// @param recipient 전송받을 계정
    /// @param amount 금액
    /// @return 정상처리 시 true
    function transfer(address recipient, uint256 amount) public returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }
    
    /// @author jhhong
    /// @notice 계정(sender)이 계정(recipient)에게 통화량(amount)을 전송한다.
    /// @param sender 전송할 계정
    /// @param recipient 전송받을 계정
    /// @param amount 금액
    /// @return 정상처리 시 true
    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    /// @author jhhong
    /// @notice 발행된 총 통화량을 반환한다.
    /// @return 총 통화량
    function totalSupply() public view returns (uint256) {
        return _supply;
    }
    
    /// @author jhhong
    /// @notice 계정(account)이 보유한 통화량을 반환한다.
    /// @param account 계정
    /// @return 계정(account)이 보유한 통화량
    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }
    
    /// @author jhhong
    /// @notice 계정(approver)이 계정(spender)에게 위임한 통화량을 반환한다.
    /// @param approver 위임할 계정
    /// @param spender 위임받을 계정
    /// @return 계정(approver)이 계정(spender)에게 위임한 통화량
    function allowance(address approver, address spender) public view returns (uint256) {
        return _allowances[approver][spender];
    }
    
    /// @author jhhong
    /// @notice 계정(approver)이 계정(spender)에게 통화량(value)을 위임한다.
    /// @param approver 위임할 계정
    /// @param spender 위임받을 계정
    /// @param value 위임할 통화량
    function _approve(address approver, address spender, uint256 value) internal {
        require(approver != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        _allowances[approver][spender] = value;
        emit Approval(approver, spender, value);
    }
    
    /// @author jhhong
    /// @notice 계정(sender)이 계정(recipient)에게 통화량(amount)을 전송한다.
    /// @param sender 위임할 계정
    /// @param recipient 위임받을 계정
    /// @param amount 금액
    function _transfer(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    /// @author jhhong
    /// @notice 통화량(amount)만큼 주조하여 계정(account)의 통화량에 더해준다.
    /// @dev ERC20Mint에 정의하면 private 속성인 supply와 balances에 access할 수 없어서 ERC20에 internal로 정의함.
    /// @param account 주조된 통화량을 받을 계정
    /// @param amount 주조할 통화량
    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: mint to the zero address");
        _supply = _supply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    /// @author jhhong
    /// @notice 통화량(value)만큼 소각하여 계정(account)의 통화량에서 뺀다.
    /// @dev ERC20Mint에 정의하면 private 속성인 supply와 balances에 access할 수 없어서 ERC20에 internal로 정의함.
    /// @param account 통화량을 소각시킬 계정
    /// @param value 소각시킬 통화량
    function _burn(address account, uint256 value) internal {
        require(account != address(0), "ERC20: burn from the zero address");
        _balances[account] = _balances[account].sub(value, "ERC20: burn amount exceeds balance");
        _supply = _supply.sub(value);
        emit Transfer(account, address(0), value);
    }
}