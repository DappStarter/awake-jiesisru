const HDWalletProvider = require('@truffle/hdwallet-provider');

let devUrl = 'http://127.0.0.1:7545/';
let mnemonic = 'gesture roast food ski stove cruise noise honey inflict neck equal gate';   
let testAccounts = [
"0xc4f70eca639fe0c6553340c068d9009cb6359dec877bb5425ac9a7cd4af39f9a",
"0x7dbe7ed26f54b745a9923b269b5e4ca6fa409d6201b9f37602a7f32da70cedf6",
"0xef720a0e004e429800f715adf2a3fd8c6bbea3e6ed22d082128a682d82caa58e",
"0xebd18ddc98307ce628fcf3ed74d392802bfa6321a3af6da1be70381a3de0cc37",
"0x20954d295f1ca9466b92c2182b8916a2337620680203df2f7ec58a636d3df2e0",
"0x64dfcf55e99bda0203d60e43ff87a4e518bdd32d09687c0cc1fe091455f39e50",
"0xe2ac9d77b2204697ae88129fb5550fd8d76b01b5970a79b2eb2eca5ba72bccc6",
"0x8e90ad329bee590f7291b796e034f443b4e059eb89c99173496d55fea5f08f2c",
"0xdfdf13c9ae4e0f9e4c5833fc60a8dd42ae4eeeafb24040a79ee17fce7dce6e5a",
"0x973f2c79cb87c17b63e671452664ae3b45460a01450d1a7dae12d259a7d64584"
];  

module.exports = {
  networks: {
    development: {
      url: devUrl,  // Required for DappStarter config generation
      provider: () => new HDWalletProvider(
                                      testAccounts,
                                      devUrl,           // provider url
                                      0,                // address index
                                      10,               // number of addresses
                                      true,             // share nonce
                                      `m/44'/60'/0'/0/` // wallet HD path
                                    ),
      network_id: '*'
    }
  },
  compilers: {
    solc: {
      version: '^0.5.11'
    }
  }
};
