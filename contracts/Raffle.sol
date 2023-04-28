// User enters into lottery after paying some ETH amount
// get Random number(verifiable)
// get the above random number and choose winner based on this random number
// Random number generation & winner selection should be done in certain time interval e.g. 5min,1hour or anything.

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";

error Raffle__NotEnoughEthEntered(
    uint256 ethAmountTransferred,
    uint256 ethAmountRequired
);
error Raffle__TransferFailed();

contract Raffle is VRFConsumerBaseV2 {
    // state variables
    uint256 private i_entranceFee;
    address payable[] private s_players;
    address private i_owner;
    VRFCoordinatorV2Interface private immutable i_vrfCoordinatorV2;
    bytes32 private immutable i_gasLane;
    uint64 private immutable i_subscriptionId;
    uint8 private constant REQUEST_CONFIRMATIONS = 3;
    uint32 private immutable i_callbackGasLimit;
    uint32 private constant NUM_WORDS = 1;

    // lottery variables
    address private s_recentWinner;
    address[] private s_recentWinners;
    // events
    event RaffleEnter(address indexed player);
    event RequestedRaffleWinner(uint256 requestId);
    event WinnerPicked(address indexed winner);
    // modifiers
    modifier requiredEthAmount() {
        if (msg.value != i_entranceFee)
            revert Raffle__NotEnoughEthEntered(msg.value, i_entranceFee);
        _;
    }

    // constructor
    constructor(
        uint256 entranceFee,
        address _vrfCoordinatorV2,
        bytes32 _keyHash,
        uint32 _subscriptionId,
        uint32 _callbackGasLimit
    ) VRFConsumerBaseV2(_vrfCoordinatorV2) {
        i_vrfCoordinatorV2 = VRFCoordinatorV2Interface(_vrfCoordinatorV2);
        i_gasLane = _keyHash;
        i_subscriptionId = _subscriptionId;
        i_entranceFee = entranceFee;
        i_callbackGasLimit = _callbackGasLimit;
        i_owner = msg.sender;
    }

    function requestRandomWinner() external {
        uint256 requestId = i_vrfCoordinatorV2.requestRandomWords(
            i_gasLane,
            i_subscriptionId,
            REQUEST_CONFIRMATIONS,
            i_callbackGasLimit,
            NUM_WORDS
        );
        emit RequestedRaffleWinner(requestId);
    }

    function enterRaffle() public payable requiredEthAmount {
        s_players.push(payable(msg.sender));
        // emit an event when we update a dynamic array & mapping
        // name events with the function name reversed
        emit RaffleEnter(msg.sender);
    }

    function fulfillRandomWords(
        uint256, /* requestId*/
        uint256[] memory randomWords
    ) internal override {
        uint256 indexofWinner = randomWords[0] % s_players.length;
        address payable recentWinner = s_players[indexofWinner];
        s_recentWinners.push(recentWinner);
        s_recentWinner = recentWinner;
        (bool success, ) = recentWinner.call{value: address(this).balance}("");
        if (!success) revert Raffle__TransferFailed();
        emit WinnerPicked(recentWinner);
    }

    function getOwner() public view returns (address) {
        return i_owner;
    }

    function getEntranceFee() public view returns (uint256) {
        return i_entranceFee;
    }

    function getPlayer(uint256 index) public view returns (address) {
        return s_players[index];
    }

    function getRecentWinner() public view returns (address) {
        return s_recentWinner;
    }
}
