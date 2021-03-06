pragma solidity  >=0.5.0;

/********************************************************************************************/
/*  This contract is the interface for DappState.sol functions used in Dapp.sol             */
/*  to enable DappState functions to be called from Dapp. You can restrict the functions    */
/*  in DappState directly known to Dapp by limiting the definitions you include here.       */
/*  It's OK to not use IDappState and Dapp, but if you do use them, it's highly recommended */
/*  that you use the Contract Access block so you can limit which contracts can call in to  */
/*  the DappState contract.                                                                 */
/********************************************************************************************/

interface IDappState {
    function getContractOwner() external view returns(address);
}