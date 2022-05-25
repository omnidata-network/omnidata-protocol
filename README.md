# Omnidata protocol

This protocol is still under development, use at your own risk.


<details>
  <summary>Testnet Addresses:</summary>
  
  |   Chain Name   |         Omnidata Gateway Contract            |                Oracle Contract               |                OmniNFT Contract              |
  | :------------: | :------------------------------------------: | :------------------------------------------: | :------------------------------------------: |
  |  Avax Testnet  | `0xb87EaDc8D4fd1E407b33dE306De2BCc7eeb54d1b` | `0x486477a1c32CDFc60431B27A3EA19c7b9cAe8b0f` | `0x8bA1c88100726E56e5Fe38c6004f2659414ECF03` |
  |     Kovan      | `0xf986D9bb6067d686619eb559eae5D4296c66d2a0` | `0x59363B0a8229Ba2dA5FBEf6D36f899351F606a09` | `0x3f9DB3ec8D277C89B0eF6eDf817229F4d58aC649` |
  |    Mumbai      | `0xe618176813A7328CF2015730bd83e2AE2Db48878` | `0xb87EaDc8D4fd1E407b33dE306De2BCc7eeb54d1b` | `0x486477a1c32CDFc60431B27A3EA19c7b9cAe8b0f` |
  |  BNB Testnet   | `0xb87EaDc8D4fd1E407b33dE306De2BCc7eeb54d1b` | `0xe618176813A7328CF2015730bd83e2AE2Db48878` | `0x486477a1c32CDFc60431B27A3EA19c7b9cAe8b0f` |
  
</details>



Try running some of the following tasks:

```shell
npx hardhat accounts
npx hardhat compile
npx hardhat clean
npx hardhat test
npx hardhat node
npx hardhat help
REPORT_GAS=true npx hardhat test
npx hardhat coverage
npx hardhat run scripts/deploy.ts
TS_NODE_FILES=true npx ts-node scripts/deploy.ts
npx eslint '**/*.{js,ts}'
npx eslint '**/*.{js,ts}' --fix
npx prettier '**/*.{json,sol,md}' --check
npx prettier '**/*.{json,sol,md}' --write
npx solhint 'contracts/**/*.sol'
npx solhint 'contracts/**/*.sol' --fix
```

# Etherscan verification

To try out Etherscan verification, you first need to deploy a contract to an Ethereum network that's supported by Etherscan, such as Ropsten.

In this project, copy the .env.example file to a file named .env, and then edit it to fill in the details. Enter your Etherscan API key, your Ropsten node URL (eg from Alchemy), and the private key of the account which will send the deployment transaction. With a valid .env file in place, first deploy your contract:

```shell
hardhat run --network ropsten scripts/deploy.ts
```

Then, copy the deployment address and paste it in to replace `DEPLOYED_CONTRACT_ADDRESS` in this command:

```shell
npx hardhat verify --network ropsten DEPLOYED_CONTRACT_ADDRESS "Hello, Hardhat!"
```

# Performance optimizations

For faster runs of your tests and scripts, consider skipping ts-node's type checking by setting the environment variable `TS_NODE_TRANSPILE_ONLY` to `1` in hardhat's environment. For more details see [the documentation](https://hardhat.org/guides/typescript.html#performance-optimizations).
