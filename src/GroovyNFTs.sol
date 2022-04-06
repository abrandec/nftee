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

    // Why waste precious gas if we're gonna use this for mult. projects
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
    // Won't increase gas for minters since it's a hardcoded view func
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

        // warm load attibutes of tokenID
        uint256 attributes_ = attributes[tokenId];
        // Attributes split up into an array
        bytes4[] memory attributesDisplay = new bytes4[](7);
        // Time to get shifty
        for (uint256 i = 1; i < 8;) {
            // amount of bits to shift
            uint256 shift = 32 * i;

            assembly {
            // mstore result to element in array (loading 32 * i bits at a time).
            // To get the result, we shift attributes 32 * i bits to the left.  
            // Nice thing is downcasting to a bytes4 is it already masks off the last 28 bytes
            mstore(mload(add(attributesDisplay, shift)), shl(shift, attributes_))
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