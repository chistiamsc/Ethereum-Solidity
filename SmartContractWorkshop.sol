pragma solidity ^0.4.23;

contract SmartContractWorkshop {
	
	struct Person {
		string name;
		string email;
		bool attendsOnline;
		bool purchased;
	}

	uint256 baseprice = 0.03 ether;
	uint256 priceIncrease = 0.001 ether;
	address owner;
	uint256 faceToFaceLimit = 24;
	uint256 public ticketsSold;
	uint256 public ticketsFaceToFaceSold;

	string public eventWebsite;

	mapping(address=>Person) public attendants;

	address[] allAttendants;
	address[] faceToFaceAttendants;

	function SmartContractWorkshop (string _eventWebsite) {
		owner = msg.sender;
		eventWebsite = _eventWebsite;
	}
	

	function register(string _name, string _email, bool _attendsOnline) payable {

		require (msg.value == currentPrice() && attendants[msg.sender].purchased == false);

		if(_attendsOnline == false ) {
			ticketsFaceToFaceSold++;

			require (ticketsFaceToFaceSold <= faceToFaceLimit);

			addAttendantAndTransfer(_name, _email, _attendsOnline);
			faceToFaceAttendants.push(msg.sender);
		} else {
			addAttendantAndTransfer(_name, _email, _attendsOnline);
		}
		allAttendants.push(msg.sender);
	}

	function addAttendantAndTransfer(string _name, string _email, bool _attendsOnline) internal {
				attendants[msg.sender] = Person({
				name: _name,
				email: _email,
				attendsOnline: _attendsOnline,
				purchased: true
		});
		ticketsSold++;
		owner.transfer(this.balance);
	}

	function listAllAttendants() external view returns(address[]){
        return allAttendants;
    }

    function listFaceToFaceAttendants() external view returns(address[]){
        return faceToFaceAttendants;
    }

	function currentPrice() public view returns (uint256) {
        return baseprice + (ticketsSold * priceIncrease);
    }

    modifier onlyOwner() {
		if(owner != msg.sender) {
			revert();
		} else {
			_;
		}
	}
}