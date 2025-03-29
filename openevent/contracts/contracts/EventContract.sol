// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract EventContract is Ownable, ReentrancyGuard, ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _eventIds;
    Counters.Counter private _tokenIds;

    // Custom errors
    error StartDateInPast();
    error EndDateBeforeStart();
    error MaxTicketsZero();
    error EventNotActive();
    error EventSoldOut();
    error AlreadyHasTicket();
    error InsufficientPayment();
    error NotOrganizer();
    error NoFundsToWithdraw();
    error TransferFailed();
    error EventNotStarted();
    error EventEnded();

    struct Event {
        uint256 id;
        string name;
        string description;
        uint256 startDate;
        uint256 endDate;
        string location;
        address organizer;
        uint256 ticketPrice;
        uint256 maxTickets;
        uint256 soldTickets;
        bool isActive;
        string ipfsHash;
        string ticketMetadataURI;
    }

    mapping(uint256 => Event) public events;
    mapping(address => uint256[]) public organizerEvents;
    mapping(uint256 => uint256) public eventTickets; // eventId => tokenId
    mapping(uint256 => uint256) public ticketEvents; // tokenId => eventId

    event EventCreated(
        uint256 indexed eventId,
        string name,
        address indexed organizer,
        uint256 startDate,
        uint256 endDate
    );

    event TicketPurchased(
        uint256 indexed eventId,
        address indexed buyer,
        uint256 indexed tokenId
    );

    event EventCancelled(uint256 indexed eventId, address indexed organizer);
    event TicketTransferred(uint256 indexed tokenId, address from, address to);

    constructor() ERC721("OpenEvent Ticket", "OET") Ownable(msg.sender) {}

    function createEvent(
        string memory _name,
        string memory _description,
        uint256 _startDate,
        uint256 _endDate,
        string memory _location,
        uint256 _ticketPrice,
        uint256 _maxTickets,
        string memory _ipfsHash,
        string memory _ticketMetadataURI
    ) external returns (uint256) {
        if (_startDate <= block.timestamp) revert StartDateInPast();
        if (_endDate <= _startDate) revert EndDateBeforeStart();
        if (_maxTickets == 0) revert MaxTicketsZero();

        _eventIds.increment();
        uint256 newEventId = _eventIds.current();

        events[newEventId] = Event({
            id: newEventId,
            name: _name,
            description: _description,
            startDate: _startDate,
            endDate: _endDate,
            location: _location,
            organizer: msg.sender,
            ticketPrice: _ticketPrice,
            maxTickets: _maxTickets,
            soldTickets: 0,
            isActive: true,
            ipfsHash: _ipfsHash,
            ticketMetadataURI: _ticketMetadataURI
        });

        organizerEvents[msg.sender].push(newEventId);

        emit EventCreated(newEventId, _name, msg.sender, _startDate, _endDate);

        return newEventId;
    }

    function purchaseTicket(uint256 _eventId) external payable nonReentrant {
        Event storage event_ = events[_eventId];
        if (!event_.isActive) revert EventNotActive();
        if (event_.soldTickets >= event_.maxTickets) revert EventSoldOut();
        if (msg.value < event_.ticketPrice) revert InsufficientPayment();

        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();

        _safeMint(msg.sender, newTokenId);
        _setTokenURI(newTokenId, event_.ticketMetadataURI);

        event_.soldTickets++;
        eventTickets[_eventId] = newTokenId;
        ticketEvents[newTokenId] = _eventId;

        emit TicketPurchased(_eventId, msg.sender, newTokenId);
    }

    function transferTicket(uint256 _tokenId, address _to) external {
        uint256 eventId = ticketEvents[_tokenId];
        Event storage event_ = events[eventId];
        
        if (block.timestamp < event_.startDate) revert EventNotStarted();
        if (block.timestamp > event_.endDate) revert EventEnded();
        
        require(_isApprovedOrOwner(msg.sender, _tokenId), "Not ticket owner or approved");
        
        _transfer(msg.sender, _to, _tokenId);
        emit TicketTransferred(_tokenId, msg.sender, _to);
    }

    function cancelEvent(uint256 _eventId) external {
        Event storage event_ = events[_eventId];
        if (event_.organizer != msg.sender) revert NotOrganizer();
        if (!event_.isActive) revert EventNotActive();
        if (block.timestamp >= event_.startDate) revert EventNotActive();

        event_.isActive = false;
        emit EventCancelled(_eventId, msg.sender);
    }

    function getEvent(uint256 _eventId) external view returns (Event memory) {
        return events[_eventId];
    }

    function getOrganizerEvents(address _organizer) external view returns (uint256[] memory) {
        return organizerEvents[_organizer];
    }

    function getTicketEvent(uint256 _tokenId) external view returns (uint256) {
        return ticketEvents[_tokenId];
    }

    function withdrawFunds() external onlyOwner {
        uint256 balance = address(this).balance;
        if (balance == 0) revert NoFundsToWithdraw();
        
        (bool success, ) = owner().call{value: balance}("");
        if (!success) revert TransferFailed();
    }

    function _burn(uint256 tokenId) internal override(ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }
} 