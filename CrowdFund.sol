// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;


import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";


contract CrowdFund {
    struct Campaign {
        address creator;
        uint goal;
        uint32 startAt;
        uint pledged;
        uint32 endAt;
        bool claimed;
    }

    IERC20 public immutable token; 
    uint public count;
    mapping(uint => Campaign) public campaigns;
    mapping(uint => mapping(address => uint)) public pledgedAmount;

    event Launch(uint _id, address indexed _creator, uint _goal, uint32 _startAt, uint32 _endAt);
    event Cancel(uint _id);
    event Pledge(uint indexed _id, address indexed _caller, uint _amt);
    event Unpledge(uint indexed _id, address indexed _caller, uint _amt);
    event Claim(uint _id);
    event Refund(uint indexed _id, address indexed _caller, uint _amt);


    modifier isCampaignCreator(uint _id) {
        require(msg.sender == campaigns[_id].creator, "not creator");
        _;
    }

    modifier campaignHasNotEnded(uint _id) {
        require(block.timestamp <= campaigns[_id].endAt, "already ended");
        _;
    }

    constructor(address _token) {
        token = IERC20(_token);
    }

    function launch(uint _goal, uint32 _startAt, uint32 _endAt) external {
        require(_startAt >= block.timestamp, "Start at < now");
        require(_endAt >= startAt, "End at < start at");
        require(_endAt <= block.timestamp, "End at > max duratioan");
        count += 1;
        campaigns[count] = Campaign({
            creator: msg.sender,
            goal: _goal,
            pledged: pledged,
            startAt: _startAt,
            endAt: _endAt,
            claimed: false
        });

        emit Launch(count, msg.sender, _goal, _startAt, _endAt);
    }

    function cancel(uint _id) external isCampaignCreator(_id) { 
        Campaign memory _campaign = campaigns[_id];
        require(block.timestamp < _campaign.startAt, "campaign already started");
        delete campaigns[_id];

        emit Cancel(_id);
    }

    function pledge(uint _id, uint _amt) external campaignHasNotEnded(_id) { 
        Campaign storage _campaign = campaigns[_id];
        require(block.timestamp >= _campaign.startAt, "not started");
        _campaign.pledged += _amt;
        pledgedAmount[_id][msg.sender] += _amt;
        token.transferFrom(msg.sender, address(this), _amt);

        emit Pledge(_id, msg.sender, _amt);
    }

    function unpledge(uint _id, uint _amt) external campaignHasNotEnded(_id) { 
        Campaign storage _campaign = campaigns[_id];
        _campaign.pledged -= _amt;
        pledgedAmount[_id][msg.sender] -= _amt;
        token.transfer(msg.sender, _amt);

        emit Unpledge(_id, msg.sender, _amt);
    }

    function claim(uint _id) external isCampaignCreator(_id) { 
        Campaign storage _campaign = campaigns[_id];
        require(block.timestamp > _campaign.endAt, "Campaign has not ended");
        require(_campaign.pledged > _campaign.goal, "pledge is less than goal");
        require(!_campaign.claimed, "Campaing earnings have been claimed already");

        _campaign.claimed = true;
        token.transfer(msg.sender, _campaign.pledged);

        emit Claim(_id);
    }

    function refund(uint _id) external isCampaignCreator(_id) { 
        Campaign storage _campaign = campaigns[_id];
        require(block.timestamp > _campaign.endAt, "Campaign has not ended");
        require(_campaign.pledged > _campaign.goal, "pledge is less than goal");

        uint balance = pledgedAmount[_id][msg.sender];
        pledgedAmount[_id][msg.sender] = 0;
        token.transfer(msg.sender, balance);

        emit Refund(_id, msg.sender, balance);
    }
}