pragma solidity  >=0.5.0;

import "./interfaces/IDappState.sol";
import "./DappLib.sol";


/********************************************************************************************/
/* This contract is auto-generated based on your choices in DappStarter. You can make       */
/* changes, but be aware that generating a new DappStarter project will require you to      */
/* merge changes. One approach you can take is to make changes in Dapp.sol and have it      */
/* call into this one. You can maintain all your data in this contract and your app logic   */
/* in Dapp.sol. This lets you update and deploy Dapp.sol with revised code and still        */
/* continue using this one.                                                                 */
/********************************************************************************************/

contract DappState is IDappState {
    // Allow DappLib(SafeMath) functions to be called for all uint256 types
    // (similar to "prototype" in Javascript)
    using DappLib for uint256; 


/*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/
/*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ S T A T E @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/
/*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/

    // Account used to deploy contract
    address private contractOwner;                  

/*>>>>>>>>>>>>>>>>>>>>>>>>>>> ACCESS CONTROL: ADMINISTRATOR ROLE  <<<<<<<<<<<<<<<<<<<<<<<<<<*/
    // Track authorized admins count to prevent lockout
    uint256 private authorizedAdminsCount = 1;                      

    // Admins authorized to manage contract
    mapping(address => uint256) private authorizedAdmins;                      

/*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ASSET VALUE TRACKING: TOKEN  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<*/
    string public name;
    string public symbol;
    uint256 public decimals;
    
    // Token balance for each address
    mapping(address => uint256) balances;              

    // Approval granted to transfer tokens by one address to another address                 
    mapping (address => mapping (address => uint256)) internal allowed; 

    // Tokens currently in circulation (you'll need to update this if you create more tokens)
    uint256 public total;                  

    // Tokens created when contract was deployed                             
    uint256 public initialSupply;         

    // Multiplier to convert to smallest unit                              
    uint256 public UNIT_MULTIPLIER;                                     
    struct EntityData {
        bool exists;
        bytes32 textInfo;
        uint256 numericInfo;
    }

    mapping(address => EntityData) entities;              // Store some data
    address[] entityList;                                   // Entity lookup


/*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/
/*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ C O N S T R U C T O R @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/
/*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/

    constructor() public 
    {
        contractOwner = msg.sender;       

/*>>>>>>>>>>>>>>>>>>>>>>>>>>> ACCESS CONTROL: ADMINISTRATOR ROLE  <<<<<<<<<<<<<<<<<<<<<<<<<<*/
        // Add account that deployed contract as an authorized admin
        authorizedAdmins[msg.sender] = 1;       

/*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ASSET VALUE TRACKING: TOKEN  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<*/
        name = "Flynn";             
        symbol = "$FLYNN";           
        decimals = 5;     

        // Multiplier to convert to smallest unit
        UNIT_MULTIPLIER = 10 ** uint256(decimals); 

        uint256 supply = 1000;       

        // Convert supply to smallest unit
        total = supply.mul(UNIT_MULTIPLIER);    
        initialSupply = total;

        // Assign entire initial supply to contract owner
        balances[contractOwner] = total;    

    }

/*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/
/*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ E V E N T S @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/
/*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/


/*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ASSET VALUE TRACKING: TOKEN  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<*/
    // Fired when an account authorizes another account to spend tokens on its behalf
    event Approval          
                            (
                                address indexed owner, 
                                address indexed spender, 
                                uint256 value
                            );

    // Fired when tokens are transferred from one account to another
    event Transfer          
                            (
                                address indexed from, 
                                address indexed to, 
                                uint256 value
                            );
    event EntityAdd(address indexed entity, bytes32 indexed textInfo, uint256 numericInfo);


/*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/
/*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ M O D I F I E R S @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/
/*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/


/*>>>>>>>>>>>>>>>>>>>>>>>>>>> ACCESS CONTROL: ADMINISTRATOR ROLE  <<<<<<<<<<<<<<<<<<<<<<<<<<*/
    /**
    * @dev Modifier that requires the function caller to be a contract admin
    */
    modifier requireContractAdmin()
    {
        require(isContractAdmin(msg.sender), "Caller is not a contract administrator");
        // Modifiers require an "_" which indicates where the function body will be added
        _;
    }


/*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/
/*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ F U N C T I O N S @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/
/*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/


/*>>>>>>>>>>>>>>>>>>>>>>>>>>> ACCESS CONTROL: ADMINISTRATOR ROLE  <<<<<<<<<<<<<<<<<<<<<<<<<<*/
    /**
    * @dev Checks if an account is an admin
    *
    * @param account Address of the account to check
    */
    function isContractAdmin
                            (
                                address account
                            ) 
                            public 
                            view
                            returns(bool) 
    {
        return authorizedAdmins[account] == 1;
    }


    /**
    * @dev Adds a contract admin
    *
    * @param account Address of the admin to add
    */
    function addContractAdmin
                            (
                                address account
                            ) 
                            external 
                            requireContractAdmin
    {
        require(account != address(0), "Invalid address");
        require(authorizedAdmins[account] < 1, "Account is already an administrator");

        authorizedAdmins[account] = 1;
        authorizedAdminsCount++;
    }

    /**
    * @dev Removes a previously added admin
    *
    * @param account Address of the admin to remove
    */
    function removeContractAdmin
                            (
                                address account
                            ) 
                            external 
                            requireContractAdmin
    {
        require(account != address(0), "Invalid address");
        require(authorizedAdminsCount >= 2, "Cannot remove last admin");

        delete authorizedAdmins[account];
        authorizedAdminsCount--;
    }

    /**
    * @dev Removes the last admin fully decentralizing the contract
    *
    * @param account Address of the admin to remove
    */
    function removeLastContractAdmin
                            (
                                address account
                            ) 
                            external 
                            requireContractAdmin
    {
        require(account != address(0), "Invalid address");
        require(authorizedAdminsCount == 1, "Not the last admin");

        delete authorizedAdmins[account];
        authorizedAdminsCount--;
    }


/*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ASSET VALUE TRACKING: TOKEN  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<*/
    /**
    * @dev Total supply of tokens
    */
    function totalSupply() 
                            external 
                            view 
                            returns (uint256) 
    {
        return total;
    }

    /**
    * @dev Gets the balance of the calling address.
    *
    * @return An uint256 representing the amount owned by the calling address
    */
    function balance()
                            public 
                            view 
                            returns (uint256) 
    {
        return balanceOf(msg.sender);
    }

    /**
    * @dev Gets the balance of the specified address.
    *
    * @param owner The address to query the balance of
    * @return An uint256 representing the amount owned by the passed address
    */
    function balanceOf
                            (
                                address owner
                            ) 
                            public 
                            view 
                            returns (uint256) 
    {
        return balances[owner];
    }

    /**
    * @dev Transfers token for a specified address
    *
    * @param to The address to transfer to.
    * @param value The amount to be transferred.
    * @return A bool indicating if the transfer was successful.
    */
    function transfer
                            (
                                address to, 
                                uint256 value
                            ) 
                            public 
                            returns (bool) 
    {
        require(to != address(0));
        require(to != msg.sender);
        require(value <= balanceOf(msg.sender));                                         

        balances[msg.sender] = balances[msg.sender].sub(value);
        balances[to] = balances[to].add(value);
        emit Transfer(msg.sender, to, value);
        return true;
    }

    /**
    * @dev Transfers tokens from one address to another
    *
    * @param from address The address which you want to send tokens from
    * @param to address The address which you want to transfer to
    * @param value uint256 the amount of tokens to be transferred
    * @return A bool indicating if the transfer was successful.
    */
    function transferFrom
                            (
                                address from, 
                                address to, 
                                uint256 value
                            ) 
                            public 
                            returns (bool) 
    {
        require(from != address(0));
        require(value <= allowed[from][msg.sender]);
        require(value <= balanceOf(from));                                         
        require(to != address(0));
        require(from != to);

        balances[from] = balances[from].sub(value);
        balances[to] = balances[to].add(value);
        allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
        emit Transfer(from, to, value);
        return true;
    }

    /**
    * @dev Checks the amount of tokens that an owner allowed to a spender.
    *
    * @param owner address The address which owns the funds.
    * @param spender address The address which will spend the funds.
    * @return A uint256 specifying the amount of tokens still available for the spender.
    */
    function allowance
                            (
                                address owner, 
                                address spender
                            ) 
                            public 
                            view 
                            returns (uint256) 
    {
        return allowed[owner][spender];
    }

    /**
    * @dev Approves the passed address to spend the specified amount of tokens 
    *      on behalf of msg.sender.
    *
    * @param spender The address which will spend the funds.
    * @param value The amount of tokens to be spent.
    * @return A bool indicating success (always returns true)
    */
    function approve
                            (
                                address spender, 
                                uint256 value
                            ) 
                            public 
                            returns (bool) 
    {
        allowed[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function getEntitiesByPage
                                (
                                    uint256 page, 
                                    uint256 resultsPerPage
                                ) 
                                external 
                                view 
                                returns(address[] memory) 
    {
        /*
            Source: https://medium.codylamson.com/how-to-paginate-smart-contract-array-returns-cd6227479aa3
            ex: _page 1, _resultsPerPage 20 | 1 * 20 - 20 = 0
            ex2: _page 2, _resultsPerPage 20 | 2 * 20 - 20 = 20
            starting point for listing items in array
        */

        uint256 index = resultsPerPage.mul(page).sub(resultsPerPage);

        // Return emptry array if already empty or index is out of bounds
        if ((entityList.length == 0) || (index > entityList.length.sub(1))) {
            return new address[](0);
        }

        // Create fixed length array because we cannot push to array in memory
        address[] memory entityPage = new address[](resultsPerPage);

        
        uint256 returnCounter = 0; 
        
        for(index; index < (resultsPerPage.mul(page)); index++) {
            if (index < (entityList.length.sub(1))) {
                entityPage[returnCounter] = entityList[index];
            } else {
                entityPage[returnCounter] = address(0);
            }

            returnCounter++;
        }

        return entityPage;
    }

    function getEntityData
                        (
                            address entity
                        ) 
                        external 
                        view 
                        returns(bytes32, uint256) 
    {
        return (entities[entity].textInfo, entities[entity].numericInfo);
    }    

    function setEntityData
                        (
                            bytes32 textInfo,
                            uint256 numericInfo   
                        ) 
                        external 
    {
        if (!entities[msg.sender].exists) {
            entityList.push(msg.sender);
            emit EntityAdd(msg.sender, textInfo, numericInfo);
        }

        entities[msg.sender] = EntityData({
                                exists: true,
                                textInfo: textInfo,
                                numericInfo: numericInfo
                            });
    }


    /**
    * @dev This is an EXAMPLE function that illustrates how functions in this contract can be
    *      called securely from another contract. Using the Contract Access block will enable
    *      you to make your contract more secure by restricting which external contracts can
    *      call functions in this contract.
    *
    */
    function getContractOwner()
                                external
                                view
                                returns(address)
    {
        // NOTE: If a contract is calling this function, then msg.sender will be the address
        //       of the calling contract and NOT the address of the user who initiated the
        //       transaction. It is possible to get the address of the user, but this is 
        //       spoofable and therefore not recommended.
        
        return contractOwner;
    }
}   


