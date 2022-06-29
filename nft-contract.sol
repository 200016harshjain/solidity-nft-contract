pragma solidity ^0.6.6;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.4/contracts/token/ERC721/ERC721.sol";


contract sampleNFT is ERC721 {
  
    uint public tokenCounter;
    uint public mintAmount = 1 ether;

    struct NFTData {
        uint firstRandomNumber;
        uint secondRandomNumber;
    }

    NFTData[] public nftData;

    mapping(bytes32 => address) requestIdToSender;
    mapping(bytes32 => uint) requestIdToTokenId;
    

    constructor() public ERC721("dummy", "dum") {
        tokenCounter = 0;
    }

  

    function mintNFT() public payable returns(uint) {

        require(msg.value >= mintAmount);
    
        uint256 _newtokenId = tokenCounter;
        //create NFT "random data" (having issues with chainlink, will try again later)
        NFTData memory nftdata;
        nftdata.firstRandomNumber = random();
        nftdata.secondRandomNumber = uint(keccak256(abi.encodePacked(block.difficulty, now, random()))) % 100;
        //second and first will be same number as block difficulty and block time don't change -> that's why do this
        nftData.push(nftdata);

        _safeMint(msg.sender, _newtokenId);

       // _setTokenURI(_newtokenId, tokenURI);

        tokenCounter++;
        return tokenCounter;
    }

    function viewnftData(uint tokenId) public view returns (uint,uint) {
        return  (  nftData[tokenId].firstRandomNumber, nftData[tokenId].secondRandomNumber );
    }

    

    function burnNFT(uint tokenId) public {
        
        _burn(tokenId);
        // I don't think we should do tokencounter-- 


      
    }
    function accountBalance() public view returns(uint ) {
        return address(this).balance;
    }

    function random() private view returns (uint) {
    uint randomHash = uint(keccak256(abi.encodePacked(block.difficulty, now)));
    return randomHash % 100;
} 

}
