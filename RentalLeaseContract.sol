pragma solidity ^0.5.11;
/*co-authors lynet Svotwa and Samukeliso Mabarani*/
//we first need to declare the contract
contract RentalLeaseAgreement {

    /* Declaration a new struct type which will hold the paid rents*/
    struct PaidRent {
    uint rentid; /* The paid rent id*/
    uint price; /* The amount of rent that is to be paid*/
    }

    PaidRent[] public paidrents;
    uint public createdTimestamp;
    uint public rent;
    string public house;
    address public landlord;
    address public tenant;
    enum State {Created, Started, Terminated}
    State public state;

    function RentalAgreement(uint _rent,  string memory _house) public{
        rent = _rent;
        house = _house;
        landlord = msg.sender;
        createdTimestamp = block.timestamp;
    }
    modifier require(bool _condition) {
        if (!_condition) assert;
        _;
    }
    modifier onlyLandlord() {
        if (msg.sender != landlord) assert;
        _;
    }
    modifier onlyTenant() {
        if (msg.sender != tenant) assert;
        _;
    }
    modifier inState(State _state) {
        if (state != _state) assert;
        _;
    }

    function getPaidRents() internal returns (PaidRent[] storage) {
        return paidrents;
    }

    function getHouse() public pure returns ( string memory) {
        return house;
    }

    function getLandlord() public pure returns (address _addresses) {
        return landlord;
    }

    function getTenant()public pure returns (address) {
        return tenant;
    }

    function getRent() public pure returns (uint) {
        return rent;
    }

    function getContractCreated() public pure returns (uint) {
        return createdTimestamp;
    }

    function getContractAddress() public pure returns (address) {
        return address(this);
    }

    function getState() public pure returns (State) {
        return state;
    }

    /* Events for our future DApp to listen to */
    event agreementConfirmed();

    event paidRent();

    event contractTerminated();

    /* Confirm the lease agreement as tenant*/
    function confirmAgreement() public
    inState(State.Created)
    require(msg.sender != landlord)
    {
       emit  agreementConfirmed();
        tenant = msg.sender;
        state = State.Started;
    }

    function payRent() public payable
    onlyTenant
    inState(State.Started)
    require(msg.value == rent)
    {
       emit  paidRent();
        landlord.transfer(address(msg.value));
        paidrents.push(PaidRent({
        rentid : paidrents.length + 1,
        value : msg.value
        }));
    }

    function terminateContract() public
    onlyLandlord
    {
       emit contractTerminated();
       emit landlord.transfer(address(this).balance);
        state = State.Terminated;
    }
}
