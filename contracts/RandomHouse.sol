//SPDX-License-Modifier: MIT
pragma solidity ^0.8.8;
import "./HogwartsNFT.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

contract RandomHouse is VRFConsumerBaseV2 {
    HogwartsNFT public nftContract;
    VRFCoordinatorV2Interface public i_vrfCoordinator;
    uint64 private i_subscriptionId;
    bytes32 private i_keyHash;
    uint32 private i_callbackGasLimit;
    mapping(uint256 => address) private s_requestIdToSender;
    mapping(address => string) private s_nameToSender;

    event NftRequested(uint256 indexed requestId, address requester);

    cosntructor(address nftContract, address VRFCoordinatorV2Address, uint64 subId, bytes32 keyHash, uint32 callbackGasLimit){
        nftContract = HogwartsNFT(_nftContract);
        i_vrfCoordinator = VRFCoordinatorV2Interface(VRFCoordinatorV2Address);
        i_subscriptionid = subId;
        i_keyHash = keyHash;
        i_callbackGasLimit = callbackGasLimit;
    }

    function requestNFT(string memory name) public {
        uint256 requestId = i_vrfCoordinator.requestTandomWords(
            i_keyHash,
            i_subscriptionId,
            3,
            i_callbackGasLimit,
            1
        );

        s_requestIdToSender[requestId] = msg.sender;
        s_nameToSender[msg.sender] = name;
        emit NftRequested(requestId, msg.sender);
    }

    function fulfullRandomWords(uint256 requestId, uint256[] memory randomWords) internal override{
        address nftOwner = s_requestIdToSender[requestId];
        string memory name = s_nameToSender[nftOwner];
        uint256 house = randomWords[0] % 4;
        nftContract.mintNft(nftOwner, house, name);
    }
}