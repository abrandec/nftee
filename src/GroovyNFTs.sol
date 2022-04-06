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

      
    // will have a diagram on how to reconstruct this
    string baseSVG = "<svg xmlns='http://www.w3.org/2000/svg'>"; // needing that link is kinda bs
    string filter = "<filter id='";
    string f2 = "'><feTurbulence baseFrequency='";
    string f3 = "'/><feColorMatrix values='";
    string f4 = "'></filter>";
    string f5 = "'/><feComponentTransfer><feFuncR type='table' tableValues='0 .02 .03 .03 .09 .12 .27 .91 .3 .03 0 0'/><feFuncG type='table' tableValues='.01 .09 .16 .18 .38 .48 .54 .73 .33 .09 .01 .01'/><feFuncB type='table' tableValues='.03 .17 .3 .25 .37 .42 .42 .6 .17 .01 0 0'/></feComponentTransfer";
    string path = "<rect width='350' height='350' filter='url(#stars)'/><rect width='350' height='350' filter='url(#clouds2)' opacity='.01'/><rect width='350' height='350' filter='url(#clouds)' opacity='.3'/><path id='myPath2' fill='none' stroke-miterlimit='10'd=' M 300 200 A 100 100 0 1 1 300 197'/>";
  
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
        // preload warm slot
        currentTokenId;
        uint256 newTokenId = ++currentTokenId;
        if (newTokenId > TOTAL_SUPPLY) {
            revert MaxSupply();
        }

        // cut attributes[tokenId] into 8 pieces and iterate each piece by 1
        // Once we got this down we can randomize the value (VRF, will be difficult to "throw away" values)
        _safeMint(recipient, newTokenId);
        return newTokenId;
    }


    // Best function to bake a crazy amt of functionality into
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

        uint256 attributes_ = attributes[tokenId];
        uint256 mask = 0xFFFFFFFF00000000000000000000000000000000000000000000000000000000;
        // use casting (eg. uint8 ex = uin8(a); a is a uint256)
        // Time to get shifty
        for (uint256 i = 1; i < 8;) {
            // amount of bits to shift
            uint256 shift = 32 * i;
            // change
            uint256 a0; 
            assembly {
            // set memory pointer (0x40 good mem pt)
            let ptr := mload(0x40)
            mstore(0x40, shr(shift, attributes_))
            // mask off everything after 0xFFFFFFFF
            a0 := and(0x40, mask)
            }
            // Will never overflow unless you're a magician
            unchecked { ++i; }
        }

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