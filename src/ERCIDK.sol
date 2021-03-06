// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.9;

import "solmate/tokens/ERC721.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";
import "./interfaces/Base64.sol";
import "./ToHex.sol";

error MintPriceNotPaid();
error MaxSupply();
error NonExistentTokenURI();
error WithdrawTransfer();
error NotTheOwner();

error NotAWassie();
error CreatureNotSick();
error CreatureDead();

contract ERCIDK is ERC721, Ownable {
   using ToHex for uint24;

    string public baseURI;
    uint256 public currentTokenId;
    // Max supply can be 4,294,967,295 if using 8 attributes
    uint256 public constant TOTAL_SUPPLY = 10_000;

    mapping(uint256 => stuff) public itemInfo;
    struct stuff {
        uint256 attributes;
        uint256 timestamps1;
        uint256 timestamps2; 
    }

    // External contract
    Base64 base64;
    uint256 public attribute = 0x00000000000000000000009A6BA05F20670000FF00FF00FFFF00FFA5000000FF;
  
    struct svg {
        string[] svgpiece;
    }
  
  svg Svg;
    constructor(
        string memory _name,
        string memory _symbol,
        Base64 _base64
    ) ERC721(_name, _symbol) {
        base64 = _base64;
        // Base
        Svg.svgpiece.push("<svg id='e62pqUTbDzL1' xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' preserveAspectRatio='xMinYMin meet' viewBox='0 0 752 752' shape-rendering='geometricPrecision' text-rendering='geometricPrecision'><rect width='100%' height='100%' fill='#");
        Svg.svgpiece.push("'/><defs><linearGradient id='eVODCoWg0yt3-stroke' x1='0' y1='0.5' x2='1' y2='0.5' spreadMethod='pad' gradientUnits='objectBoundingBox' gradientTransform='translate(0 0)'><stop id='eVODCoWg0yt3-stroke-0' offset='0%' stop-color='#000'/><stop id='eVODCoWg0yt3-stroke-1' offset='100%' stop-color='#000'/></linearGradient><linearGradient id='eVODCoWg0yt4-stroke' x1='0' y1='0.5' x2='1' y2='0.5' spreadMethod='pad' gradientUnits='objectBoundingBox' gradientTransform='translate(0 0)'><stop id='eVODCoWg0yt4-stroke-0' offset='0%' stop-color='#000'/><stop id='eVODCoWg0yt4-stroke-1' offset='100%' stop-color='#000'/></linearGradient></defs><g transform='matrix(1.104727 0 0 1.104727-39.388418-39.321042)'><path d='M377.52,598.96c-54.746,0-101.06-16.008-134.02-46.223-37.316-34.289-56.262-84.77-56.262-150.03c0-66.301,19.418-128.81,54.652-175.89c35.707-47.641,83.352-73.879,134.12-73.879c50.77,0,98.41,26.238,134.12,73.879c35.234,47.074,54.652,109.49,54.652,175.89c0,65.449-18.375,115.93-54.652,150.03-32.199,30.309-78.043,46.223-132.6,46.223Zm-1.546786-196.066c-96.23,0,0-130.047,0-.187c0,61.188-32.644213-31.539997,1.546787.000003c30.215,27.75-52.655-.000003-1.51-.000003c50.863,0-29.489787,27.846999-.036787.186999c33.34-31.258,1.546786,61.091001,1.546786-.186999c0-130.04,94.726001,0-1.509999,0Z' transform='matrix(1.491829 0 0 1.491829-184.932612-184.902631)' fill='#");
        Svg.svgpiece.push("'/><stop offset='0.5' stop-color='#");
  
        Svg.svgpiece.push("<g transform='translate(.195126 64.3177)'><rect width='60' height='15' rx='0' ry='0' transform='translate(346 450.132)' fill='#59584f' stroke-width='0'/><rect width='60' height='15' rx='0' ry='0' transform='translate(346.562 225.132)' fill='#59584f' stroke-width='0'/><rect width='30' height='15' rx='0' ry='0' transform='translate(315.317 435.132)' fill='#59584f' stroke-width='0'/><rect width='30' height='15' rx='0' ry='0' transform='translate(406 435.132)' fill='#59584f' stroke-width='0'/><rect width='15' height='15' rx='0' ry='0' transform='translate(300.317 420.132)' fill='#59584f' stroke-width='0'/><rect width='15' height='15' rx='0' ry='0' transform='translate(315.317 255.132)' fill='#59584f' stroke-width='0'/><rect width='15' height='15' rx='0' ry='0' transform='translate(330.317 240.132)' fill='#59584f' stroke-width='0'/><rect width='15' height='15' rx='0' ry='0' transform='translate(421 255.132)' fill='#59584f' stroke-width='0'/><rect width='15' height='15' rx='0' ry='0' transform='translate(406.562 240.132)' fill='#59584f' stroke-width='0'/><rect width='15' height='15' rx='0' ry='0' transform='translate(436.295 420.132)' fill='#59584f' stroke-width='0'/><rect width='15' height='30' rx='0' ry='0' transform='translate(451.295 390.132)' fill='#59584f' stroke-width='0'/><rect width='15' height='30' rx='0' ry='0' transform='translate(285.317 390.132)' fill='#59584f' stroke-width='0'/><rect width='15' height='30' rx='0' ry='0' transform='translate(285.317 300.132)' fill='#59584f' stroke-width='0'/><rect width='15' height='30' rx='0' ry='0' transform='translate(451.295 300.132)' fill='#59584f' stroke-width='0'/><rect width='15' height='30' rx='0' ry='0' transform='translate(436.295 270.132)' fill='#59584f' stroke-width='0'/><rect width='15' height='30' rx='0' ry='0' transform='translate(300.317 270.132)' fill='#59584f' stroke-width='0'/><rect width='15' height='60' rx='0' ry='0' transform='translate(466.295 330.132)' fill='#59584f' stroke-width='0'/><rect width='15' height='60' rx='0' ry='0' transform='translate(270.317 330.132)' fill='#59584f' stroke-width='0'/><g transform='translate(.294575-.000025)'><rect width='30' height='45' rx='0' ry='0' transform='translate(391 255.132)' fill='rgba(89,88,79,0.4)' stroke-width='0'/><rect width='15' height='15' rx='0' ry='0' transform='translate(406 300.132)' fill='rgba(89,88,79,0.4)' stroke-width='0'/><rect width='15' height='45' rx='0' ry='0' transform='translate(421 270.132)' fill='rgba(89,88,79,0.4)' stroke-width='0'/><rect width='30' height='45' rx='0' ry='0' transform='translate(315.022 270.132)' fill='rgba(89,88,79,0.4)' stroke-width='0'/><rect width='30' height='30' rx='0' ry='0' transform='translate(285.022 360.132)' fill='rgba(89,88,79,0.4)' stroke-width='0'/><rect width='30' height='30' rx='0' ry='0' transform='translate(421.268 390.132)' fill='rgba(89,88,79,0.4)' stroke-width='0'/><rect width='30' height='15' rx='0' ry='0' transform='translate(435.705 375.132)' fill='rgba(89,88,79,0.4)' stroke-width='0'/><rect width='30' height='30' rx='0' ry='0' transform='translate(300.022 390.132)' fill='rgba(89,88,79,0.4)' stroke-width='0'/><rect width='15' height='15' rx='0' ry='0' transform='translate(315.022 375.132)' fill='rgba(89,88,79,0.4)' stroke-width='0'/><rect width='15' height='30' rx='0' ry='0' transform='translate(300.022 300.132)' fill='rgba(89,88,79,0.4)' stroke-width='0'/><rect width='15' height='15' rx='0' ry='0' transform='translate(315.022 315.132)' fill='rgba(89,88,79,0.4)' stroke-width='0'/><rect width='45' height='45' rx='0' ry='0' transform='translate(353.768 352.632)' fill='rgba(89,88,79,0.4)' stroke-width='0'/><rect width='45' height='15' rx='0' ry='0' transform='translate(353.768 337.632)' fill='rgba(89,88,79,0.4)' stroke-width='0'/><rect width='45' height='15' rx='0' ry='0' transform='translate(353.768 397.632)' fill='rgba(89,88,79,0.4)' stroke-width='0'/><rect width='15' height='45' rx='0' ry='0' transform='translate(398.768 352.632)' fill='rgba(89,88,79,0.4)' stroke-width='0'/><rect width='15' height='45' rx='0' ry='0' transform='translate(338.768 352.632)' fill='rgba(89,88,79,0.4)' stroke-width='0'/></g></g>");
        // Rainbow url(#pattern)
        Svg.svgpiece.push("<defs><linearGradient id='gradient' x1='100%' y1='0%' x2='0%' y2='0%'><stop offset='6.25%' style='stop-color:#87FFFE;'/><stop offset='18.75%' style='stop-color:#88FF89;'/><stop offset='31.25%' style='stop-color:#F8F58A;'/><stop offset='43.75%' style='stop-color:#EF696A;'/><stop offset='56.25%' style='stop-color:#F36ABA;'/><stop offset='68.75%' style='stop-color:#EF696A;'/><stop offset='81.25%' style='stop-color:#F8F58A;'/><stop offset='93.75%' style='stop-color:#88FF89;'/><stop offset='100%' style='stop-color:#87FFFE;'/></linearGradient></defs><pattern id='pattern' x='0' y='0' width='400%' height='100%' patternUnits='userSpaceOnUse'><rect x='-150%' y='0' width='200%' height='100%' fill='url(#gradient)' transform='rotate(-65)'><animate attributeType='XML'attributeName='x'from='-150%' to='50%'dur='20s'repeatCount='indefinite'/></rect><rect x='-350%' y='0' width='200%' height='100%' fill='url(#gradient)' transform='rotate(-65)'><animate attributeType='XML'attributeName='x'from='-350%' to='-150%'dur='20s'repeatCount='indefinite'/></rect></pattern>");
        Svg.svgpiece.push("'/></linearGradient></defs><rect width='100%' height='100%' fill='url(#r)'/></svg>");
  
    }

    function mintTo(address recipient) public payable returns (uint256) {
        uint256 newTokenId = ++currentTokenId;

        if (newTokenId > TOTAL_SUPPLY) {
            revert MaxSupply();
        }

        // Already set to zero
        uint256 attributes_ = itemInfo[newTokenId].attributes;
        uint256 timestamps1_ = itemInfo[newTokenId].timestamps1;
        // Load Attributes
        // something something stack frame if stack too deep
        uint24 a0 = 1;
        uint24 a1 = 1;
        uint24 a2 = 1;
        uint24 a3 = 1;
        uint24 a4 = 1;
        uint24 a5 = 1;
        uint24 a6 = 1;
        uint24 a7 = 1;
        uint24 a8 = 1;
        uint24 a9 = 1;
        // Do something with da numbas right here

        // 2^128 - 1 max size if double packing 2 block.timestamps into 1 uint256
        // ~8760 hours in a year
        // ~300 blocks an hour (12 sec blocks)
        // 300 * 8760 = 2,628,000 blocks in year
        // ~3.4028237e+38 years (even if we deviate our estimate by 99% we won't have any issues (very portable to other EVMs!)) 
        // Only way we can overflow is with serious time-travel
        
        
        assembly {
        attributes_ := add(attributes_, a0)
        attributes_ := add(attributes_, shl(24, a1))
        attributes_ := add(attributes_, shl(48, a2))
        attributes_ := add(attributes_, shl(72, a3))
        attributes_ := add(attributes_, shl(96, a4))
        attributes_ := add(attributes_, shl(120, a5))
        attributes_ := add(attributes_, shl(144, a6))
        attributes_ := add(attributes_, shl(168, a7))
        attributes_ := add(attributes_, shl(192, a8))
        attributes_ := add(attributes_, shl(216, a9))
        }

        itemInfo[newTokenId].attributes = attributes_;

        _safeMint(recipient, newTokenId);
        return newTokenId;
    }

    // Best function to bake a crazy amt of functionality into
    // Won't increase gas for minters since it's a hardcoded view func
    function tokenURI(uint256 tokenId)
        public
        virtual
        override
        returns (string memory)
    {
        if (ownerOf[tokenId] == address(0)) {
            revert NonExistentTokenURI();
        }

    string memory colors1 = colors_1(tokenId);
    string memory colors2 = colors_2(tokenId);
    
    
    string memory finalSvg = string(abi.encodePacked(
       colors1,
       colors2
        ));

        string memory json = base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        // Use name of NFT
                        name,
                        '", "description": "", "image": "data:image/svg+xml;base64,',
                        // Add data:image/svg+xml;base64 and then append our base64 encode our svg.
                        base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

        return bytes(baseURI).length > 0 ? json : "";
    }

    // need to confirm if this saves gas
    function prepayGas(uint256 end) external {
        if (end > TOTAL_SUPPLY) revert MaxSupply();

        for (uint256 i = currentTokenId; i < end; ) {
            bytes32 slotValue;

            assembly {
                slotValue := sload(add(ownerOf.slot, i))
            }
            // What the fuck.  Credit <https://github.com/DonkeVerse/ERC1155D>
            bytes32 leftmostBitSetToOne = slotValue |
                bytes32(uint256(1) >> 255); // had to do it in reverse
            assembly {
                sstore(add(ownerOf.slot, i), leftmostBitSetToOne)
            }
            unchecked {
                ++i;
            }
        }
    }

    // Transfer from message sender to receiver address
    function _transfer(address to, uint256 id) external {
        // Underflow of the sender's balance is impossible because we check for
        // ownership above and the recipient's balance can't realistically overflow.
        unchecked {
            --balanceOf[msg.sender];

            ++balanceOf[to];
        }

        ownerOf[id] = to;

        emit Transfer(address(msg.sender), to, id);
    }

    /// READ FUNCTIONS ///

    function colors_1(uint256 tokenId) internal returns (string memory) {
        uint256 attributes_ = itemInfo[tokenId].attributes;
    
        // attributes
        uint24 a0;
        uint24 a1;
        uint24 a2;
        uint24 a3;

        string memory partialSvg;
        // Thank you v much Optimism team!
        assembly {
            a0 := and(
                    attributes_,
                    0x0000000000000000000000000000000000000000000000000000000000FFFFFF
                  
            )

            a1 := shr(
                24,
                and(
                    attributes_,
                    0x0000000000000000000000000000000000000000000000000000FFFFFF000000)
            )

            a2 := shr(
                48,
                and(
                    attributes_,
                    0x0000000000000000000000000000000000000000000000FFFFFF000000000000)
            ) 

            a3 := shr(
                72,
                and(
                    attributes_,
                    0x0000000000000000000000000000000000000000FFFFFF000000000000000000)
            )       

    }

    return  partialSvg = string(abi.encodePacked(
        Svg.svgpiece[0],
        a0.uint24tohexstr(),
        Svg.svgpiece[1],
        a1.uint24tohexstr(),
        Svg.svgpiece[2],
        a2.uint24tohexstr(),
        Svg.svgpiece[3],
        a3.uint24tohexstr(),
        Svg.svgpiece[5]
          
    ));
    }

     function colors_2(uint256 tokenId) internal returns (string memory) {
        uint256 attributes_ = itemInfo[tokenId].attributes;
    
        // attributes
        uint24 a4;
        uint24 a5;
        uint24 a6;
        uint24 a7;

        string memory partialSvg;
        // Thank you v much Optimism team!
        assembly {
           
            a4 := shr(
                96,
                and(
                    attributes_,
                    0x0000000000000000000000000000000000FFFFFF000000000000000000000000)
            )

            a5 := shr(
                120,
                and(
                    attributes_,
                    0x000000000000000000000000000FFFFFF0000000000000000000000000000000)
            ) 

            a6 := shr(
                144,
                and(
                    attributes_,
                    0x000000000000000000000FFFFFF0000000000000000000000000000000000000)
            ) 

            a7 := shr(
                168,
                and(
                    attributes_,
                    0x000000000000000FFFFFF0000000000000000000000000000000000000000000)
            )       
    }

    return  partialSvg = string(abi.encodePacked(
        Svg.svgpiece[0],
        a4.uint24tohexstr(),
        Svg.svgpiece[1],
        a5.uint24tohexstr(),
        Svg.svgpiece[2],
        a6.uint24tohexstr(),
        Svg.svgpiece[3],
        a7.uint24tohexstr(),
        Svg.svgpiece[5]  
    ));
    }

    function Creature(uint256 tokenId) internal returns (string memory) {
        uint256 attributes_ = itemInfo[tokenId].attributes;

        uint8 creature;

        assembly {
            creature := shr(
                208,
                and(
                    attributes_,
                    0x0000000000FF0000000000000000000000000000000000000000000000000000)
            )
        }



    }

    // Percentage based things (health, happiness, etc)
    function Percentages(uint256 tokenId) internal returns (string memory) {
        uint256 attributes_ = itemInfo[tokenId].attributes;
    
        // attributes
        uint8 health;
        uint8 hunger;
        uint8 happiness;
        uint8 energy;

        string memory partialSvg;
        // Thank you v much Optimism team!
        assembly {
            health := shr(
                216,
                and(
                    attributes_,
                    0x00000000FF000000000000000000000000000000000000000000000000000000)
            )

            hunger := shr(
                224,
                and(
                    attributes_,
                    0x000000FF00000000000000000000000000000000000000000000000000000000)
            )

            happiness := shr(
                232,
                and(
                    attributes_,
                    0x0000FF0000000000000000000000000000000000000000000000000000000000)
            )       
 
            energy := shr(
                240,
                and(
                    attributes_,
                    0x00FF000000000000000000000000000000000000000000000000000000000000)
            )
    }

    
    }

    function readBooleans(uint256 tokenId) internal returns (bool, bool, bool, bool) {
        uint256 attributes_ = itemInfo[tokenId].attributes;
        bool isEgg; 
        bool isSick; 
        bool isDead; // whats the point if health == 0 means pet ded
        bool isFrozen;

        assembly {
            isEgg := shr(
                252,
                and(
                    attributes_,
                    0x100000000000000000000000000000000000000000000000000000000000000)
            )

            isSick := shr(
                253,
                and(
                    attributes_,
                    0x200000000000000000000000000000000000000000000000000000000000000)
            )
        
            isDead := shr(
                254,
                and(
                    attributes_,
                    0x400000000000000000000000000000000000000000000000000000000000000)
            )
        
            isFrozen := shr(
                255,
                and(
                    attributes_,
                    0x800000000000000000000000000000000000000000000000000000000000000)
            )
        }

        return (isEgg, isSick, isDead, isFrozen);
    }


    // add last time given medicine timestamp.  timestamps in timestamp2_ 85 bits each
    // takes ~3.8685626e+25 years to to read max value for 2^85-1 with blocks mined every 12 sec
    
    function readTimestamps(uint256 tokenId) internal returns (string memory) {
        uint256 timestamps1_ = itemInfo[tokenId].timestamps1;
        uint256 timestamps2_ = itemInfo[tokenId].timestamps2;
        
        uint128 happinessTimestamp;
        uint128 sickTimestamp;

        uint128 medicineTimestamp;
        uint128 hungerTimestamp;
        uint128 birthdayTimestamp;
        

        assembly {
            happinessTimestamp := and(
                    timestamps1_,
                    0x00000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF  
            )

            sickTimestamp := shr(
                128,
                and(
                    timestamps1_,
                    0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000
                )
            )

            medicineTimestamp := and(
                timestamps2_,
                0x0000000000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFF
            )

            sickTimestamp := shr(
                84,
                and(
                    timestamps2_,
                    0x0000000000000000000000FFFFFFFFFFFFFFFFFFFFF000000000000000000000
                )
            )

            birthdayTimestamp := shr(
                168,
                and(
                    timestamps2_,
                    0x0FFFFFFFFFFFFFFFFFFFFF000000000000000000000000000000000000000000
                )
            )
        }
    }

    /// READ FUNCTIONS
    function readPercentages(uint256 tokenId) internal returns (uint8, uint8, uint8, uint8) {
        uint256 attributes_ = itemInfo[tokenId].attributes;
    
        // attributes
        uint8 health;
        uint8 hunger;
        uint8 happiness;
        uint8 energy;

        // Thank you v much Optimism team!
        assembly {
            health := shr(
                216,
                and(
                    attributes_,
                    0x00000000FF000000000000000000000000000000000000000000000000000000)
            )

            hunger := shr(
                224,
                and(
                    attributes_,
                    0x000000FF00000000000000000000000000000000000000000000000000000000)
            )

            happiness := shr(
                232,
                and(
                    attributes_,
                    0x0000FF0000000000000000000000000000000000000000000000000000000000)
            )       
 
            energy := shr(
                240,
                and(
                    attributes_,
                    0x00FF000000000000000000000000000000000000000000000000000000000000)
            )
        }

        return (health, hunger, happiness, energy);

    }

    // VIEW FUNCTIONS


    // Interactions

    function petCreature(uint256 tokenId) external {
        if (msg.sender != ownerOf[tokenId]) revert NotTheOwner();
        uint256 timestamps1_ = itemInfo[tokenId].timestamps1;
        uint256 attributes_ = itemInfo[tokenId].attributes;
        
    }

    function giveMedicine(uint256 tokenId) external {
        if (msg.sender != ownerOf[tokenId]) revert NotTheOwner();
        uint256 attributes_ = itemInfo[tokenId].attributes;
        bool isSick;

        assembly {
             isSick := shr(
                253,
                and(
                    attributes_,
                    0x200000000000000000000000000000000000000000000000000000000000000)
            )
        }

        uint256 timestamps2_ = itemInfo[tokenId].timestamps2;
        uint128 medicineTimestamp;

        assembly {

        }


        if (isSick = false) revert CreatureNotSick(); 

        uint8 health;
        uint8 hunger;
        uint8 happiness;
        uint8 energy;

        (health, hunger, happiness, energy) = readPercentages(tokenId);

        // decay uint8 values
        health = decay(health, medicineTimestamp, 10);
       
        health + 10;
        happiness + 10;
        energy + 5;

        if (health > 100) {
            health = 100;
        }

        if (happiness > 100) {
            happiness = 100;
        }

        // energy check idk

    }
    

    function giveFood(uint256 tokenId) external {
        if (msg.sender != ownerOf[tokenId]) revert NotTheOwner();

    }

    function freezeCreature(uint256 tokenId) external {
        if (msg.sender != ownerOf[tokenId]) revert NotTheOwner();
        uint256 attributes_ = itemInfo[tokenId].attributes;
        // you can freeze a dead creature irl, so no checks on isDead

        assembly {
                attributes_ := add(attributes_, shl(255, 8))
        }

        itemInfo[tokenId].attributes = attributes_;
    }

    function unfreezeCreature(uint256 tokenId) external {
        if (msg.sender != ownerOf[tokenId]) revert NotTheOwner();
        uint256 attributes_ = itemInfo[tokenId].attributes;
        // you can freeze a dead creature irl, so no checks on isDead

        assembly {
            attributes_ := sub(attributes_, shl(255, 8))
        }
        itemInfo[tokenId].attributes = attributes_;
    }

    function killWassie(uint256 tokenId) external {
        if (msg.sender != ownerOf[tokenId]) revert NotTheOwner();
        uint256 attributes_ = itemInfo[tokenId].attributes;
        uint8 creature;

        assembly {
            creature := shr(
                208,
                and(
                    attributes_,
                    0x0000000000FF0000000000000000000000000000000000000000000000000000)
            )
        }

        if (creature != 69) revert NotAWassie();
        // wassie check
    }


    function decay(uint8 value, uint128 _timestamp, uint256 factor) internal returns (uint8) {
        // block.timestamp - _timestamp = diff then do something w factor 
        // return value after decaying it
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
