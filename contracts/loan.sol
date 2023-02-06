// create a smart contract for a crypto loan
pragma solidity ^0.4.0;

contract Loan {
    // the borrower's address
    address public borrower;
    // the lender's address
    address public lender;
    // the amount of the loan
    uint public loanAmount;
    // the interest rate of the loan
    uint public interestRate;
    // the duration of the loan
    uint public duration;
    // the time the loan was created
    uint public created;
    // the loan's status
    enum Status {
        // the loan is active
        Active,
        // the loan has been paid back
        PaidBack,
        // the loan has been defaulted
        Defaulted,
        // the loan has been closed
        Closed
    }
    Status public status;

    // constructor to set initial values
    constructor(address _borrower, address _lender, uint _amount, uint _interestRate, uint _duration) public {
        borrower = _borrower;
        lender = _lender;
        loanAmount = _amount;
        interestRate = _interestRate;
        duration = _duration;
        created = now;
        status = Status.Active;
    }

    // function to pay back the loan
    function payBack(uint _amount) public {
        require(status == Status.Active, "Loan is not active.");
        require(msg.sender == borrower, "Only the borrower can pay back the loan.");
        require(_amount <= loanAmount, "The amount being paid back is more than the loan amount.");
        
        loanAmount -= _amount;
        if (loanAmount == 0) {
            status = Status.PaidBack;
        }
    }

    // function to default the loan
    function defaultLoan() public {
        require(status == Status.Active, "Loan is not active.");
        require(msg.sender == lender, "Only the lender can default the loan.");
        
        status = Status.Defaulted;
    }

    // function to close the loan
    function closeLoan() public {
        require(status == Status.PaidBack || status == Status.Defaulted, "Loan must be paid back or defaulted to close.");
        require(msg.sender == lender, "Only the lender can close the loan.");

        status = Status.Closed;
    }

    // function to calculate interest
    function calculateInterest() public view returns (uint) {
        uint interest = loanAmount * interestRate * (now - created) / (365 days * duration);
        return interest;
    }
}