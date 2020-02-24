pragma solidity ^0.5.16;
/* acknowledgement of idea of code/
/*https://medium.com/@naqvi.jafar91/converting-a-property-rental-paper-contract-into-a-smart-contract-daa054fdf8a7*/
/*co-authors lynet Svotwa and Samukeliso Mabarani*/
//we first need to create a contract
contract RentalLeaseAgreement {

    /* Declaration a new struct type which will hold the paid rents*/
    struct PaidRent {
    uint id; /* The paid rent id*/
    uint price; /* The amount of rent that is to be paid*/
    }

    PaidRent[] public paidrents;

    uint public createdTimestamp;
    uint public rent;
    /* Combination of zip code and house number*/
    string public house;
    address public landlord;
    address public tenant;
    enum State {Created, Started, Terminated}
    State public state;

    function RentalAgreement(uint _rent, string _house) {
        rent = _rent;
        house = _house;
        landlord = msg.sender;
        createdTimestamp = block.timestamp;
    }
  
}
