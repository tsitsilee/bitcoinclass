pragma solidity ^0.5.11;
/*co-authors lynet Svotwa and Samukeliso Mabarani*/
//we first need to declare the contract
/*inside the contract is where we put our code functionality and methods*/
/*we used compiler version 0.5.11 becuase it contained the functionality we needed especially for pybale addresses*/
/*the code is centered on two users the lanlord and the tenant and the functions that they can perform*/
/* for future linkage with a frontend events are also emiited that the javascript can listen too*/
/*logic for the code is as follows
    create a contract
    declare variables
    create functions
    set conditions as modifiers before executions
    emit events
*/
contract RentalLease {

    /* Declaration the PaidRent as a struct type which will hold the paid rents*/
    struct PaidRent {
    uint rentid; /* The paid rent id*/
    uint value; /* The amount of rent that is to be paid*/
    }
     // declaration of the parameters we are going to use therre by determining the type
    PaidRent[] public paidrents;         //mapping the PaidRent struct
    uint public createdTimestamp;           //timestamp to noe when block was created
    uint public rent;                     //rent amount to be paid
    string public house;                   //address of the house 
    address public landlord;              //public address of the landlord which is more for indentification
    address public tenant;               //public address of the tenent also for identification
    enum State {Created, Started, Terminated}  //potnential states of the contract
    State public state;

    //function on the RentalAgreement which takes two variables which we made public for now
    function RentalAgreement(uint _rent,  string memory _house) public{
        rent = _rent;       //the amount expected by the landlord
        house = _house;     //address of the house
        landlord = msg.sender;
        createdTimestamp = block.timestamp; //we need the time of when the block was created
    }
     //conditions to ensure if the condition is not met then terminate otherwise execute as required
     //modifiers allow me to wrap additional functionality to a method, so they're kind of like the decorator pattern in OOP
     //this therefor ensures before the smart contract is executed the conditions are met
    modifier required(bool _condition) {
        if (!_condition) assert;
        _;
    }
    //condition to esure that there is only one landlord
    modifier onlyLandlord() {
        if (msg.sender != landlord) assert;
        _;
    }
    //condition to ensure there is one tenant for that house
    modifier onlyTenant() {
        if (msg.sender != tenant) assert;
        _;
    }
    modifier inState(State _state) {
        if (state != _state) assert;
        _;
    }
      //function for the landlord to get the paid rents
    function getPaidRents() internal view returns (PaidRent[] storage) {
        return paidrents;  //it returns the value that was aid by the tenant
    }

    //function to get information on the house
    function getHouse() public view returns ( string memory) {
        return house;       //it returns the address of the house
    }
     //function to get information on the landlord
    function getLandlord() public view returns (address _addresses) {
        return landlord;    //it returns the public address of the landlord
    }
     //function to get information on the tenant
    function getTenant()public view returns (address) {
        return tenant;   //it returns the public address of the tenant
    }
     //function to get the expected rent to be paid
    function getRent() public view returns (uint) {
        return rent;   // it returns the amount specified by the landlord
    } 
     //function to get the created contract
    function getContractCreated() public view returns (uint) {
        return createdTimestamp;   //returning the time when the contract was created incase of disputes
    }
    //function to get the address assinged to the contract upon creation
    function getContractAddress() public view returns (address) {
        return address(this); //return the new address after deployment
    }
    //function to get the state of the contract
    function getState() public view returns (State) {
        return state; //if true return 1 if false return 0
    }

    /* Events for our future DApp to listen to 
    can be linked to the app.js if using web3.js in visual studiio code*/
    event agreementConfirmed();

    event paidRent();

    event contractTerminated();

    /* Confirm the lease agreement as tenant
    if the tenant agrees to the term the tenant has to sign as a form of agreement*/
    function confirmAgreement() public
    inState(State.Created)      
    required(msg.sender != landlord)    //required to ensure the landlord is bound to the house
    {
       emit  agreementConfirmed();
        tenant = msg.sender;
        state = State.Started;
    }

     //function to pay the required rent
     // made the address payable to allow the tenant to pay rent to the tenant
    function payRent() public payable
    onlyTenant
    inState(State.Started)
    required(msg.value == rent)
    {
       emit  paidRent();
        address(uint160(landlord)).transfer(msg.value);
        paidrents.push(PaidRent({
        rentid : paidrents.length + 1,
        value : msg.value
        }));
    }
     //function to terminate a contract
    function terminateContract() public
    onlyLandlord
    {
        //contract should only be terminated by landlord
       emit contractTerminated();
       address(uint160(landlord)).transfer(address(this).balance);
        state = State.Terminated;
    }
}
