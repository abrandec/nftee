// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.9;

import "solmate/tokens/ERC721.sol";
import "openzeppelin-contracts/contracts/utils/Strings.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";
import "./interfaces/Base64.sol";

error MintPriceNotPaid();
error MaxSupply();
error NonExistentTokenURI();
error WithdrawTransfer();

contract ERCIDK is ERC721, Ownable {
    using Strings for uint256;
    using Strings for uint32;

    string public baseURI;
    uint256 public currentTokenId;
    // Max supply can be 4,294,967,295 if using 8 attributes
    uint256 public constant TOTAL_SUPPLY = 10_000;
    
    mapping(uint256 => uint256) public attributes;

    // Why waste precious gas if we're gonna use this for mult. projects
    Base64 base64;

    constructor(
        string memory _name,
        string memory _symbol,
        Base64 _base64
    ) ERC721(_name, _symbol) {
        base64 = _base64;
    }

    function mintTo(address recipient) public payable returns (uint256) {
        uint256 newTokenId = ++currentTokenId;

        if (newTokenId > TOTAL_SUPPLY) {
            revert MaxSupply();
        }

        // Already set to zero
        uint256 attributes_ = attributes[newTokenId];
        // each attribute + assembly intruction takes 5 gas each
        // Load Attributes
        // Setting a value takes 24 gas
        uint32 a0;
        uint32 a1;
        uint32 a2;
        uint32 a3;
        uint32 a4;
        uint32 a5;
        uint32 a6;
        uint32 a7; 

        // Do something with da numbas right here

        // OR the uint32s to the attribute
        // Pretty much mash together the uint32s into a single uint256
        assembly {
            attributes_ := add(
                attributes_,
                a0
            )

            attributes_ := add(
                attributes_,
                shl(
                    32,
                    a1
                )
            )

            attributes_ := add(
                attributes_,
                shl(
                    64,
                    a2
                )
            )

            attributes_ := add(
                attributes_,
                shl(
                    96,
                    a3
                )
            )

            attributes_ := add(
                attributes_,
                shl(
                    128,
                    a4
                )
            )

            attributes_ := add(
                attributes_,
                shl(
                    160,
                    a5
                )
            )

            attributes_ := add(
                attributes_,
                shl(
                    192,
                    a6
                )
            )

            attributes_ := add(
                attributes_,
                shl(
                    224,
                    a7
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
        // Attributes
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
                128,
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

        string memory finalSvg = string(abi.encodePacked());
     
       string memory json = base64.encode(
           bytes(
               string(
                   abi.encodePacked(
                       '{"name": "',
                    // We set the title of our NFT as the generated word.
                    name,
                    '", "description": "", "image": "data:image/svg+xml;base64,',
                    // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                    base64.encode(bytes(finalSvg)),
                    '"}'
                   )
               )
           )
       );

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

    function transferTo(address to, uint256 id) external {
        address owner = ownerOf[id];
        require (msg.sender != owner, "NOT_THE_OWNER");
        unchecked {
            balanceOf[msg.sender]--;

            balanceOf[to]++;
        }

        emit Transfer(address(msg.sender), to, id);
    }

}