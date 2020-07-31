pragma solidity >=0.5.0 <0.6.0;

/// @title IERC20
/// @notice EIP20 interface 선언
/// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
/// @author jhhong
interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}