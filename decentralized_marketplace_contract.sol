// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.23;

contract DecentralizedMarketplace {
    struct Item {
        uint256 id;
        string name;
        uint256 price;
        address seller;
        bool isSold;
    }

    mapping(uint256 => Item) public items;

    uint256 public itemCount;

    mapping(uint256 => address) public itemOwners;

    event ItemListed(
        uint256 indexed itemId,
        string name,
        uint256 price,
        address indexed seller
    );
    event ItemPurchased(uint256 indexed itemId, address indexed buyer);
    event FundsWithdrawn(address indexed seller, uint256 amount);

    constructor() {
        itemCount = 0;
    }

    function listNewItem(string memory _name, uint256 _price) public {
        itemCount++;
        items[itemCount] = Item(itemCount, _name, _price, msg.sender, false);
        itemOwners[itemCount] = msg.sender;
        emit ItemListed(itemCount, _name, _price, msg.sender);
    }

    function purchaseItem(uint256 _itemId) public payable {
        require(_itemId > 0 && _itemId <= itemCount, "Invalid item ID.");
        Item storage item = items[_itemId];
        require(!item.isSold, "Item already sold.");
        require(msg.value == item.price, "Incorrect payment amount.");

        item.isSold = true;
        itemOwners[_itemId] = msg.sender;

        emit ItemPurchased(_itemId, msg.sender);
    }

    function withdrawFunds() public {
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds available for withdrawal.");
        require(
            itemOwners[itemCount] == msg.sender,
            "Only item owners can withdraw funds."
        );

        payable(msg.sender).transfer(balance);
        emit FundsWithdrawn(msg.sender, balance);
    }
}
