// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.9;

import "solmate/tokens/ERC721.sol";
import "openzeppelin-contracts/contracts/utils/Strings.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";

error MintPriceNotPaid();
error MaxSupply();
error NonExistentTokenURI();
error WithdrawTransfer();

contract GroovyNFTs is ERC721, Ownable {
    using Strings for uint256;
    string public baseURI;
    uint256 public currentTokenId;
    uint256 public constant TOTAL_SUPPLY = 10_000;
    uint256 public constant MINT_PRICE = 0.08 ether;


    mapping(uint256 => uint256) public attributes;

    address public immutable base64Addr;

    constructor(
        string memory _name,
        string memory _symbol,
        address _base64Addr
    ) ERC721(_name, _symbol) {
        base64Addr = _base64Addr;
    }


    function mintTo(address recipient) public payable returns (uint256) {
        // warm slot like I peed my pants
        currentTokenId;
        uint32 trimmedId32 = uint32(currentTokenId);
        uint256 newTokenId = ++currentTokenId;

        if (newTokenId > TOTAL_SUPPLY) {
            revert MaxSupply();
        }


    
        _safeMint(recipient, newTokenId);
        return newTokenId;
    }


    /// CHANGE ALOT
    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        if (ownerOf[tokenId] == address(0)) {
            revert NonExistentTokenURI();
        }

        // removes 14 SSLOADS & SSTORES total
        // I need 0xC0FFEE
        // Bitmask using AND (Mask off)
        // Ignores first 2 bits (C), had to do for padding. We will be shifting the stack in a... bit.
        // This has to change. Stack is too damn deep to declare anything more.  Make it more algorithmic or some shit
        uint256 mask0 = 0x80000000000000000000000000000000000000000000000000000000FFFFFFFF;
        uint256 mask1 = 0x800000000000000000000000000000000000000000000000FFFFFFFF00000000;
        uint256 mask2 = 0x8000000000000000000000000000000000000000FFFFFFFF0000000000000000;
        uint256 mask3 = 0x80000000000000000000000000000000FFFFFFFF000000000000000000000000;
        uint256 mask4 = 0x800000000000000000000000FFFFFFFF00000000000000000000000000000000;
        uint256 mask5 = 0x8000000000000000FFFFFFFF0000000000000000000000000000000000000000;
        uint256 mask6 = 0x80000000FFFFFFFF000000000000000000000000000000000000000000000000;
        uint256 mask7 = 0xFFFFFFFF00000000000000000000000000000000000000000000000000000000;
        //                 ^ Can use 0x80 to give us 7 booleans, setting the max val of attribute #7 to 16,777,215
        // If you wanna be weird you can get 56 free booleans doing this every 25 bits (eg. Every FFFFFFFF -> 80FFFFFF)

        uint256 attributes_ = attributes[tokenId];

        // # from each attribute
        // This is how we get attributes 😭
        uint256 a0 = (attributes_ & mask0) >> 224; // 🎶 To the left 🎶
        uint256 a1 = (attributes_ & mask1) >> 192; // 🎶 Take it back now, ya'll 🎶
        uint256 a2 = (attributes_ & mask2) >> 160; // 🎶 One hop this time 🎶
        uint256 a3 = (attributes_ & mask3) >> 128; // 🎶 Right foot, let's stomp 🎶
        uint256 a4 = (attributes_ & mask4) >> 96;  // 🎶 Left foot, let's stomp 🎶
        uint256 a5 = (attributes_ & mask5) >> 64;  // 🎶 Cha cha real smooth 🎶
        uint256 a6 = (attributes_ & mask6) >> 32;  // 🎶 Turn it out 🎶
        uint256 a7 = attributes_ & mask7;          // 🎶 To the left 🎶

        // Already got a stack too deep below
      /*   return
            bytes(baseURI).length > 0
                ? string(abi.encodePacked(baseURI, tokenId.toString()))
                : ""; */
    }

    // free tokens!
    function withdrawPayments(address payable payee) external onlyOwner {
        uint256 balance = address(this).balance;
        (bool transferTx, ) = payee.call{value: balance}("");
        if (!transferTx) {
            revert WithdrawTransfer();
        }
    }
}