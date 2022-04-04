// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.4;

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

    constructor(
        string memory _name,
        string memory _symbol
    ) ERC721(_name, _symbol) {
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

        // reduces 8 SSLOADs & 8 SSTOREs
        // I need 0xC0FFEE
        // Bitmask using AND (Mask off)
        // Ignores first 2 bits (C), had to do for padding. We will be shifting the stack in a... bit.
        uint256 mask0 = 0xC0000000000000000000000000000000000000000000000000000000FFFFFFFF;
        uint256 mask1 = 0xC00000000000000000000000000000000000000000000000FFFFFFFF00000000;
        uint256 mask2 = 0xC000000000000000000000000000000000000000FFFFFFFF0000000000000000;
        uint256 mask3 = 0xC0000000000000000000000000000000FFFFFFFF000000000000000000000000;
        uint256 mask4 = 0xC00000000000000000000000FFFFFFFF00000000000000000000000000000000;
        uint256 mask5 = 0xC000000000000000FFFFFFFF0000000000000000000000000000000000000000;
        uint256 mask6 = 0xC0000000FFFFFFFF000000000000000000000000000000000000000000000000;
        uint256 mask7 = 0x80FFFFFF00000000000000000000000000000000000000000000000000000000;
        //                 ^ 0x80 gives us 7 booleans, max val of attribute #7 to 16,777,215
        // If you wanna be weird you can get 56 free booleans doing this every 32 bits

        return
            bytes(baseURI).length > 0
                ? string(abi.encodePacked(baseURI, tokenId.toString()))
                : "";
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