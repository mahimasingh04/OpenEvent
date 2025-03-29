import { expect } from "chai";
import { ethers } from "hardhat";
import { EventContract } from "../typechain-types";
import { HardhatEthersSigner } from "@nomicfoundation/hardhat-ethers/signers";

describe("EventContract", function () {
  let eventContract: EventContract;
  let owner: HardhatEthersSigner;
  let organizer: HardhatEthersSigner;
  let attendee: HardhatEthersSigner;
  let attendee2: HardhatEthersSigner;
  let eventId: number;
  let tokenId: number;

  const TICKET_METADATA_URI = "ipfs://QmTest";
  const EVENT_METADATA_URI = "ipfs://QmEvent";

  beforeEach(async function () {
    [owner, organizer, attendee, attendee2] = await ethers.getSigners();
    const EventContract = await ethers.getContractFactory("EventContract");
    eventContract = await EventContract.deploy();
    await eventContract.waitForDeployment();

    // Create a test event
    const now = Math.floor(Date.now() / 1000);
    const startDate = now + 86400; // 24 hours from now
    const endDate = startDate + 86400; // 48 hours from now

    const tx = await eventContract.connect(organizer).createEvent(
      "Test Event",
      "Test Description",
      startDate,
      endDate,
      "Test Location",
      ethers.parseEther("0.1"), // 0.1 ETH
      100,
      EVENT_METADATA_URI,
      TICKET_METADATA_URI
    );

    const receipt = await tx.wait();
    const eventCreatedEvent = receipt?.logs[0] as any;
    eventId = eventCreatedEvent.args.eventId;
  });

  describe("Event Creation", function () {
    it("should create an event successfully", async function () {
      const event = await eventContract.getEvent(eventId);
      expect(event.name).to.equal("Test Event");
      expect(event.organizer).to.equal(organizer.address);
      expect(event.isActive).to.be.true;
      expect(event.ticketMetadataURI).to.equal(TICKET_METADATA_URI);
    });

    it("should not allow creating event with past start date", async function () {
      const now = Math.floor(Date.now() / 1000);
      await expect(
        eventContract.connect(organizer).createEvent(
          "Past Event",
          "Test Description",
          now - 86400,
          now + 86400,
          "Test Location",
          ethers.parseEther("0.1"),
          100,
          EVENT_METADATA_URI,
          TICKET_METADATA_URI
        )
      ).to.be.revertedWithCustomError(eventContract, "StartDateInPast");
    });
  });

  describe("Ticket Purchase", function () {
    it("should mint NFT ticket on purchase", async function () {
      await expect(
        eventContract.connect(attendee).purchaseTicket(eventId, {
          value: ethers.parseEther("0.1"),
        })
      ).to.emit(eventContract, "TicketPurchased");

      const tokenId = await eventContract.eventTickets(eventId);
      expect(await eventContract.ownerOf(tokenId)).to.equal(attendee.address);
      expect(await eventContract.tokenURI(tokenId)).to.equal(TICKET_METADATA_URI);
    });

    it("should not allow purchasing with insufficient payment", async function () {
      await expect(
        eventContract.connect(attendee).purchaseTicket(eventId, {
          value: ethers.parseEther("0.05"),
        })
      ).to.be.revertedWithCustomError(eventContract, "InsufficientPayment");
    });

    it("should track event-ticket relationship", async function () {
      await eventContract.connect(attendee).purchaseTicket(eventId, {
        value: ethers.parseEther("0.1"),
      });

      const tokenId = await eventContract.eventTickets(eventId);
      expect(await eventContract.ticketEvents(tokenId)).to.equal(eventId);
    });
  });

  describe("Ticket Transfer", function () {
    beforeEach(async function () {
      await eventContract.connect(attendee).purchaseTicket(eventId, {
        value: ethers.parseEther("0.1"),
      });
      tokenId = await eventContract.eventTickets(eventId);
    });

    it("should allow ticket transfer", async function () {
      await expect(
        eventContract.connect(attendee).transferTicket(tokenId, attendee2.address)
      ).to.emit(eventContract, "TicketTransferred");

      expect(await eventContract.ownerOf(tokenId)).to.equal(attendee2.address);
    });

    it("should not allow transfer before event starts", async function () {
      const now = Math.floor(Date.now() / 1000);
      const event = await eventContract.getEvent(eventId);
      
      // Set event start date to future
      await ethers.provider.send("evm_setTime", [event.startDate - 1]);
      
      await expect(
        eventContract.connect(attendee).transferTicket(tokenId, attendee2.address)
      ).to.be.revertedWithCustomError(eventContract, "EventNotStarted");
    });

    it("should not allow transfer after event ends", async function () {
      const now = Math.floor(Date.now() / 1000);
      const event = await eventContract.getEvent(eventId);
      
      // Set current time after event end
      await ethers.provider.send("evm_setTime", [event.endDate + 1]);
      
      await expect(
        eventContract.connect(attendee).transferTicket(tokenId, attendee2.address)
      ).to.be.revertedWithCustomError(eventContract, "EventEnded");
    });

    it("should not allow transfer by non-owner", async function () {
      await expect(
        eventContract.connect(attendee2).transferTicket(tokenId, attendee2.address)
      ).to.be.revertedWith("Not ticket owner or approved");
    });
  });

  describe("Event Management", function () {
    it("should allow organizer to cancel event", async function () {
      await expect(eventContract.connect(organizer).cancelEvent(eventId))
        .to.emit(eventContract, "EventCancelled");

      const event = await eventContract.getEvent(eventId);
      expect(event.isActive).to.be.false;
    });

    it("should not allow non-organizer to cancel event", async function () {
      await expect(
        eventContract.connect(attendee).cancelEvent(eventId)
      ).to.be.revertedWithCustomError(eventContract, "NotOrganizer");
    });

    it("should return organizer's events", async function () {
      const organizerEvents = await eventContract.getOrganizerEvents(organizer.address);
      expect(organizerEvents).to.include(eventId);
    });
  });

  describe("Fund Management", function () {
    beforeEach(async function () {
      await eventContract.connect(attendee).purchaseTicket(eventId, {
        value: ethers.parseEther("0.1"),
      });
    });

    it("should allow owner to withdraw funds", async function () {
      const balance = await ethers.provider.getBalance(await eventContract.getAddress());
      expect(balance).to.be.gt(0);

      await expect(eventContract.connect(owner).withdrawFunds())
        .to.changeEtherBalance(owner, balance);
    });

    it("should not allow non-owner to withdraw funds", async function () {
      await expect(
        eventContract.connect(attendee).withdrawFunds()
      ).to.be.revertedWith("Ownable: caller is not the owner");
    });
  });
}); 