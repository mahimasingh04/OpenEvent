// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "./EventToken.sol";

contract EventTicketing is Ownable, Pausable {
    using Counters for Counters.Counter;
    using ECDSA for bytes32;

    struct VIPPerk {
        string name;
        string description;
        bool isActive;
    }

    struct Partnership {
        address partner;
        string name;
        string description;
        uint256 share; // Percentage out of 100
        bool isActive;
    }

    struct Achievement {
        string name;
        string description;
        uint256 reward;
        bool isClaimed;
    }

    struct EventSeries {
        string name;
        string description;
        uint256[] eventIds;
        uint256 totalEvents;
        uint256 completedEvents;
        bool isActive;
        Achievement[] achievements;
    }

    struct TicketTier {
        string name;
        uint256 price;
        uint256 quantity;
        uint256 remaining;
        bool isActive;
        uint256 earlyBirdPrice;
        uint256 earlyBirdEndTime;
        uint256 earlyBirdQuantity;
        uint256 earlyBirdRemaining;
        VIPPerk[] perks;
        uint256 demandMultiplier; // For dynamic pricing
        uint256 lastPriceUpdate;
    }

    struct EventMetadata {
        string venue;
        string category;
        string imageUrl;
        string[] tags;
        uint256 seriesId; // 0 if not part of a series
    }

    struct StreamDetails {
        string streamUrl;
        string quality;
        bool isLive;
        uint256 startTime;
        uint256 endTime;
        uint256 viewerCount;
        string[] supportedDevices;
    }

    struct MerchandiseItem {
        string name;
        string description;
        uint256 price;
        uint256 quantity;
        uint256 remaining;
        string imageUrl;
        bool isAvailable;
        uint256[] tierDiscounts; // Discount percentages for different tiers
    }

    struct SocialPost {
        address author;
        string content;
        uint256 timestamp;
        uint256 likes;
        uint256 comments;
        bool isPinned;
        string[] mediaUrls;
    }

    struct GamificationReward {
        string name;
        string description;
        uint256 points;
        uint256 tokenReward;
        bool isClaimed;
    }

    struct SustainabilityMetrics {
        uint256 carbonOffset;
        uint256 wasteReduction;
        uint256 energyEfficiency;
        uint256 waterConservation;
        string[] greenInitiatives;
    }

    struct Sponsor {
        address sponsorAddress;
        string name;
        string description;
        string logoUrl;
        uint256 sponsorshipLevel; // 1: Bronze, 2: Silver, 3: Gold, 4: Platinum
        uint256 contribution;
        bool isActive;
        string[] benefits;
    }

    struct NetworkingProfile {
        string bio;
        string[] interests;
        string[] skills;
        string[] socialLinks;
        bool isPublic;
        uint256 connections;
        address[] connectedUsers;
    }

    struct Survey {
        string title;
        string description;
        string[] questions;
        uint256 startTime;
        uint256 endTime;
        uint256 responses;
        bool isActive;
        mapping(address => bool) hasResponded;
    }

    struct ScheduleItem {
        string title;
        string description;
        uint256 startTime;
        uint256 endTime;
        string location;
        string[] speakers;
        uint256 capacity;
        uint256 registered;
        bool isPublic;
    }

    struct AccessibilityFeature {
        string name;
        string description;
        bool isAvailable;
        uint256 capacity;
        uint256 registered;
        string[] requirements;
    }

    struct LeaderboardEntry {
        address user;
        uint256 points;
        uint256 rank;
        uint256 lastUpdated;
        string[] achievements;
    }

    struct VRExperience {
        string name;
        string description;
        string vrUrl;
        string[] supportedDevices;
        uint256 duration;
        bool isActive;
        uint256 maxParticipants;
        uint256 currentParticipants;
        string[] requirements;
    }

    struct LanguageSupport {
        string languageCode;
        string name;
        bool isActive;
        string[] translatedContent;
        uint256 lastUpdated;
    }

    struct EmergencyProtocol {
        string title;
        string description;
        string[] procedures;
        string[] emergencyContacts;
        bool isActive;
        uint256 lastUpdated;
        string[] evacuationRoutes;
    }

    struct AnalyticsDashboard {
        uint256 totalRevenue;
        uint256 totalSales;
        uint256 averageRating;
        uint256 totalRatings;
        uint256[] salesByTier;
        uint256[] revenueByTier;
        uint256[] checkInsByTier;
        uint256[] waitlistByTier;
        uint256[] promotionUsage;
        uint256[] engagementMetrics;
        uint256[] socialMetrics;
        uint256[] sustainabilityMetrics;
        uint256[] accessibilityMetrics;
        uint256[] networkingMetrics;
        uint256[] vrMetrics;
        uint256[] languageMetrics;
        uint256[] emergencyMetrics;
    }

    struct Event {
        string name;
        string description;
        uint256 totalTickets;
        uint256 remainingTickets;
        uint256 eventDate;
        address organizer;
        bool isActive;
        EventMetadata metadata;
        uint256 organizerShare;
        TicketTier[] tiers;
        uint256 maxCapacity;
        uint256 currentCapacity;
        bool isRescheduled;
        uint256 originalEventDate;
        uint256 totalRevenue;
        uint256 totalSales;
        uint256 averageRating;
        uint256 totalRatings;
        Partnership[] partnerships;
        uint256 basePriceMultiplier; // For dynamic pricing
        StreamDetails streamDetails;
        MerchandiseItem[] merchandise;
        SocialPost[] socialPosts;
        GamificationReward[] rewards;
        SustainabilityMetrics sustainability;
        uint256 totalPoints;
        mapping(address => uint256) userPoints;
        Sponsor[] sponsors;
        mapping(address => NetworkingProfile) networkingProfiles;
        Survey[] surveys;
        ScheduleItem[] schedule;
        AccessibilityFeature[] accessibilityFeatures;
        uint256 networkingEnabled;
        uint256 surveyCount;
        uint256 scheduleCount;
        uint256 accessibilityCount;
        LeaderboardEntry[] leaderboard;
        VRExperience[] vrExperiences;
        LanguageSupport[] languages;
        EmergencyProtocol[] emergencyProtocols;
        AnalyticsDashboard analytics;
        uint256 leaderboardCount;
        uint256 vrCount;
        uint256 languageCount;
        uint256 emergencyCount;
        NFTCollection[] nftCollections;
        AIRecommendation[] recommendations;
        AutomationRule[] automationRules;
        CrossChainBridge[] bridges;
        DAOProposal[] proposals;
        uint256 nftCount;
        uint256 recommendationCount;
        uint256 automationCount;
        uint256 bridgeCount;
        uint256 proposalCount;
    }

    struct OrganizerProfile {
        string name;
        string description;
        string imageUrl;
        uint256 totalEvents;
        uint256 activeEvents;
        uint256 totalRevenue;
        uint256 averageRating;
        uint256 totalRatings;
        bool isVerified;
    }

    struct ResaleListing {
        address seller;
        uint256 eventId;
        uint256 tierIndex;
        uint256 quantity;
        uint256 price;
        bool isActive;
    }

    struct WaitlistEntry {
        address user;
        uint256 quantity;
        uint256 tierIndex;
        uint256 timestamp;
        bool isActive;
    }

    struct Promotion {
        string code;
        uint256 discountPercentage;
        uint256 maxUses;
        uint256 usedCount;
        uint256 startTime;
        uint256 endTime;
        bool isActive;
    }

    struct InsurancePolicy {
        uint256 coverageAmount;
        uint256 premium;
        uint256 claimDeadline;
        bool isClaimed;
    }

    struct CheckInData {
        uint256 timestamp;
        address validator;
        bytes signature;
        bool isValid;
    }

    struct AnalyticsData {
        uint256 totalRevenue;
        uint256 totalSales;
        uint256 averageRating;
        uint256 totalRatings;
        uint256[] salesByTier;
        uint256[] revenueByTier;
        uint256[] checkInsByTier;
        uint256[] waitlistByTier;
        uint256[] promotionUsage;
    }

    mapping(uint256 => Event) public events;
    mapping(uint256 => mapping(address => mapping(uint256 => uint256))) public ticketHoldings;
    mapping(uint256 => mapping(address => mapping(uint256 => uint256))) public purchasePrices;
    mapping(uint256 => mapping(address => bool)) public hasEntered;
    mapping(address => OrganizerProfile) public organizerProfiles;
    mapping(uint256 => mapping(address => uint256)) public eventRatings;
    mapping(uint256 => ResaleListing) public resaleListings;
    mapping(uint256 => mapping(address => bool)) public vrParticipations;
    mapping(uint256 => mapping(address => bool)) public languagePreferences;
    mapping(uint256 => mapping(address => bool)) public emergencyAcknowledged;
    mapping(uint256 => mapping(address => uint256)) public engagementScores;
    mapping(uint256 => mapping(address => uint256)) public userPoints;
    mapping(uint256 => mapping(address => bool)) public streamAccess;
    mapping(uint256 => mapping(address => bool)) public merchandisePurchases;
    mapping(uint256 => mapping(address => bool)) public rewardClaims;
    mapping(uint256 => mapping(address => bool)) public postLikes;
    mapping(uint256 => mapping(address => bool)) public postComments;

    mapping(uint256 => mapping(address => bool)) public sponsorApprovals;
    mapping(uint256 => mapping(address => bool)) public networkingConnections;
    mapping(uint256 => mapping(address => bool)) public scheduleRegistrations;
    mapping(uint256 => mapping(address => bool)) public accessibilityRegistrations;

    mapping(uint256 => mapping(string => Promotion)) public promotions;
    mapping(uint256 => mapping(address => InsurancePolicy)) public insurancePolicies;
    mapping(uint256 => mapping(address => CheckInData)) public checkInData;
    mapping(uint256 => AnalyticsData) public analyticsData;
    mapping(uint256 => uint256) public waitlistCount;
    mapping(uint256 => uint256) public promotionCount;
    
    uint256 public nextEventId;
    uint256 public nextListingId;
    uint256 public nextCategoryId;
    uint256 public nextSeriesId;
    uint256 public platformFee;
    uint256 public resaleFee;
    uint256 public priceUpdateInterval; // Time between price updates
    uint256 public maxPriceMultiplier; // Maximum price increase
    uint256 public insurancePremiumRate; // Percentage out of 100
    uint256 public insuranceCoverageRate; // Percentage out of 100
    uint256 public checkInWindow; // Time window for check-in in seconds
    address public signerAddress;
    EventToken public eventToken;

    mapping(uint256 => mapping(address => bool)) public nftHoldings;
    mapping(uint256 => mapping(address => bool)) public recommendationViews;
    mapping(uint256 => mapping(address => bool)) public automationTriggers;
    mapping(uint256 => mapping(address => bool)) public bridgeTransactions;
    mapping(uint256 => mapping(address => bool)) public proposalVotes;

    event EventCreated(
        uint256 indexed eventId,
        string name,
        uint256 totalTickets,
        uint256 eventDate,
        address organizer
    );
    event TicketsPurchased(
        uint256 indexed eventId,
        address indexed buyer,
        uint256 tierIndex,
        uint256 quantity,
        bool isEarlyBird
    );
    event EventCancelled(uint256 indexed eventId);
    event TicketsTransferred(
        uint256 indexed eventId,
        address indexed from,
        address indexed to,
        uint256 tierIndex,
        uint256 quantity
    );
    event TicketsRefunded(
        uint256 indexed eventId,
        address indexed holder,
        uint256 tierIndex,
        uint256 quantity,
        uint256 amount
    );
    event EventRescheduled(
        uint256 indexed eventId,
        uint256 newEventDate
    );
    event TicketValidated(
        uint256 indexed eventId,
        address indexed holder
    );
    event OrganizerProfileUpdated(
        address indexed organizer,
        string name,
        string description
    );
    event EventRated(
        uint256 indexed eventId,
        address indexed rater,
        uint256 rating
    );
    event ResaleListingCreated(
        uint256 indexed listingId,
        uint256 indexed eventId,
        address indexed seller,
        uint256 tierIndex,
        uint256 quantity,
        uint256 price
    );
    event ResaleListingPurchased(
        uint256 indexed listingId,
        address indexed buyer
    );
    event CategoryCreated(
        uint256 indexed categoryId,
        string name
    );
    event SeriesCreated(
        uint256 indexed seriesId,
        string name,
        string description
    );
    event EventAddedToSeries(
        uint256 indexed seriesId,
        uint256 indexed eventId
    );
    event AchievementUnlocked(
        uint256 indexed seriesId,
        address indexed user,
        string achievement
    );
    event PartnershipAdded(
        uint256 indexed eventId,
        address indexed partner,
        string name
    );
    event PriceUpdated(
        uint256 indexed eventId,
        uint256 indexed tierIndex,
        uint256 newPrice
    );
    event WaitlistEntryAdded(
        uint256 indexed eventId,
        address indexed user,
        uint256 quantity,
        uint256 tierIndex
    );
    event WaitlistEntryFilled(
        uint256 indexed eventId,
        address indexed user,
        uint256 quantity,
        uint256 tierIndex
    );
    event PromotionCreated(
        uint256 indexed eventId,
        string code,
        uint256 discountPercentage
    );
    event PromotionUsed(
        uint256 indexed eventId,
        string code,
        address indexed user
    );
    event InsurancePurchased(
        uint256 indexed eventId,
        address indexed user,
        uint256 coverageAmount
    );
    event InsuranceClaimed(
        uint256 indexed eventId,
        address indexed user,
        uint256 amount
    );
    event CheckInCompleted(
        uint256 indexed eventId,
        address indexed user,
        uint256 timestamp
    );
    event StreamStarted(
        uint256 indexed eventId,
        string streamUrl,
        string quality
    );
    event StreamEnded(
        uint256 indexed eventId,
        uint256 viewerCount
    );
    event MerchandiseAdded(
        uint256 indexed eventId,
        string name,
        uint256 price
    );
    event MerchandisePurchased(
        uint256 indexed eventId,
        address indexed buyer,
        string name,
        uint256 quantity
    );
    event SocialPostCreated(
        uint256 indexed eventId,
        address indexed author,
        string content
    );
    event PostLiked(
        uint256 indexed eventId,
        uint256 indexed postIndex,
        address indexed liker
    );
    event PostCommented(
        uint256 indexed eventId,
        uint256 indexed postIndex,
        address indexed commenter
    );
    event PointsEarned(
        uint256 indexed eventId,
        address indexed user,
        uint256 points
    );
    event RewardClaimed(
        uint256 indexed eventId,
        address indexed user,
        string reward
    );
    event SustainabilityUpdated(
        uint256 indexed eventId,
        uint256 carbonOffset,
        uint256 wasteReduction
    );
    event SponsorAdded(
        uint256 indexed eventId,
        address indexed sponsor,
        string name,
        uint256 level
    );
    event SponsorshipApproved(
        uint256 indexed eventId,
        address indexed sponsor
    );
    event NetworkingProfileCreated(
        uint256 indexed eventId,
        address indexed user
    );
    event ConnectionMade(
        uint256 indexed eventId,
        address indexed user1,
        address indexed user2
    );
    event SurveyCreated(
        uint256 indexed eventId,
        string title
    );
    event SurveyResponseSubmitted(
        uint256 indexed eventId,
        address indexed user
    );
    event ScheduleItemAdded(
        uint256 indexed eventId,
        string title
    );
    event ScheduleRegistration(
        uint256 indexed eventId,
        address indexed user,
        string title
    );
    event AccessibilityFeatureAdded(
        uint256 indexed eventId,
        string name
    );
    event AccessibilityRegistration(
        uint256 indexed eventId,
        address indexed user,
        string feature
    );
    event LeaderboardUpdated(
        uint256 indexed eventId,
        address indexed user,
        uint256 points,
        uint256 rank
    );
    event VREnabled(
        uint256 indexed eventId,
        string name,
        string vrUrl
    );
    event LanguageAdded(
        uint256 indexed eventId,
        string languageCode,
        string name
    );
    event EmergencyProtocolAdded(
        uint256 indexed eventId,
        string title
    );
    event AnalyticsUpdated(
        uint256 indexed eventId,
        uint256 timestamp
    );
    event NFTCollectionCreated(
        uint256 indexed eventId,
        string name,
        string symbol
    );
    event NFTMinted(
        uint256 indexed eventId,
        address indexed owner,
        uint256 tokenId
    );
    event RecommendationGenerated(
        uint256 indexed eventId,
        string title,
        uint256 relevanceScore
    );
    event AutomationTriggered(
        uint256 indexed eventId,
        string name,
        string actionType
    );
    event BridgeTransaction(
        uint256 indexed eventId,
        uint256 chainId,
        uint256 transactionId
    );
    event ProposalCreated(
        uint256 indexed eventId,
        string title,
        address proposer
    );
    event ProposalVoted(
        uint256 indexed eventId,
        uint256 proposalIndex,
        address voter,
        bool support
    );
    event ProposalExecuted(
        uint256 indexed eventId,
        uint256 proposalIndex
    );

    constructor() Ownable(msg.sender) {
        eventToken = new EventToken();
        platformFee = 10;
        resaleFee = 5;
        priceUpdateInterval = 1 days;
        maxPriceMultiplier = 200;
        insurancePremiumRate = 5; // 5% premium
        insuranceCoverageRate = 100; // 100% coverage
        checkInWindow = 4 hours;
    }

    function setPlatformFee(uint256 newFee) public onlyOwner {
        require(newFee <= 30, "Platform fee cannot exceed 30%");
        platformFee = newFee;
    }

    function setResaleFee(uint256 newFee) public onlyOwner {
        require(newFee <= 20, "Resale fee cannot exceed 20%");
        resaleFee = newFee;
    }

    function setSignerAddress(address _signer) public onlyOwner {
        signerAddress = _signer;
    }

    function createCategory(string memory name) public onlyOwner {
        require(categoryIds[name] == 0, "Category already exists");
        uint256 categoryId = nextCategoryId++;
        categoryIds[name] = categoryId;
        categoryNames[categoryId] = name;
        emit CategoryCreated(categoryId, name);
    }

    function updateOrganizerProfile(
        string memory name,
        string memory description,
        string memory imageUrl
    ) public {
        OrganizerProfile storage profile = organizerProfiles[msg.sender];
        profile.name = name;
        profile.description = description;
        profile.imageUrl = imageUrl;
        emit OrganizerProfileUpdated(msg.sender, name, description);
    }

    function createEvent(
        string memory name,
        string memory description,
        uint256 eventDate,
        string memory venue,
        string memory category,
        string memory imageUrl,
        string[] memory tags,
        uint256 organizerShare,
        uint256 maxCapacity,
        TicketTier[] memory tiers
    ) public whenNotPaused {
        require(eventDate > block.timestamp, "Event date must be in the future");
        require(maxCapacity > 0, "Max capacity must be greater than 0");
        require(organizerShare <= 90, "Organizer share cannot exceed 90%");
        require(tiers.length > 0, "At least one ticket tier is required");
        require(categoryIds[category] > 0, "Invalid category");

        uint256 totalTickets = 0;
        for(uint i = 0; i < tiers.length; i++) {
            require(tiers[i].quantity > 0, "Tier quantity must be greater than 0");
            require(tiers[i].earlyBirdQuantity <= tiers[i].quantity, "Early bird quantity exceeds total");
            require(tiers[i].earlyBirdPrice <= tiers[i].price, "Early bird price must be lower");
            totalTickets += tiers[i].quantity;
        }
        require(totalTickets <= maxCapacity, "Total tickets exceed max capacity");

        uint256 eventId = nextEventId++;
        events[eventId] = Event({
            name: name,
            description: description,
            totalTickets: totalTickets,
            remainingTickets: totalTickets,
            eventDate: eventDate,
            organizer: msg.sender,
            isActive: true,
            metadata: EventMetadata({
                venue: venue,
                category: category,
                imageUrl: imageUrl,
                tags: tags
            }),
            organizerShare: organizerShare,
            tiers: tiers,
            maxCapacity: maxCapacity,
            currentCapacity: 0,
            isRescheduled: false,
            originalEventDate: eventDate,
            totalRevenue: 0,
            totalSales: 0,
            averageRating: 0,
            totalRatings: 0,
            streamDetails: StreamDetails({
                streamUrl: "",
                quality: "",
                isLive: false,
                startTime: 0,
                endTime: 0,
                viewerCount: 0,
                supportedDevices: new string[](0)
            }),
            merchandise: new MerchandiseItem[](0),
            socialPosts: new SocialPost[](0),
            rewards: new GamificationReward[](0),
            sustainability: SustainabilityMetrics({
                carbonOffset: 0,
                wasteReduction: 0,
                energyEfficiency: 0,
                waterConservation: 0,
                greenInitiatives: new string[](0)
            }),
            totalPoints: 0,
            sponsors: new Sponsor[](0),
            networkingProfiles: new mapping(address => NetworkingProfile)(0),
            surveys: new Survey[](0),
            schedule: new ScheduleItem[](0),
            accessibilityFeatures: new AccessibilityFeature[](0),
            networkingEnabled: 0,
            surveyCount: 0,
            scheduleCount: 0,
            accessibilityCount: 0,
            leaderboard: new LeaderboardEntry[](0),
            vrExperiences: new VRExperience[](0),
            languages: new LanguageSupport[](0),
            emergencyProtocols: new EmergencyProtocol[](0),
            analytics: AnalyticsDashboard({
                totalRevenue: 0,
                totalSales: 0,
                averageRating: 0,
                totalRatings: 0,
                salesByTier: new uint256[](0),
                revenueByTier: new uint256[](0),
                checkInsByTier: new uint256[](0),
                waitlistByTier: new uint256[](0),
                promotionUsage: new uint256[](0),
                engagementMetrics: new uint256[](0),
                socialMetrics: new uint256[](0),
                sustainabilityMetrics: new uint256[](0),
                accessibilityMetrics: new uint256[](0),
                networkingMetrics: new uint256[](0),
                vrMetrics: new uint256[](0),
                languageMetrics: new uint256[](0),
                emergencyMetrics: new uint256[](0)
            }),
            leaderboardCount: 0,
            vrCount: 0,
            languageCount: 0,
            emergencyCount: 0,
            nftCollections: new NFTCollection[](0),
            recommendations: new AIRecommendation[](0),
            automationRules: new AutomationRule[](0),
            bridges: new CrossChainBridge[](0),
            proposals: new DAOProposal[](0),
            nftCount: 0,
            recommendationCount: 0,
            automationCount: 0,
            bridgeCount: 0,
            proposalCount: 0
        });

        categoryEvents[categoryIds[category]].push(eventId);
        organizerProfiles[msg.sender].totalEvents++;
        organizerProfiles[msg.sender].activeEvents++;

        emit EventCreated(
            eventId,
            name,
            totalTickets,
            eventDate,
            msg.sender
        );
    }

    function purchaseTickets(uint256 eventId, uint256 tierIndex, uint256 quantity) public whenNotPaused {
        Event storage eventDetails = events[eventId];
        require(eventDetails.isActive, "Event is not active");
        require(
            eventDetails.eventDate > block.timestamp,
            "Event has already occurred"
        );
        require(tierIndex < eventDetails.tiers.length, "Invalid tier index");
        require(eventDetails.tiers[tierIndex].isActive, "Tier is not active");
        require(
            quantity <= eventDetails.tiers[tierIndex].remaining,
            "Not enough tickets available in this tier"
        );
        require(
            eventDetails.currentCapacity + quantity <= eventDetails.maxCapacity,
            "Event capacity exceeded"
        );

        TicketTier storage tier = eventDetails.tiers[tierIndex];
        uint256 price = tier.price;
        bool isEarlyBird = false;

        if (block.timestamp <= tier.earlyBirdEndTime && tier.earlyBirdRemaining > 0) {
            uint256 earlyBirdQuantity = quantity;
            if (earlyBirdQuantity > tier.earlyBirdRemaining) {
                earlyBirdQuantity = tier.earlyBirdRemaining;
            }
            price = (earlyBirdQuantity * tier.earlyBirdPrice) + 
                   ((quantity - earlyBirdQuantity) * tier.price);
            tier.earlyBirdRemaining -= earlyBirdQuantity;
            isEarlyBird = true;
        } else {
            price = tier.price * quantity;
        }

        require(
            eventToken.transferFrom(msg.sender, address(this), price),
            "Payment failed"
        );

        // Distribute revenue
        uint256 organizerAmount = (price * eventDetails.organizerShare) / 100;
        uint256 platformAmount = price - organizerAmount;
        
        require(eventToken.transfer(eventDetails.organizer, organizerAmount), "Organizer payment failed");
        require(eventToken.transfer(owner(), platformAmount), "Platform fee transfer failed");

        tier.remaining -= quantity;
        eventDetails.remainingTickets -= quantity;
        eventDetails.currentCapacity += quantity;
        eventDetails.totalRevenue += price;
        eventDetails.totalSales += quantity;
        ticketHoldings[eventId][msg.sender][tierIndex] += quantity;
        purchasePrices[eventId][msg.sender][tierIndex] = price / quantity;

        emit TicketsPurchased(eventId, msg.sender, tierIndex, quantity, isEarlyBird);
    }

    function createResaleListing(
        uint256 eventId,
        uint256 tierIndex,
        uint256 quantity,
        uint256 price
    ) public whenNotPaused {
        require(ticketHoldings[eventId][msg.sender][tierIndex] >= quantity, "Insufficient tickets");
        require(price > purchasePrices[eventId][msg.sender][tierIndex], "Price must be higher than purchase price");
        
        Event storage eventDetails = events[eventId];
        require(eventDetails.isActive, "Event is not active");
        require(eventDetails.eventDate > block.timestamp, "Event has already occurred");

        uint256 listingId = nextListingId++;
        resaleListings[listingId] = ResaleListing({
            seller: msg.sender,
            eventId: eventId,
            tierIndex: tierIndex,
            quantity: quantity,
            price: price,
            isActive: true
        });

        ticketHoldings[eventId][msg.sender][tierIndex] -= quantity;

        emit ResaleListingCreated(listingId, eventId, msg.sender, tierIndex, quantity, price);
    }

    function purchaseResaleListing(uint256 listingId) public whenNotPaused {
        ResaleListing storage listing = resaleListings[listingId];
        require(listing.isActive, "Listing is not active");
        require(listing.seller != msg.sender, "Cannot purchase your own listing");

        Event storage eventDetails = events[listing.eventId];
        require(eventDetails.isActive, "Event is not active");
        require(eventDetails.eventDate > block.timestamp, "Event has already occurred");

        uint256 totalCost = listing.price * listing.quantity;
        require(
            eventToken.transferFrom(msg.sender, address(this), totalCost),
            "Payment failed"
        );

        // Distribute revenue
        uint256 resaleFeeAmount = (totalCost * resaleFee) / 100;
        uint256 sellerAmount = totalCost - resaleFeeAmount;
        
        require(eventToken.transfer(listing.seller, sellerAmount), "Seller payment failed");
        require(eventToken.transfer(owner(), resaleFeeAmount), "Resale fee transfer failed");

        listing.isActive = false;
        ticketHoldings[listing.eventId][msg.sender][listing.tierIndex] += listing.quantity;

        emit ResaleListingPurchased(listingId, msg.sender);
    }

    function rateEvent(uint256 eventId, uint256 rating) public {
        require(rating >= 1 && rating <= 5, "Rating must be between 1 and 5");
        require(hasEntered[eventId][msg.sender], "Must have attended event to rate");
        require(eventRatings[eventId][msg.sender] == 0, "Already rated this event");

        Event storage eventDetails = events[eventId];
        eventRatings[eventId][msg.sender] = rating;
        eventDetails.totalRatings++;
        eventDetails.averageRating = 
            ((eventDetails.averageRating * (eventDetails.totalRatings - 1)) + rating) / 
            eventDetails.totalRatings;

        OrganizerProfile storage profile = organizerProfiles[eventDetails.organizer];
        profile.totalRatings++;
        profile.averageRating = 
            ((profile.averageRating * (profile.totalRatings - 1)) + rating) / 
            profile.totalRatings;

        emit EventRated(eventId, msg.sender, rating);
    }

    function transferTickets(uint256 eventId, address to, uint256 tierIndex, uint256 quantity) public whenNotPaused {
        require(to != address(0), "Invalid recipient address");
        require(ticketHoldings[eventId][msg.sender][tierIndex] >= quantity, "Insufficient tickets");
        
        Event storage eventDetails = events[eventId];
        require(eventDetails.isActive, "Event is not active");
        require(eventDetails.eventDate > block.timestamp, "Event has already occurred");

        ticketHoldings[eventId][msg.sender][tierIndex] -= quantity;
        ticketHoldings[eventId][to][tierIndex] += quantity;
        purchasePrices[eventId][to][tierIndex] = purchasePrices[eventId][msg.sender][tierIndex];

        emit TicketsTransferred(eventId, msg.sender, to, tierIndex, quantity);
    }

    function rescheduleEvent(uint256 eventId, uint256 newEventDate) public {
        Event storage eventDetails = events[eventId];
        require(
            msg.sender == eventDetails.organizer || msg.sender == owner(),
            "Not authorized"
        );
        require(eventDetails.isActive, "Event is not active");
        require(newEventDate > block.timestamp, "New date must be in the future");
        require(!eventDetails.isRescheduled, "Event already rescheduled");

        eventDetails.eventDate = newEventDate;
        eventDetails.isRescheduled = true;
        emit EventRescheduled(eventId, newEventDate);
    }

    function cancelEvent(uint256 eventId) public {
        Event storage eventDetails = events[eventId];
        require(
            msg.sender == eventDetails.organizer || msg.sender == owner(),
            "Not authorized"
        );
        require(eventDetails.isActive, "Event is already cancelled");

        eventDetails.isActive = false;
        emit EventCancelled(eventId);
    }

    function claimRefund(uint256 eventId) public {
        Event storage eventDetails = events[eventId];
        require(!eventDetails.isActive, "Event is still active");
        
        uint256 totalRefund = 0;
        for(uint i = 0; i < eventDetails.tiers.length; i++) {
            uint256 ticketCount = ticketHoldings[eventId][msg.sender][i];
            if(ticketCount > 0) {
                uint256 refundAmount = ticketCount * purchasePrices[eventId][msg.sender][i];
                totalRefund += refundAmount;
                ticketHoldings[eventId][msg.sender][i] = 0;
                eventDetails.currentCapacity -= ticketCount;
                
                emit TicketsRefunded(eventId, msg.sender, i, ticketCount, refundAmount);
            }
        }
        
        require(totalRefund > 0, "No tickets to refund");
        require(eventToken.transfer(msg.sender, totalRefund), "Refund transfer failed");
    }

    function validateTicket(uint256 eventId, address holder) public {
        Event storage eventDetails = events[eventId];
        require(
            msg.sender == eventDetails.organizer || msg.sender == owner(),
            "Not authorized"
        );
        require(!hasEntered[eventId][holder], "Ticket already validated");
        
        uint256 totalTickets = 0;
        for(uint i = 0; i < eventDetails.tiers.length; i++) {
            totalTickets += ticketHoldings[eventId][holder][i];
        }
        require(totalTickets > 0, "No valid tickets found");
        
        hasEntered[eventId][holder] = true;
        emit TicketValidated(eventId, holder);
    }

    function getEventDetails(uint256 eventId)
        public
        view
        returns (
            string memory name,
            string memory description,
            uint256 totalTickets,
            uint256 remainingTickets,
            uint256 eventDate,
            address organizer,
            bool isActive,
            EventMetadata memory metadata,
            TicketTier[] memory tiers,
            uint256 maxCapacity,
            uint256 currentCapacity,
            bool isRescheduled,
            uint256 originalEventDate
        )
    {
        Event storage eventDetails = events[eventId];
        return (
            eventDetails.name,
            eventDetails.description,
            eventDetails.totalTickets,
            eventDetails.remainingTickets,
            eventDetails.eventDate,
            eventDetails.organizer,
            eventDetails.isActive,
            eventDetails.metadata,
            eventDetails.tiers,
            eventDetails.maxCapacity,
            eventDetails.currentCapacity,
            eventDetails.isRescheduled,
            eventDetails.originalEventDate
        );
    }

    function getTicketHoldings(uint256 eventId, address holder)
        public
        view
        returns (uint256[] memory)
    {
        Event storage eventDetails = events[eventId];
        uint256[] memory holdings = new uint256[](eventDetails.tiers.length);
        for(uint i = 0; i < eventDetails.tiers.length; i++) {
            holdings[i] = ticketHoldings[eventId][holder][i];
        }
        return holdings;
    }

    function getEventsByCategory(string memory category) public view returns (uint256[] memory) {
        return categoryEvents[categoryIds[category]];
    }

    function getOrganizerProfile(address organizer) public view returns (
        string memory name,
        string memory description,
        string memory imageUrl,
        uint256 totalEvents,
        uint256 activeEvents,
        uint256 totalRevenue,
        uint256 averageRating,
        uint256 totalRatings,
        bool isVerified
    ) {
        OrganizerProfile storage profile = organizerProfiles[organizer];
        return (
            profile.name,
            profile.description,
            profile.imageUrl,
            profile.totalEvents,
            profile.activeEvents,
            profile.totalRevenue,
            profile.averageRating,
            profile.totalRatings,
            profile.isVerified
        );
    }

    function getEventAnalytics(uint256 eventId) public view returns (
        uint256 totalRevenue,
        uint256 totalSales,
        uint256 averageRating,
        uint256 totalRatings
    ) {
        Event storage eventDetails = events[eventId];
        return (
            eventDetails.totalRevenue,
            eventDetails.totalSales,
            eventDetails.averageRating,
            eventDetails.totalRatings
        );
    }

    function createEventSeries(
        string memory name,
        string memory description,
        Achievement[] memory achievements
    ) public onlyOwner {
        uint256 seriesId = nextSeriesId++;
        eventSeries[seriesId] = EventSeries({
            name: name,
            description: description,
            eventIds: new uint256[](0),
            totalEvents: 0,
            completedEvents: 0,
            isActive: true,
            achievements: achievements
        });
        emit SeriesCreated(seriesId, name, description);
    }

    function addEventToSeries(uint256 eventId, uint256 seriesId) public {
        Event storage eventDetails = events[eventId];
        require(
            msg.sender == eventDetails.organizer || msg.sender == owner(),
            "Not authorized"
        );
        require(eventDetails.metadata.seriesId == 0, "Event already in a series");
        require(eventSeries[seriesId].isActive, "Series not active");

        eventDetails.metadata.seriesId = seriesId;
        eventSeries[seriesId].eventIds.push(eventId);
        eventSeries[seriesId].totalEvents++;
        emit EventAddedToSeries(seriesId, eventId);
    }

    function addPartnership(
        uint256 eventId,
        address partner,
        string memory name,
        string memory description,
        uint256 share
    ) public {
        Event storage eventDetails = events[eventId];
        require(
            msg.sender == eventDetails.organizer || msg.sender == owner(),
            "Not authorized"
        );
        require(share <= 20, "Partner share cannot exceed 20%");

        eventDetails.partnerships.push(Partnership({
            partner: partner,
            name: name,
            description: description,
            share: share,
            isActive: true
        }));
        emit PartnershipAdded(eventId, partner, name);
    }

    function addVIPPerk(
        uint256 eventId,
        uint256 tierIndex,
        string memory name,
        string memory description
    ) public {
        Event storage eventDetails = events[eventId];
        require(
            msg.sender == eventDetails.organizer || msg.sender == owner(),
            "Not authorized"
        );
        require(tierIndex < eventDetails.tiers.length, "Invalid tier index");

        eventDetails.tiers[tierIndex].perks.push(VIPPerk({
            name: name,
            description: description,
            isActive: true
        }));
    }

    function updateDynamicPricing(uint256 eventId, uint256 tierIndex) public {
        Event storage eventDetails = events[eventId];
        require(
            msg.sender == eventDetails.organizer || msg.sender == owner(),
            "Not authorized"
        );
        require(tierIndex < eventDetails.tiers.length, "Invalid tier index");

        TicketTier storage tier = eventDetails.tiers[tierIndex];
        require(
            block.timestamp >= tier.lastPriceUpdate + priceUpdateInterval,
            "Too soon to update price"
        );

        uint256 soldPercentage = ((tier.quantity - tier.remaining) * 100) / tier.quantity;
        uint256 newMultiplier = 100; // Base 100%

        if (soldPercentage >= 90) {
            newMultiplier = maxPriceMultiplier;
        } else if (soldPercentage >= 75) {
            newMultiplier = 150; // 150% for 75-90% sold
        } else if (soldPercentage >= 50) {
            newMultiplier = 125; // 125% for 50-75% sold
        }

        tier.price = (tier.price * newMultiplier) / tier.demandMultiplier;
        tier.demandMultiplier = newMultiplier;
        tier.lastPriceUpdate = block.timestamp;

        emit PriceUpdated(eventId, tierIndex, tier.price);
    }

    function checkAchievements(uint256 seriesId, address user) public {
        EventSeries storage series = eventSeries[seriesId];
        require(series.isActive, "Series not active");

        uint256 attendedEvents = 0;
        for(uint i = 0; i < series.eventIds.length; i++) {
            if(hasEntered[series.eventIds[i]][user]) {
                attendedEvents++;
            }
        }

        for(uint i = 0; i < series.achievements.length; i++) {
            if(!achievementClaims[seriesId][user] && !series.achievements[i].isClaimed) {
                if(attendedEvents >= series.totalEvents) {
                    // Award achievement
                    series.achievements[i].isClaimed = true;
                    achievementClaims[seriesId][user] = true;
                    eventToken.mint(user, series.achievements[i].reward);
                    emit AchievementUnlocked(seriesId, user, series.achievements[i].name);
                }
            }
        }
    }

    function getEventSeries(uint256 seriesId) public view returns (
        string memory name,
        string memory description,
        uint256[] memory eventIds,
        uint256 totalEvents,
        uint256 completedEvents,
        bool isActive,
        Achievement[] memory achievements
    ) {
        EventSeries storage series = eventSeries[seriesId];
        return (
            series.name,
            series.description,
            series.eventIds,
            series.totalEvents,
            series.completedEvents,
            series.isActive,
            series.achievements
        );
    }

    function getVIPPerks(uint256 eventId, uint256 tierIndex) public view returns (VIPPerk[] memory) {
        Event storage eventDetails = events[eventId];
        require(tierIndex < eventDetails.tiers.length, "Invalid tier index");
        return eventDetails.tiers[tierIndex].perks;
    }

    function getPartnerships(uint256 eventId) public view returns (Partnership[] memory) {
        Event storage eventDetails = events[eventId];
        return eventDetails.partnerships;
    }

    function joinWaitlist(
        uint256 eventId,
        uint256 tierIndex,
        uint256 quantity
    ) public whenNotPaused {
        Event storage eventDetails = events[eventId];
        require(eventDetails.isActive, "Event is not active");
        require(eventDetails.eventDate > block.timestamp, "Event has already occurred");
        require(tierIndex < eventDetails.tiers.length, "Invalid tier index");
        require(quantity > 0, "Quantity must be greater than 0");

        waitlist[eventId][msg.sender] = WaitlistEntry({
            user: msg.sender,
            quantity: quantity,
            tierIndex: tierIndex,
            timestamp: block.timestamp,
            isActive: true
        });
        waitlistCount[eventId]++;
        analyticsData[eventId].waitlistByTier[tierIndex]++;

        emit WaitlistEntryAdded(eventId, msg.sender, quantity, tierIndex);
    }

    function fillWaitlistEntry(
        uint256 eventId,
        address user,
        uint256 quantity
    ) public {
        Event storage eventDetails = events[eventId];
        require(
            msg.sender == eventDetails.organizer || msg.sender == owner(),
            "Not authorized"
        );
        WaitlistEntry storage entry = waitlist[eventId][user];
        require(entry.isActive, "No active waitlist entry");
        require(quantity <= entry.quantity, "Quantity exceeds waitlist amount");

        uint256 price = eventDetails.tiers[entry.tierIndex].price * quantity;
        require(
            eventToken.transferFrom(user, address(this), price),
            "Payment failed"
        );

        // Distribute revenue
        uint256 organizerAmount = (price * eventDetails.organizerShare) / 100;
        uint256 platformAmount = price - organizerAmount;
        
        require(eventToken.transfer(eventDetails.organizer, organizerAmount), "Organizer payment failed");
        require(eventToken.transfer(owner(), platformAmount), "Platform fee transfer failed");

        eventDetails.tiers[entry.tierIndex].remaining -= quantity;
        eventDetails.remainingTickets -= quantity;
        eventDetails.currentCapacity += quantity;
        ticketHoldings[eventId][user][entry.tierIndex] += quantity;
        entry.quantity -= quantity;

        if (entry.quantity == 0) {
            entry.isActive = false;
            waitlistCount[eventId]--;
        }

        emit WaitlistEntryFilled(eventId, user, quantity, entry.tierIndex);
    }

    function createPromotion(
        uint256 eventId,
        string memory code,
        uint256 discountPercentage,
        uint256 maxUses,
        uint256 startTime,
        uint256 endTime
    ) public {
        Event storage eventDetails = events[eventId];
        require(
            msg.sender == eventDetails.organizer || msg.sender == owner(),
            "Not authorized"
        );
        require(discountPercentage <= 50, "Discount cannot exceed 50%");
        require(startTime < endTime, "Invalid time range");

        promotions[eventId][code] = Promotion({
            code: code,
            discountPercentage: discountPercentage,
            maxUses: maxUses,
            usedCount: 0,
            startTime: startTime,
            endTime: endTime,
            isActive: true
        });
        promotionCount[eventId]++;
        analyticsData[eventId].promotionUsage.push(0);

        emit PromotionCreated(eventId, code, discountPercentage);
    }

    function purchaseInsurance(uint256 eventId) public whenNotPaused {
        Event storage eventDetails = events[eventId];
        require(eventDetails.isActive, "Event is not active");
        require(eventDetails.eventDate > block.timestamp, "Event has already occurred");
        require(insurancePolicies[eventId][msg.sender].coverageAmount == 0, "Insurance already purchased");

        uint256 totalTickets = 0;
        uint256 totalValue = 0;
        for(uint i = 0; i < eventDetails.tiers.length; i++) {
            totalTickets += ticketHoldings[eventId][msg.sender][i];
            totalValue += ticketHoldings[eventId][msg.sender][i] * purchasePrices[eventId][msg.sender][i];
        }
        require(totalTickets > 0, "No tickets to insure");

        uint256 coverageAmount = (totalValue * insuranceCoverageRate) / 100;
        uint256 premium = (coverageAmount * insurancePremiumRate) / 100;

        require(
            eventToken.transferFrom(msg.sender, address(this), premium),
            "Insurance premium payment failed"
        );

        insurancePolicies[eventId][msg.sender] = InsurancePolicy({
            coverageAmount: coverageAmount,
            premium: premium,
            claimDeadline: eventDetails.eventDate + 1 days,
            isClaimed: false
        });

        emit InsurancePurchased(eventId, msg.sender, coverageAmount);
    }

    function claimInsurance(uint256 eventId) public {
        Event storage eventDetails = events[eventId];
        require(!eventDetails.isActive, "Event is still active");
        require(block.timestamp <= eventDetails.eventDate + 1 days, "Claim deadline passed");

        InsurancePolicy storage policy = insurancePolicies[eventId][msg.sender];
        require(policy.coverageAmount > 0, "No insurance policy found");
        require(!policy.isClaimed, "Insurance already claimed");

        policy.isClaimed = true;
        require(
            eventToken.transfer(msg.sender, policy.coverageAmount),
            "Insurance claim transfer failed"
        );

        emit InsuranceClaimed(eventId, msg.sender, policy.coverageAmount);
    }

    function checkIn(
        uint256 eventId,
        address user,
        uint256 timestamp,
        bytes memory signature
    ) public {
        Event storage eventDetails = events[eventId];
        require(
            msg.sender == eventDetails.organizer || msg.sender == owner(),
            "Not authorized"
        );
        require(block.timestamp >= eventDetails.eventDate - checkInWindow, "Too early to check in");
        require(block.timestamp <= eventDetails.eventDate + checkInWindow, "Too late to check in");
        require(!checkInData[eventId][user].isValid, "Already checked in");

        bytes32 messageHash = keccak256(abi.encodePacked(eventId, user, timestamp));
        bytes32 ethSignedMessageHash = messageHash.toEthSignedMessageHash();
        address recoveredSigner = ethSignedMessageHash.recover(signature);

        require(recoveredSigner == signerAddress, "Invalid signature");

        checkInData[eventId][user] = CheckInData({
            timestamp: timestamp,
            validator: msg.sender,
            signature: signature,
            isValid: true
        });

        // Update analytics
        for(uint i = 0; i < eventDetails.tiers.length; i++) {
            if(ticketHoldings[eventId][user][i] > 0) {
                analyticsData[eventId].checkInsByTier[i]++;
            }
        }

        emit CheckInCompleted(eventId, user, timestamp);
    }

    function usePromotion(
        uint256 eventId,
        string memory code,
        uint256 tierIndex,
        uint256 quantity
    ) public whenNotPaused {
        Event storage eventDetails = events[eventId];
        require(eventDetails.isActive, "Event is not active");
        require(eventDetails.eventDate > block.timestamp, "Event has already occurred");
        require(tierIndex < eventDetails.tiers.length, "Invalid tier index");

        Promotion storage promotion = promotions[eventId][code];
        require(promotion.isActive, "Promotion not active");
        require(block.timestamp >= promotion.startTime, "Promotion not started");
        require(block.timestamp <= promotion.endTime, "Promotion expired");
        require(promotion.usedCount < promotion.maxUses, "Promotion usage limit reached");

        uint256 originalPrice = eventDetails.tiers[tierIndex].price * quantity;
        uint256 discount = (originalPrice * promotion.discountPercentage) / 100;
        uint256 finalPrice = originalPrice - discount;

        require(
            eventToken.transferFrom(msg.sender, address(this), finalPrice),
            "Payment failed"
        );

        // Distribute revenue
        uint256 organizerAmount = (finalPrice * eventDetails.organizerShare) / 100;
        uint256 platformAmount = finalPrice - organizerAmount;
        
        require(eventToken.transfer(eventDetails.organizer, organizerAmount), "Organizer payment failed");
        require(eventToken.transfer(owner(), platformAmount), "Platform fee transfer failed");

        eventDetails.tiers[tierIndex].remaining -= quantity;
        eventDetails.remainingTickets -= quantity;
        eventDetails.currentCapacity += quantity;
        ticketHoldings[eventId][msg.sender][tierIndex] += quantity;
        promotion.usedCount++;
        analyticsData[eventId].promotionUsage[promotionCount[eventId] - 1]++;

        emit PromotionUsed(eventId, code, msg.sender);
    }

    function getAnalytics(uint256 eventId) public view returns (
        uint256 totalRevenue,
        uint256 totalSales,
        uint256 averageRating,
        uint256 totalRatings,
        uint256[] memory salesByTier,
        uint256[] memory revenueByTier,
        uint256[] memory checkInsByTier,
        uint256[] memory waitlistByTier,
        uint256[] memory promotionUsage
    ) {
        AnalyticsData storage data = analyticsData[eventId];
        return (
            data.totalRevenue,
            data.totalSales,
            data.averageRating,
            data.totalRatings,
            data.salesByTier,
            data.revenueByTier,
            data.checkInsByTier,
            data.waitlistByTier,
            data.promotionUsage
        );
    }

    function startStream(
        uint256 eventId,
        string memory streamUrl,
        string memory quality,
        string[] memory supportedDevices
    ) public {
        Event storage eventDetails = events[eventId];
        require(
            msg.sender == eventDetails.organizer || msg.sender == owner(),
            "Not authorized"
        );
        require(!eventDetails.streamDetails.isLive, "Stream already live");

        eventDetails.streamDetails = StreamDetails({
            streamUrl: streamUrl,
            quality: quality,
            isLive: true,
            startTime: block.timestamp,
            endTime: 0,
            viewerCount: 0,
            supportedDevices: supportedDevices
        });

        emit StreamStarted(eventId, streamUrl, quality);
    }

    function endStream(uint256 eventId) public {
        Event storage eventDetails = events[eventId];
        require(
            msg.sender == eventDetails.organizer || msg.sender == owner(),
            "Not authorized"
        );
        require(eventDetails.streamDetails.isLive, "Stream not live");

        eventDetails.streamDetails.isLive = false;
        eventDetails.streamDetails.endTime = block.timestamp;

        emit StreamEnded(eventId, eventDetails.streamDetails.viewerCount);
    }

    function addMerchandise(
        uint256 eventId,
        string memory name,
        string memory description,
        uint256 price,
        uint256 quantity,
        string memory imageUrl,
        uint256[] memory tierDiscounts
    ) public {
        Event storage eventDetails = events[eventId];
        require(
            msg.sender == eventDetails.organizer || msg.sender == owner(),
            "Not authorized"
        );
        require(quantity > 0, "Quantity must be greater than 0");
        require(tierDiscounts.length == eventDetails.tiers.length, "Invalid tier discounts");

        eventDetails.merchandise.push(MerchandiseItem({
            name: name,
            description: description,
            price: price,
            quantity: quantity,
            remaining: quantity,
            imageUrl: imageUrl,
            isAvailable: true,
            tierDiscounts: tierDiscounts
        }));

        emit MerchandiseAdded(eventId, name, price);
    }

    function purchaseMerchandise(
        uint256 eventId,
        uint256 itemIndex,
        uint256 quantity
    ) public whenNotPaused {
        Event storage eventDetails = events[eventId];
        require(itemIndex < eventDetails.merchandise.length, "Invalid item");
        MerchandiseItem storage item = eventDetails.merchandise[itemIndex];
        require(item.isAvailable, "Item not available");
        require(quantity <= item.remaining, "Not enough items available");

        uint256 basePrice = item.price * quantity;
        uint256 discount = 0;
        for(uint i = 0; i < eventDetails.tiers.length; i++) {
            if(ticketHoldings[eventId][msg.sender][i] > 0) {
                discount = (basePrice * item.tierDiscounts[i]) / 100;
                break;
            }
        }
        uint256 finalPrice = basePrice - discount;

        require(
            eventToken.transferFrom(msg.sender, address(this), finalPrice),
            "Payment failed"
        );

        item.remaining -= quantity;
        merchandisePurchases[eventId][msg.sender] = true;

        // Award points for purchase
        uint256 points = quantity * 10;
        userPoints[eventId][msg.sender] += points;
        eventDetails.totalPoints += points;

        emit MerchandisePurchased(eventId, msg.sender, item.name, quantity);
        emit PointsEarned(eventId, msg.sender, points);
    }

    function createSocialPost(
        uint256 eventId,
        string memory content,
        string[] memory mediaUrls
    ) public {
        Event storage eventDetails = events[eventId];
        require(hasEntered[eventId][msg.sender], "Must have attended event");

        eventDetails.socialPosts.push(SocialPost({
            author: msg.sender,
            content: content,
            timestamp: block.timestamp,
            likes: 0,
            comments: 0,
            isPinned: false,
            mediaUrls: mediaUrls
        }));

        emit SocialPostCreated(eventId, msg.sender, content);
    }

    function likePost(uint256 eventId, uint256 postIndex) public {
        Event storage eventDetails = events[eventId];
        require(postIndex < eventDetails.socialPosts.length, "Invalid post");
        require(!postLikes[eventId][msg.sender], "Already liked");

        eventDetails.socialPosts[postIndex].likes++;
        postLikes[eventId][msg.sender] = true;

        // Award points for engagement
        uint256 points = 5;
        userPoints[eventId][msg.sender] += points;
        eventDetails.totalPoints += points;

        emit PostLiked(eventId, postIndex, msg.sender);
        emit PointsEarned(eventId, msg.sender, points);
    }

    function commentOnPost(uint256 eventId, uint256 postIndex) public {
        Event storage eventDetails = events[eventId];
        require(postIndex < eventDetails.socialPosts.length, "Invalid post");
        require(!postComments[eventId][msg.sender], "Already commented");

        eventDetails.socialPosts[postIndex].comments++;
        postComments[eventId][msg.sender] = true;

        // Award points for engagement
        uint256 points = 10;
        userPoints[eventId][msg.sender] += points;
        eventDetails.totalPoints += points;

        emit PostCommented(eventId, postIndex, msg.sender);
        emit PointsEarned(eventId, msg.sender, points);
    }

    function addGamificationReward(
        uint256 eventId,
        string memory name,
        string memory description,
        uint256 pointsRequired,
        uint256 tokenReward
    ) public {
        Event storage eventDetails = events[eventId];
        require(
            msg.sender == eventDetails.organizer || msg.sender == owner(),
            "Not authorized"
        );

        eventDetails.rewards.push(GamificationReward({
            name: name,
            description: description,
            points: pointsRequired,
            tokenReward: tokenReward,
            isClaimed: false
        }));
    }

    function claimReward(uint256 eventId, uint256 rewardIndex) public {
        Event storage eventDetails = events[eventId];
        require(rewardIndex < eventDetails.rewards.length, "Invalid reward");
        GamificationReward storage reward = eventDetails.rewards[rewardIndex];
        require(!reward.isClaimed, "Reward already claimed");
        require(userPoints[eventId][msg.sender] >= reward.points, "Insufficient points");

        reward.isClaimed = true;
        userPoints[eventId][msg.sender] -= reward.points;
        eventDetails.totalPoints -= reward.points;

        require(
            eventToken.transfer(msg.sender, reward.tokenReward),
            "Reward transfer failed"
        );

        emit RewardClaimed(eventId, msg.sender, reward.name);
    }

    function updateSustainabilityMetrics(
        uint256 eventId,
        uint256 carbonOffset,
        uint256 wasteReduction,
        uint256 energyEfficiency,
        uint256 waterConservation,
        string[] memory greenInitiatives
    ) public {
        Event storage eventDetails = events[eventId];
        require(
            msg.sender == eventDetails.organizer || msg.sender == owner(),
            "Not authorized"
        );

        eventDetails.sustainability = SustainabilityMetrics({
            carbonOffset: carbonOffset,
            wasteReduction: wasteReduction,
            energyEfficiency: energyEfficiency,
            waterConservation: waterConservation,
            greenInitiatives: greenInitiatives
        });

        emit SustainabilityUpdated(eventId, carbonOffset, wasteReduction);
    }

    function getStreamDetails(uint256 eventId) public view returns (
        string memory streamUrl,
        string memory quality,
        bool isLive,
        uint256 startTime,
        uint256 endTime,
        uint256 viewerCount,
        string[] memory supportedDevices
    ) {
        Event storage eventDetails = events[eventId];
        StreamDetails storage stream = eventDetails.streamDetails;
        return (
            stream.streamUrl,
            stream.quality,
            stream.isLive,
            stream.startTime,
            stream.endTime,
            stream.viewerCount,
            stream.supportedDevices
        );
    }

    function getMerchandise(uint256 eventId) public view returns (MerchandiseItem[] memory) {
        Event storage eventDetails = events[eventId];
        return eventDetails.merchandise;
    }

    function getSocialPosts(uint256 eventId) public view returns (SocialPost[] memory) {
        Event storage eventDetails = events[eventId];
        return eventDetails.socialPosts;
    }

    function getRewards(uint256 eventId) public view returns (GamificationReward[] memory) {
        Event storage eventDetails = events[eventId];
        return eventDetails.rewards;
    }

    function getSustainabilityMetrics(uint256 eventId) public view returns (
        uint256 carbonOffset,
        uint256 wasteReduction,
        uint256 energyEfficiency,
        uint256 waterConservation,
        string[] memory greenInitiatives
    ) {
        Event storage eventDetails = events[eventId];
        SustainabilityMetrics storage metrics = eventDetails.sustainability;
        return (
            metrics.carbonOffset,
            metrics.wasteReduction,
            metrics.energyEfficiency,
            metrics.waterConservation,
            metrics.greenInitiatives
        );
    }

    function getUserPoints(uint256 eventId, address user) public view returns (uint256) {
        return userPoints[eventId][user];
    }

    function addSponsor(
        uint256 eventId,
        address sponsorAddress,
        string memory name,
        string memory description,
        string memory logoUrl,
        uint256 sponsorshipLevel,
        uint256 contribution,
        string[] memory benefits
    ) public {
        Event storage eventDetails = events[eventId];
        require(
            msg.sender == eventDetails.organizer || msg.sender == owner(),
            "Not authorized"
        );
        require(sponsorshipLevel >= 1 && sponsorshipLevel <= 4, "Invalid sponsorship level");

        eventDetails.sponsors.push(Sponsor({
            sponsorAddress: sponsorAddress,
            name: name,
            description: description,
            logoUrl: logoUrl,
            sponsorshipLevel: sponsorshipLevel,
            contribution: contribution,
            isActive: false,
            benefits: benefits
        }));

        emit SponsorAdded(eventId, sponsorAddress, name, sponsorshipLevel);
    }

    function approveSponsorship(uint256 eventId, address sponsor) public {
        Event storage eventDetails = events[eventId];
        require(
            msg.sender == eventDetails.organizer || msg.sender == owner(),
            "Not authorized"
        );
        require(!sponsorApprovals[eventId][sponsor], "Already approved");

        for(uint i = 0; i < eventDetails.sponsors.length; i++) {
            if(eventDetails.sponsors[i].sponsorAddress == sponsor) {
                eventDetails.sponsors[i].isActive = true;
                sponsorApprovals[eventId][sponsor] = true;
                emit SponsorshipApproved(eventId, sponsor);
                break;
            }
        }
    }

    function createNetworkingProfile(
        uint256 eventId,
        string memory bio,
        string[] memory interests,
        string[] memory skills,
        string[] memory socialLinks,
        bool isPublic
    ) public {
        Event storage eventDetails = events[eventId];
        require(hasEntered[eventId][msg.sender], "Must have attended event");

        eventDetails.networkingProfiles[msg.sender] = NetworkingProfile({
            bio: bio,
            interests: interests,
            skills: skills,
            socialLinks: socialLinks,
            isPublic: isPublic,
            connections: 0,
            connectedUsers: new address[](0)
        });

        eventDetails.networkingEnabled++;
        emit NetworkingProfileCreated(eventId, msg.sender);
    }

    function connectWithUser(uint256 eventId, address user) public {
        Event storage eventDetails = events[eventId];
        require(hasEntered[eventId][msg.sender], "Must have attended event");
        require(hasEntered[eventId][user], "User must have attended event");
        require(!networkingConnections[eventId][msg.sender], "Already connected");
        require(eventDetails.networkingProfiles[user].isPublic, "User profile is private");

        eventDetails.networkingProfiles[msg.sender].connections++;
        eventDetails.networkingProfiles[msg.sender].connectedUsers.push(user);
        eventDetails.networkingProfiles[user].connections++;
        eventDetails.networkingProfiles[user].connectedUsers.push(msg.sender);

        networkingConnections[eventId][msg.sender] = true;
        networkingConnections[eventId][user] = true;

        emit ConnectionMade(eventId, msg.sender, user);
    }

    function createSurvey(
        uint256 eventId,
        string memory title,
        string memory description,
        string[] memory questions,
        uint256 startTime,
        uint256 endTime
    ) public {
        Event storage eventDetails = events[eventId];
        require(
            msg.sender == eventDetails.organizer || msg.sender == owner(),
            "Not authorized"
        );
        require(startTime < endTime, "Invalid time range");

        Survey storage survey = eventDetails.surveys[eventDetails.surveyCount++];
        survey.title = title;
        survey.description = description;
        survey.questions = questions;
        survey.startTime = startTime;
        survey.endTime = endTime;
        survey.responses = 0;
        survey.isActive = true;

        emit SurveyCreated(eventId, title);
    }

    function submitSurveyResponse(uint256 eventId, uint256 surveyIndex) public {
        Event storage eventDetails = events[eventId];
        require(hasEntered[eventId][msg.sender], "Must have attended event");
        require(surveyIndex < eventDetails.surveyCount, "Invalid survey");
        Survey storage survey = eventDetails.surveys[surveyIndex];
        require(survey.isActive, "Survey not active");
        require(block.timestamp >= survey.startTime, "Survey not started");
        require(block.timestamp <= survey.endTime, "Survey ended");
        require(!survey.hasResponded[msg.sender], "Already responded");

        survey.responses++;
        survey.hasResponded[msg.sender] = true;

        emit SurveyResponseSubmitted(eventId, msg.sender);
    }

    function addScheduleItem(
        uint256 eventId,
        string memory title,
        string memory description,
        uint256 startTime,
        uint256 endTime,
        string memory location,
        string[] memory speakers,
        uint256 capacity,
        bool isPublic
    ) public {
        Event storage eventDetails = events[eventId];
        require(
            msg.sender == eventDetails.organizer || msg.sender == owner(),
            "Not authorized"
        );
        require(startTime < endTime, "Invalid time range");
        require(capacity > 0, "Capacity must be greater than 0");

        eventDetails.schedule.push(ScheduleItem({
            title: title,
            description: description,
            startTime: startTime,
            endTime: endTime,
            location: location,
            speakers: speakers,
            capacity: capacity,
            registered: 0,
            isPublic: isPublic
        }));

        eventDetails.scheduleCount++;
        emit ScheduleItemAdded(eventId, title);
    }

    function registerForScheduleItem(uint256 eventId, uint256 itemIndex) public {
        Event storage eventDetails = events[eventId];
        require(hasEntered[eventId][msg.sender], "Must have attended event");
        require(itemIndex < eventDetails.schedule.length, "Invalid schedule item");
        ScheduleItem storage item = eventDetails.schedule[itemIndex];
        require(item.isPublic, "Item not public");
        require(item.registered < item.capacity, "Item at capacity");
        require(!scheduleRegistrations[eventId][msg.sender], "Already registered");

        item.registered++;
        scheduleRegistrations[eventId][msg.sender] = true;

        emit ScheduleRegistration(eventId, msg.sender, item.title);
    }

    function addAccessibilityFeature(
        uint256 eventId,
        string memory name,
        string memory description,
        uint256 capacity,
        string[] memory requirements
    ) public {
        Event storage eventDetails = events[eventId];
        require(
            msg.sender == eventDetails.organizer || msg.sender == owner(),
            "Not authorized"
        );
        require(capacity > 0, "Capacity must be greater than 0");

        eventDetails.accessibilityFeatures.push(AccessibilityFeature({
            name: name,
            description: description,
            isAvailable: true,
            capacity: capacity,
            registered: 0,
            requirements: requirements
        }));

        eventDetails.accessibilityCount++;
        emit AccessibilityFeatureAdded(eventId, name);
    }

    function registerForAccessibility(
        uint256 eventId,
        uint256 featureIndex
    ) public {
        Event storage eventDetails = events[eventId];
        require(hasEntered[eventId][msg.sender], "Must have attended event");
        require(featureIndex < eventDetails.accessibilityFeatures.length, "Invalid feature");
        AccessibilityFeature storage feature = eventDetails.accessibilityFeatures[featureIndex];
        require(feature.isAvailable, "Feature not available");
        require(feature.registered < feature.capacity, "Feature at capacity");
        require(!accessibilityRegistrations[eventId][msg.sender], "Already registered");

        feature.registered++;
        accessibilityRegistrations[eventId][msg.sender] = true;

        emit AccessibilityRegistration(eventId, msg.sender, feature.name);
    }

    function getSponsors(uint256 eventId) public view returns (Sponsor[] memory) {
        Event storage eventDetails = events[eventId];
        return eventDetails.sponsors;
    }

    function getNetworkingProfile(uint256 eventId, address user) public view returns (
        string memory bio,
        string[] memory interests,
        string[] memory skills,
        string[] memory socialLinks,
        bool isPublic,
        uint256 connections,
        address[] memory connectedUsers
    ) {
        Event storage eventDetails = events[eventId];
        NetworkingProfile storage profile = eventDetails.networkingProfiles[user];
        return (
            profile.bio,
            profile.interests,
            profile.skills,
            profile.socialLinks,
            profile.isPublic,
            profile.connections,
            profile.connectedUsers
        );
    }

    function getSurveys(uint256 eventId) public view returns (Survey[] memory) {
        Event storage eventDetails = events[eventId];
        return eventDetails.surveys;
    }

    function getSchedule(uint256 eventId) public view returns (ScheduleItem[] memory) {
        Event storage eventDetails = events[eventId];
        return eventDetails.schedule;
    }

    function getAccessibilityFeatures(uint256 eventId) public view returns (AccessibilityFeature[] memory) {
        Event storage eventDetails = events[eventId];
        return eventDetails.accessibilityFeatures;
    }

    function updateLeaderboard(uint256 eventId, address user) public {
        Event storage eventDetails = events[eventId];
        require(hasEntered[eventId][user], "User must have attended event");

        uint256 points = userPoints[eventId][user];
        uint256 rank = 1;

        // Update rank
        for(uint i = 0; i < eventDetails.leaderboard.length; i++) {
            if(eventDetails.leaderboard[i].points > points) {
                rank++;
            }
        }

        // Update or add entry
        bool found = false;
        for(uint i = 0; i < eventDetails.leaderboard.length; i++) {
            if(eventDetails.leaderboard[i].user == user) {
                eventDetails.leaderboard[i].points = points;
                eventDetails.leaderboard[i].rank = rank;
                eventDetails.leaderboard[i].lastUpdated = block.timestamp;
                found = true;
                break;
            }
        }

        if(!found) {
            eventDetails.leaderboard.push(LeaderboardEntry({
                user: user,
                points: points,
                rank: rank,
                lastUpdated: block.timestamp,
                achievements: new string[](0)
            }));
            eventDetails.leaderboardCount++;
        }

        emit LeaderboardUpdated(eventId, user, points, rank);
    }

    function addVRExperience(
        uint256 eventId,
        string memory name,
        string memory description,
        string memory vrUrl,
        string[] memory supportedDevices,
        uint256 duration,
        uint256 maxParticipants,
        string[] memory requirements
    ) public {
        Event storage eventDetails = events[eventId];
        require(
            msg.sender == eventDetails.organizer || msg.sender == owner(),
            "Not authorized"
        );
        require(maxParticipants > 0, "Max participants must be greater than 0");

        eventDetails.vrExperiences.push(VRExperience({
            name: name,
            description: description,
            vrUrl: vrUrl,
            supportedDevices: supportedDevices,
            duration: duration,
            isActive: true,
            maxParticipants: maxParticipants,
            currentParticipants: 0,
            requirements: requirements
        }));

        eventDetails.vrCount++;
        emit VREnabled(eventId, name, vrUrl);
    }

    function joinVRExperience(uint256 eventId, uint256 experienceIndex) public {
        Event storage eventDetails = events[eventId];
        require(hasEntered[eventId][msg.sender], "Must have attended event");
        require(experienceIndex < eventDetails.vrExperiences.length, "Invalid experience");
        VRExperience storage experience = eventDetails.vrExperiences[experienceIndex];
        require(experience.isActive, "Experience not active");
        require(experience.currentParticipants < experience.maxParticipants, "Experience at capacity");
        require(!vrParticipations[eventId][msg.sender], "Already participating");

        experience.currentParticipants++;
        vrParticipations[eventId][msg.sender] = true;

        // Award points for participation
        uint256 points = 50;
        userPoints[eventId][msg.sender] += points;
        eventDetails.totalPoints += points;

        emit PointsEarned(eventId, msg.sender, points);
    }

    function addLanguageSupport(
        uint256 eventId,
        string memory languageCode,
        string memory name,
        string[] memory translatedContent
    ) public {
        Event storage eventDetails = events[eventId];
        require(
            msg.sender == eventDetails.organizer || msg.sender == owner(),
            "Not authorized"
        );

        eventDetails.languages.push(LanguageSupport({
            languageCode: languageCode,
            name: name,
            isActive: true,
            translatedContent: translatedContent,
            lastUpdated: block.timestamp
        }));

        eventDetails.languageCount++;
        emit LanguageAdded(eventId, languageCode, name);
    }

    function setLanguagePreference(uint256 eventId, string memory languageCode) public {
        Event storage eventDetails = events[eventId];
        require(hasEntered[eventId][msg.sender], "Must have attended event");
        require(!languagePreferences[eventId][msg.sender], "Already set preference");

        bool languageExists = false;
        for(uint i = 0; i < eventDetails.languages.length; i++) {
            if(keccak256(bytes(eventDetails.languages[i].languageCode)) == keccak256(bytes(languageCode))) {
                languageExists = true;
                break;
            }
        }
        require(languageExists, "Language not supported");

        languagePreferences[eventId][msg.sender] = true;
    }

    function addEmergencyProtocol(
        uint256 eventId,
        string memory title,
        string memory description,
        string[] memory procedures,
        string[] memory emergencyContacts,
        string[] memory evacuationRoutes
    ) public {
        Event storage eventDetails = events[eventId];
        require(
            msg.sender == eventDetails.organizer || msg.sender == owner(),
            "Not authorized"
        );

        eventDetails.emergencyProtocols.push(EmergencyProtocol({
            title: title,
            description: description,
            procedures: procedures,
            emergencyContacts: emergencyContacts,
            isActive: true,
            lastUpdated: block.timestamp,
            evacuationRoutes: evacuationRoutes
        }));

        eventDetails.emergencyCount++;
        emit EmergencyProtocolAdded(eventId, title);
    }

    function acknowledgeEmergencyProtocol(uint256 eventId, uint256 protocolIndex) public {
        Event storage eventDetails = events[eventId];
        require(hasEntered[eventId][msg.sender], "Must have attended event");
        require(protocolIndex < eventDetails.emergencyProtocols.length, "Invalid protocol");
        require(!emergencyAcknowledged[eventId][msg.sender], "Already acknowledged");

        emergencyAcknowledged[eventId][msg.sender] = true;

        // Award points for acknowledgment
        uint256 points = 20;
        userPoints[eventId][msg.sender] += points;
        eventDetails.totalPoints += points;

        emit PointsEarned(eventId, msg.sender, points);
    }

    function updateAnalytics(uint256 eventId) public {
        Event storage eventDetails = events[eventId];
        require(
            msg.sender == eventDetails.organizer || msg.sender == owner(),
            "Not authorized"
        );

        AnalyticsDashboard storage analytics = eventDetails.analytics;
        analytics.totalRevenue = eventDetails.totalRevenue;
        analytics.totalSales = eventDetails.totalSales;
        analytics.averageRating = eventDetails.averageRating;
        analytics.totalRatings = eventDetails.totalRatings;

        // Update engagement metrics
        analytics.engagementMetrics = new uint256[](4);
        analytics.engagementMetrics[0] = eventDetails.totalPoints;
        analytics.engagementMetrics[1] = eventDetails.socialPosts.length;
        analytics.engagementMetrics[2] = eventDetails.surveyCount;
        analytics.engagementMetrics[3] = eventDetails.networkingEnabled;

        // Update social metrics
        analytics.socialMetrics = new uint256[](3);
        uint256 totalLikes = 0;
        uint256 totalComments = 0;
        uint256 totalConnections = 0;
        for(uint i = 0; i < eventDetails.socialPosts.length; i++) {
            totalLikes += eventDetails.socialPosts[i].likes;
            totalComments += eventDetails.socialPosts[i].comments;
        }
        for(uint i = 0; i < eventDetails.networkingProfiles[msg.sender].connections; i++) {
            totalConnections++;
        }
        analytics.socialMetrics[0] = totalLikes;
        analytics.socialMetrics[1] = totalComments;
        analytics.socialMetrics[2] = totalConnections;

        // Update VR metrics
        analytics.vrMetrics = new uint256[](2);
        uint256 totalVrParticipants = 0;
        for(uint i = 0; i < eventDetails.vrExperiences.length; i++) {
            totalVrParticipants += eventDetails.vrExperiences[i].currentParticipants;
        }
        analytics.vrMetrics[0] = eventDetails.vrCount;
        analytics.vrMetrics[1] = totalVrParticipants;

        // Update language metrics
        analytics.languageMetrics = new uint256[](2);
        uint256 totalLanguagePreferences = 0;
        for(uint i = 0; i < eventDetails.languages.length; i++) {
            if(languagePreferences[eventId][msg.sender]) {
                totalLanguagePreferences++;
            }
        }
        analytics.languageMetrics[0] = eventDetails.languageCount;
        analytics.languageMetrics[1] = totalLanguagePreferences;

        // Update emergency metrics
        analytics.emergencyMetrics = new uint256[](2);
        uint256 totalEmergencyAcknowledged = 0;
        for(uint i = 0; i < eventDetails.emergencyProtocols.length; i++) {
            if(emergencyAcknowledged[eventId][msg.sender]) {
                totalEmergencyAcknowledged++;
            }
        }
        analytics.emergencyMetrics[0] = eventDetails.emergencyCount;
        analytics.emergencyMetrics[1] = totalEmergencyAcknowledged;

        emit AnalyticsUpdated(eventId, block.timestamp);
    }

    function getLeaderboard(uint256 eventId) public view returns (LeaderboardEntry[] memory) {
        Event storage eventDetails = events[eventId];
        return eventDetails.leaderboard;
    }

    function getVRExperiences(uint256 eventId) public view returns (VRExperience[] memory) {
        Event storage eventDetails = events[eventId];
        return eventDetails.vrExperiences;
    }

    function getLanguages(uint256 eventId) public view returns (LanguageSupport[] memory) {
        Event storage eventDetails = events[eventId];
        return eventDetails.languages;
    }

    function getEmergencyProtocols(uint256 eventId) public view returns (EmergencyProtocol[] memory) {
        Event storage eventDetails = events[eventId];
        return eventDetails.emergencyProtocols;
    }

    function getAnalyticsDashboard(uint256 eventId) public view returns (
        uint256 totalRevenue,
        uint256 totalSales,
        uint256 averageRating,
        uint256 totalRatings,
        uint256[] memory engagementMetrics,
        uint256[] memory socialMetrics,
        uint256[] memory vrMetrics,
        uint256[] memory languageMetrics,
        uint256[] memory emergencyMetrics
    ) {
        Event storage eventDetails = events[eventId];
        AnalyticsDashboard storage analytics = eventDetails.analytics;
        return (
            analytics.totalRevenue,
            analytics.totalSales,
            analytics.averageRating,
            analytics.totalRatings,
            analytics.engagementMetrics,
            analytics.socialMetrics,
            analytics.vrMetrics,
            analytics.languageMetrics,
            analytics.emergencyMetrics
        );
    }

    function createNFTCollection(
        uint256 eventId,
        string memory name,
        string memory symbol,
        string memory baseUri,
        uint256 maxSupply,
        uint256 price,
        uint256[] memory tierBenefits,
        string[] memory metadata
    ) public {
        Event storage eventDetails = events[eventId];
        require(
            msg.sender == eventDetails.organizer || msg.sender == owner(),
            "Not authorized"
        );
        require(maxSupply > 0, "Max supply must be greater than 0");

        eventDetails.nftCollections.push(NFTCollection({
            name: name,
            symbol: symbol,
            baseUri: baseUri,
            totalSupply: 0,
            maxSupply: maxSupply,
            price: price,
            isActive: true,
            tierBenefits: tierBenefits,
            metadata: metadata
        }));

        eventDetails.nftCount++;
        emit NFTCollectionCreated(eventId, name, symbol);
    }

    function mintNFT(uint256 eventId, uint256 collectionIndex) public {
        Event storage eventDetails = events[eventId];
        require(hasEntered[eventId][msg.sender], "Must have attended event");
        require(collectionIndex < eventDetails.nftCollections.length, "Invalid collection");
        NFTCollection storage collection = eventDetails.nftCollections[collectionIndex];
        require(collection.isActive, "Collection not active");
        require(collection.totalSupply < collection.maxSupply, "Max supply reached");
        require(!nftHoldings[eventId][msg.sender], "Already minted");

        require(
            eventToken.transferFrom(msg.sender, address(this), collection.price),
            "Payment failed"
        );

        collection.totalSupply++;
        nftHoldings[eventId][msg.sender] = true;

        // Award points for minting
        uint256 points = 100;
        userPoints[eventId][msg.sender] += points;
        eventDetails.totalPoints += points;

        emit NFTMinted(eventId, msg.sender, collection.totalSupply);
        emit PointsEarned(eventId, msg.sender, points);
    }

    function generateRecommendations(uint256 eventId) public {
        Event storage eventDetails = events[eventId];
        require(
            msg.sender == eventDetails.organizer || msg.sender == owner(),
            "Not authorized"
        );

        // Simulate AI recommendation generation
        string[] memory reasons = new string[](3);
        reasons[0] = "Based on user preferences";
        reasons[1] = "Similar to past events";
        reasons[2] = "Popular in your region";

        eventDetails.recommendations.push(AIRecommendation({
            eventId: string(abi.encodePacked(eventId)),
            title: "Recommended Events",
            description: "Events you might be interested in",
            relevanceScore: 85,
            reasons: reasons,
            timestamp: block.timestamp,
            isActive: true
        }));

        eventDetails.recommendationCount++;
        emit RecommendationGenerated(eventId, "Recommended Events", 85);
    }

    function addAutomationRule(
        uint256 eventId,
        string memory name,
        string memory description,
        uint256 triggerType,
        uint256 triggerValue,
        string memory actionType,
        string memory actionValue
    ) public {
        Event storage eventDetails = events[eventId];
        require(
            msg.sender == eventDetails.organizer || msg.sender == owner(),
            "Not authorized"
        );
        require(triggerType >= 1 && triggerType <= 4, "Invalid trigger type");

        eventDetails.automationRules.push(AutomationRule({
            name: name,
            description: description,
            triggerType: triggerType,
            triggerValue: triggerValue,
            actionType: actionType,
            actionValue: actionValue,
            isActive: true,
            lastTriggered: 0
        }));

        eventDetails.automationCount++;
    }

    function checkAutomationRules(uint256 eventId) public {
        Event storage eventDetails = events[eventId];
        require(
            msg.sender == eventDetails.organizer || msg.sender == owner(),
            "Not authorized"
        );

        for(uint i = 0; i < eventDetails.automationRules.length; i++) {
            AutomationRule storage rule = eventDetails.automationRules[i];
            if(!rule.isActive) continue;

            bool shouldTrigger = false;
            if(rule.triggerType == 1) { // Time-based
                shouldTrigger = block.timestamp >= rule.triggerValue;
            } else if(rule.triggerType == 2) { // Capacity-based
                shouldTrigger = eventDetails.currentCapacity >= rule.triggerValue;
            } else if(rule.triggerType == 3) { // Sales-based
                shouldTrigger = eventDetails.totalSales >= rule.triggerValue;
            } else if(rule.triggerType == 4) { // Engagement-based
                shouldTrigger = eventDetails.totalPoints >= rule.triggerValue;
            }

            if(shouldTrigger && !automationTriggers[eventId][msg.sender]) {
                // Execute action
                if(keccak256(bytes(rule.actionType)) == keccak256(bytes("price"))) {
                    // Update price
                } else if(keccak256(bytes(rule.actionType)) == keccak256(bytes("capacity"))) {
                    // Update capacity
                } else if(keccak256(bytes(rule.actionType)) == keccak256(bytes("promotion"))) {
                    // Create promotion
                } else if(keccak256(bytes(rule.actionType)) == keccak256(bytes("notification"))) {
                    // Send notification
                }

                rule.lastTriggered = block.timestamp;
                automationTriggers[eventId][msg.sender] = true;
                emit AutomationTriggered(eventId, rule.name, rule.actionType);
            }
        }
    }

    function addCrossChainBridge(
        uint256 eventId,
        uint256 chainId,
        string memory bridgeAddress,
        uint256[] memory supportedTokens
    ) public {
        Event storage eventDetails = events[eventId];
        require(
            msg.sender == eventDetails.organizer || msg.sender == owner(),
            "Not authorized"
        );

        eventDetails.bridges.push(CrossChainBridge({
            chainId: chainId,
            bridgeAddress: bridgeAddress,
            supportedTokens: supportedTokens,
            isActive: true,
            lastSync: block.timestamp,
            transactionIds: new uint256[](0)
        }));

        eventDetails.bridgeCount++;
    }

    function bridgeTransaction(
        uint256 eventId,
        uint256 bridgeIndex,
        uint256 amount,
        uint256 targetChainId
    ) public {
        Event storage eventDetails = events[eventId];
        require(hasEntered[eventId][msg.sender], "Must have attended event");
        require(bridgeIndex < eventDetails.bridges.length, "Invalid bridge");
        CrossChainBridge storage bridge = eventDetails.bridges[bridgeIndex];
        require(bridge.isActive, "Bridge not active");
        require(bridge.chainId == targetChainId, "Invalid target chain");
        require(!bridgeTransactions[eventId][msg.sender], "Already bridged");

        require(
            eventToken.transferFrom(msg.sender, address(this), amount),
            "Payment failed"
        );

        bridge.transactionIds.push(block.timestamp);
        bridge.lastSync = block.timestamp;
        bridgeTransactions[eventId][msg.sender] = true;

        emit BridgeTransaction(eventId, targetChainId, block.timestamp);
    }

    function createProposal(
        uint256 eventId,
        string memory title,
        string memory description,
        uint256 startTime,
        uint256 endTime,
        string[] memory actions
    ) public {
        Event storage eventDetails = events[eventId];
        require(
            msg.sender == eventDetails.organizer || msg.sender == owner(),
            "Not authorized"
        );
        require(startTime < endTime, "Invalid time range");

        eventDetails.proposals.push(DAOProposal({
            title: title,
            description: description,
            startTime: startTime,
            endTime: endTime,
            forVotes: 0,
            againstVotes: 0,
            executed: false,
            proposer: msg.sender,
            actions: actions
        }));

        eventDetails.proposalCount++;
        emit ProposalCreated(eventId, title, msg.sender);
    }

    function voteProposal(
        uint256 eventId,
        uint256 proposalIndex,
        bool support
    ) public {
        Event storage eventDetails = events[eventId];
        require(hasEntered[eventId][msg.sender], "Must have attended event");
        require(proposalIndex < eventDetails.proposals.length, "Invalid proposal");
        DAOProposal storage proposal = eventDetails.proposals[proposalIndex];
        require(block.timestamp >= proposal.startTime, "Voting not started");
        require(block.timestamp <= proposal.endTime, "Voting ended");
        require(!proposal.hasVoted[msg.sender], "Already voted");

        if(support) {
            proposal.forVotes++;
        } else {
            proposal.againstVotes++;
        }

        proposal.hasVoted[msg.sender] = true;
        emit ProposalVoted(eventId, proposalIndex, msg.sender, support);
    }

    function executeProposal(uint256 eventId, uint256 proposalIndex) public {
        Event storage eventDetails = events[eventId];
        require(
            msg.sender == eventDetails.organizer || msg.sender == owner(),
            "Not authorized"
        );
        require(proposalIndex < eventDetails.proposals.length, "Invalid proposal");
        DAOProposal storage proposal = eventDetails.proposals[proposalIndex];
        require(!proposal.executed, "Already executed");
        require(block.timestamp > proposal.endTime, "Voting still active");
        require(proposal.forVotes > proposal.againstVotes, "Proposal failed");

        // Execute actions
        for(uint i = 0; i < proposal.actions.length; i++) {
            // Execute each action
        }

        proposal.executed = true;
        emit ProposalExecuted(eventId, proposalIndex);
    }

    function getNFTCollections(uint256 eventId) public view returns (NFTCollection[] memory) {
        Event storage eventDetails = events[eventId];
        return eventDetails.nftCollections;
    }

    function getRecommendations(uint256 eventId) public view returns (AIRecommendation[] memory) {
        Event storage eventDetails = events[eventId];
        return eventDetails.recommendations;
    }

    function getAutomationRules(uint256 eventId) public view returns (AutomationRule[] memory) {
        Event storage eventDetails = events[eventId];
        return eventDetails.automationRules;
    }

    function getBridges(uint256 eventId) public view returns (CrossChainBridge[] memory) {
        Event storage eventDetails = events[eventId];
        return eventDetails.bridges;
    }

    function getProposals(uint256 eventId) public view returns (
        string[] memory titles,
        string[] memory descriptions,
        uint256[] memory startTimes,
        uint256[] memory endTimes,
        uint256[] memory forVotes,
        uint256[] memory againstVotes,
        bool[] memory executed
    ) {
        Event storage eventDetails = events[eventId];
        uint256 length = eventDetails.proposals.length;
        
        titles = new string[](length);
        descriptions = new string[](length);
        startTimes = new uint256[](length);
        endTimes = new uint256[](length);
        forVotes = new uint256[](length);
        againstVotes = new uint256[](length);
        executed = new bool[](length);

        for(uint i = 0; i < length; i++) {
            DAOProposal storage proposal = eventDetails.proposals[i];
            titles[i] = proposal.title;
            descriptions[i] = proposal.description;
            startTimes[i] = proposal.startTime;
            endTimes[i] = proposal.endTime;
            forVotes[i] = proposal.forVotes;
            againstVotes[i] = proposal.againstVotes;
            executed[i] = proposal.executed;
        }
    }
} 