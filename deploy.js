const ethers = require("ethers");
// const solc = require("solc")
const fs = require("fs-extra");
require("dotenv").config();

async function main() {
  // First, compile this!
  // And make sure to have your ganache network up!
  let provider = new ethers.providers.JsonRpcProvider(process.env.RPC_URL);
  let wallet = new ethers.Wallet(process.env.PRIVATE_KEY, provider);
  const encryptedJson = fs.readFileSync("./.encryptedKey.json", "utf8");

  wallet = wallet.connect(provider);
  const abi = fs.readFileSync("./SimpleStorage_sol_SimpleStorage.abi", "utf8");
  const binary = fs.readFileSync(
    "./SimpleStorage_sol_SimpleStorage.bin",
    "utf8"
  );
  const contractFactory = new ethers.ContractFactory(abi, binary, wallet);
  console.log("Deploying, please wait...");
  const contract = await contractFactory.deploy();
  // const contract = await contractFactory.deploy({ gasPrice: 100000000000 })
  await contract.deployTransaction.wait(1);
  console.log(`Contract address: ${contract.address}`);

  // console.log("Let's deploy another! Please wait...")
  // let resp = await wallet.signTransaction(tx)
  // const sentTxResponse = await wallet.sendTransaction(tx);
  // console.log(resp)

  let currentFavoriteNumber = await contract.retrieve();
  console.log(`Current Favorite Number: ${currentFavoriteNumber}`);
  console.log("Updating favorite number...");
  let transactionResponse = await contract.store(7);
  let transactionReceipt = await transactionResponse.wait();
  currentFavoriteNumber = await contract.retrieve();
  console.log(`New Favorite Number: ${currentFavoriteNumber}`);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

// synchronous [solidity]
// asynchronous [javascript]

// cooking
// Synchronous
// 1. Put popcorn in microwave -> Promise
// 2. Wait for popcorn to finish
// 3. Pour drinks for everyone

// Asynchronous
// 1. Put popcorn in the mircrowave
// 2. Pour drinks for everyone
// 3. Wait for popcorn to finish

// Promise
// Pending
// Fulfilled
// Rejected
