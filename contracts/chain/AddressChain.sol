pragma solidity >=0.5.0 <0.6.0;

import "../libs/refs/SafeMath.sol";

/// @title AddressChain
/// @notice 주소 체인 정의 및 관리
/// @dev 토큰홀더, 회원정보 등과 같은 유저 리스트 관리에 쓰인다.
/// @author jhhong
contract AddressChain {
    using SafeMath for uint256;

    // 구조체 : 노드 정보
    struct NodeInfo {
        address prev; // 이전 노드
        address next; // 다음 노드
    }
    // 구조체 : 노드 체인
    struct NodeList {
        uint256 count; // 노드의 총 개수
        address head; // 체인의 머리
        address tail; // 체인의 꼬리
        mapping(address => NodeInfo) map; // 계정에 대한 노드 정보 매핑
    }

    // 변수 선언
    NodeList private _slist; // 노드 체인 (싱글리스트)

    // 이벤트 선언
    event AddressChainLinked(address indexed node); // 이벤트: 체인에 추가됨
    event AddressChainUnlinked(address indexed node); // 이벤트: 체인에서 빠짐

    /// @author jhhong
    /// @notice 체인에 연결된 원소의 개수를 반환한다.
    /// @return 체인에 연결된 원소의 개수
    function count() public view returns(uint256) {
        return _slist.count;
    }

    /// @author jhhong
    /// @notice 체인 헤드 정보를 반환한다.
    /// @return 체인 헤드 정보
    function head() public view returns(address) {
        return _slist.head;
    }

    /// @author jhhong
    /// @notice 체인 꼬리 정보를 반환한다.
    /// @return 체인 꼬리 정보
    function tail() public view returns(address) {
        return _slist.tail;
    }

    /// @author jhhong
    /// @notice node의 다음 노드 정보를 반환한다.
    /// @param node 노드 정보 (체인에 연결되어 있을 수도 있고 아닐 수도 있음)
    /// @return node의 다음 노드 정보
    function nextOf(address node) public view returns(address) {
        return _slist.map[node].next;
    }

    /// @author jhhong
    /// @notice node의 이전 노드 정보를 반환한다.
    /// @param node 노드 정보 (체인에 연결되어 있을 수도 있고 아닐 수도 있음)
    /// @return node의 이전 노드 정보
    function prevOf(address node) public view returns(address) {
        return _slist.map[node].prev;
    }

    /// @author jhhong
    /// @notice node가 체인에 연결된 상태인지를 확인한다.
    /// @param node 체인 연결 여부를 확인할 노드 주소
    /// @return 연결 여부 (boolean), true: 연결됨(linked), false: 연결되지 않음(unlinked)
    function isLinked(address node) public view returns (bool) {
        if(_slist.count == 1 && _slist.head == node && _slist.tail == node) {
            return true;
        } else {
            return (_slist.map[node].prev == address(0) && _slist.map[node].next == address(0))? (false) :(true);
        }
    }

    /// @author jhhong
    /// @notice 새로운 노드 정보를 노드 체인에 연결한다.
    /// @param node 노드 체인에 연결할 노드 주소
    function _linkChain(address node) internal {
        require(node != address(0), "AddressChain: try to link to the zero address");
        require(!isLinked(node), "AddressChain: the node is aleady linked");
        if(_slist.count == 0) {
            _slist.head = _slist.tail = node;
        } else {
            _slist.map[node].prev = _slist.tail;
            _slist.map[_slist.tail].next = node;
            _slist.tail = node;
        }
        _slist.count = _slist.count.add(1);
        emit AddressChainLinked(node);
    }

    /// @author jhhong
    /// @notice node 노드를 체인에서 연결 해제한다.
    /// @param node 노드 체인에서 연결 해제할 노드 주소
    function _unlinkChain(address node) internal {
        require(node != address(0), "AddressChain: try to unlink to the zero address");
        require(isLinked(node), "AddressChain: the node is aleady unlinked");
        address tempPrev = _slist.map[node].prev;
        address tempNext = _slist.map[node].next;
        if (_slist.head == node) {
            _slist.head = tempNext;
        }
        if (_slist.tail == node) {
            _slist.tail = tempPrev;
        }
        if (tempPrev != address(0)) {
            _slist.map[tempPrev].next = tempNext;
            _slist.map[node].prev = address(0);
        }
        if (tempNext != address(0)) {
            _slist.map[tempNext].prev = tempPrev;
            _slist.map[node].next = address(0);
        }
        _slist.count = _slist.count.sub(1);
        emit AddressChainUnlinked(node);
    }
}
