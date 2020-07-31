pragma solidity >=0.5.0 <0.6.0;

import "./ERC20.sol";
import "../../libs/refs/SafeMath.sol";

/// @title ERC20Safe
/// @notice Approve Bug Fix 버전 (중복 위임 방지)
/// @author jhhong
contract ERC20Safe is ERC20 {
    using SafeMath for uint256;

    /// @author jhhong
    /// @notice 계정(spender)에게 통화량(amount)을 위임한다.
    /// @dev 값이 덮어써짐을 방지하기 위해 기존에 위임받은 통화량이 0인 경우에만 호출을 허용한다.
    /// @param spender 위임받을 계정
    /// @param amount 위임할 통화량
    /// @return 정상처리 시 true
    function approve(address spender, uint256 amount) public returns (bool) {
        require((amount == 0) || (allowance(msg.sender, spender) == 0), "ERC20Safe: approve from non-zero to non-zero allowance");
        return super.approve(spender, amount);
    }

    /// @author jhhong
    /// @notice 계정(spender)에 위임된 통화량에 통화량(addedValue)를 더한값을 위임한다.
    /// @dev 위임된 통화량이 있을 경우, 통화량 증가는 상기 함수로 수행할 것
    /// @param spender 위임받을 계정
    /// @param addedValue 더해질 통화량
    /// @return 정상처리 시 true
    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        uint256 amount = allowance(msg.sender, spender).add(addedValue);
        return super.approve(spender, amount);
    }
    
    /// @author jhhong
    /// @notice 계정(spender)에 위임된 통화량에 통화량(subtractedValue)를 뺀값을 위임한다.
    /// @dev 위임된 통화량이 있을 경우, 통화량 감소는 상기 함수로 수행할 것
    /// @param spender 위임받을 계정
    /// @param subtractedValue 빼질 통화량
    /// @return 정상처리 시 true
    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        uint256 amount = allowance(msg.sender, spender).sub(subtractedValue, "ERC20: decreased allowance below zero");
        return super.approve(spender, amount);
    }
}