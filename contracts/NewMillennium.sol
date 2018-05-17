pragma solidity ^0.4.18;

/**
 * New Millenium is a rare digital art gallery that allows artist to create
 * private exhibitions to showcase their work. To view the current exhibition you
 * must purchase a membership which will allow access for the duration.
 */
contract NewMillinneum {

    address public owner;

    // Cost = 0.005 ETH ~ $3.50
    uint public MEMBERSHIP_COST = 5000000000000000;

    // exhibitor takes ~95% of proceeds
    uint public EXHIBITOR_PROCEEDS = 4700000000000000;

    uint public EXHIBITION_DURATION_SECONDS = 60 * 60 * 24 * 30; // 30 days in seconds

    uint public exhibition = 0;
    
    mapping (address => uint) public membership;

    mapping (uint => address) public exhibitor;

    mapping (address => uint) public pendingWithdrawals;

    uint exhibitionStartUnixTimestamp = 0;

    function NewMillenium()
        public
    {
        owner = msg.sender;
    }

    function purchaseMembership() 
        payable
        public
        returns (bool) 
    {
        // provide current exhibition membership
        require(msg.value == MEMBERSHIP_COST);
        membership[msg.sender] = exhibition;

        address currentExhibitor = exhibitor[exhibition];
        // exhibitor balance = balance + their membership take
        pendingWithdrawals[currentExhibitor] = pendingWithdrawals[currentExhibitor] + EXHIBITOR_PROCEEDS;
    }

    // allow new exhibitor to initate a new exhibition
    function nextExhibition(address newExhibitor)
        public
    {
        require(exhibitionStartUnixTimestamp > 30 days);

        // reset exhibition and memberships
        exhibitionStartUnixTimestamp = now;
        exhibition++;
        exhibitor[exhibition] = newExhibitor;
    }

    function withdraw()
        public
    {
        uint amount = pendingWithdrawals[msg.sender];
        pendingWithdrawals[msg.sender] = 0;
        msg.sender.transfer(amount);
    }

    
}

