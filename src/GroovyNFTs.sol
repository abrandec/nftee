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
    // Max supply can be 4,294,967,295 if using 8 attributes
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
        uint256 newTokenId = ++currentTokenId;

        if (newTokenId > TOTAL_SUPPLY) {
            revert MaxSupply();
        }

        // Already set to zero
        uint256 attributes_ = attributes[newTokenId];

        // Load Attributes
        uint32 a0;
        uint32 a1;
        uint32 a2;
        uint32 a3;
        uint32 a4;
        uint32 a5;
        uint32 a6;
        uint32 a7;

        // Do something with da numbas

        // OR the uint32s to the attribute, starting with attribute a7
        // Pretty much mash together the uint32s into a single uint256
        assembly {
            attributes_ := or(
                    attributes_,
                    a7
            )

            attributes_ := shr(
                32,
                or(
                    attributes_,
                    a6
                )
            )

            attributes_ := shr(
                64,
                or(
                    attributes_,
                    a5
                )
            )

            attributes_ := shr(
                96,
                or(
                    attributes_,
                    a4
                )
            )

            attributes_ := shr(
                128,
                or(
                    attributes_,
                    a3
                )
            )

            attributes_ := shr(
                160,
                or(
                    attributes_,
                    a2
                )
            )

            attributes_ := shr(
                196,
                or(
                    attributes_,
                    a1
                )
            )

            attributes_ := shr(
                224,
                or(
                    attributes_,
                    a0
                )
            )
          
        }

        attributes[newTokenId] = attributes_;
        
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
        // Compacts vv nicely
        uint32 a0;
        uint32 a1;
        uint32 a2;
        uint32 a3;
        uint32 a4;
        uint32 a5;
        uint32 a6;
        uint32 a7;
       
        // will explain later.  Thank you v much Optimism team!
        assembly {
            a0 := and(
                    attributes_,
                    0x00000000000000000000000000000000000000000000000000000000FFFFFFFF
            )

            a1 := shr(
                32,
                and(
                    attributes_,
                    0x000000000000000000000000000000000000000000000000FFFFFFFF00000000)
            )

            a2 := shr(
                64,
                and(
                    attributes_,
                    0x0000000000000000000000000000000000000000FFFFFFFF0000000000000000)
            )

            a3 := shr(
                96,
                and(
                    attributes_,
                    0x00000000000000000000000000000000FFFFFFFF000000000000000000000000)
            )

            a4 := shr(
                124,
                and(
                    attributes_,
                    0x000000000000000000000000FFFFFFFF00000000000000000000000000000000)
            )

            a5 := shr(
                160,
                and(
                    attributes_,
                    0x0000000000000000FFFFFFFF0000000000000000000000000000000000000000)
            )

            a6 := shr(
                192,
                and(
                    attributes_,
                    0x00000000FFFFFFFF000000000000000000000000000000000000000000000000)
            )

            a7 := shr(
                224,
                and(
                    attributes_,
                    0xFFFFFFFF00000000000000000000000000000000000000000000000000000000)
            )
            
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