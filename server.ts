import express, { Request, Response } from "express";
import path from "path";
import fs from "fs/promises";
import * as run from "./broadcast/Deploy.s.sol/31337/run-latest.json";
import { Contract, ethers } from "ethers";
import * as Wallet1 from "./out/Wallet1.sol/Wallet1.json";
import * as Wallet2 from "./out/Wallet2.sol/Wallet2.json";
import * as Wallet3 from "./out/Wallet3.sol/Wallet3.json";
import * as Proxy from "./out/Proxy.sol/Proxy.json";
import bodyParser from "body-parser";
import axios from "axios";

const USER_PUBLIC_KEY = "0x8469afEae8B562Ab9653775BE6ace82E1A304869";
let CURRENT_ACTIVE_WALLET_INDEX = 1;

async function expressServer() {
  const app = express();
  const addresses = getAddresses();
  const indexPage = await fs.readFile(
    path.join(__dirname, "./public/index.html")
  );
  const finalIndexPage = indexPage
    .toString()
    .replace("{{WALLET1}}", addresses.Wallet1)
    .replace("{{WALLET2}}", addresses.Wallet2)
    .replace("{{WALLET3}}", addresses.Wallet3)
    .replace("{{PROXY}}", addresses.Proxy);

  app.use(bodyParser.json());

  app.get("/", (req: Request, res: Response) => {
    res.send(finalIndexPage);
  });

  app.get("/index.html", (req: Request, res: Response) => {
    res.send(finalIndexPage);
  });
  app.get("/validate", async (req: Request, res: Response) => {
    const contract = getContract("Proxy");
    if (!contract) {
      res.status(500).send("Contract not found");
      return;
    }
    const admin = await contract.getAdmin397fa();
    if (admin === USER_PUBLIC_KEY) {
      res
        .status(200)
        .send(
          "Congratulations on mining through the challenge and unwrapping the truth of the blockchain! Here's your well-earned flag: HV24{SANT4_MIN3S_BL0CKS_4_MERRYC01NS} – a festive reward for your cleverness!"
        );
    } else {
      res
        .status(500)
        .send(
          "Oops! 🎅 The blockchain elves couldn’t verify your transaction. Looks like you didn’t quite crack the code this time. Double-check your hashes and try again – the flag is still waiting for you under the tree! 🎄🔗"
        );
    }
  });
  app.post("/get-funds", async (req: Request, res: Response) => {
    console.log("Getting funds for", req.body.address);
    await distributeFunds(req.body.address);
    res.status(200).send("Funds sent");
  });
  app.post("/rpc", async (req: Request, res: Response) => {
    const { method } = req.body;
    if (!method.startsWith("eth_")) {
      console.log("Invalid method:", method);
      res.status(403).send({ error: "Method not allowed" });
      return;
    }
    try {
      const response = await axios.post("http://localhost:8545", req.body);
      res.json(response.data);
    } catch (err) {
      res.status(500).send({ error: "Internal server error" });
    }
  });

  app.listen("8080", () => {
    console.log("Express listening on 8080");
  });
}

function getAddresses() {
  const addresses = {
    Wallet1: "",
    Wallet2: "",
    Wallet3: "",
    Proxy: "",
  };

  for (const tx of run.transactions) {
    if (tx.transactionType === "CREATE") {
      switch (tx.contractName) {
        case "Wallet1":
          addresses.Wallet1 = tx.contractAddress;
          break;
        case "Wallet2":
          addresses.Wallet2 = tx.contractAddress;
          break;
        case "Wallet3":
          addresses.Wallet3 = tx.contractAddress;
          break;
        case "Proxy":
          addresses.Proxy = tx.contractAddress;
          break;
      }
    }
  }

  return addresses;
}

function getProvider() {
  return new ethers.JsonRpcProvider("http://127.0.0.1:8545");
}

function getSigner() {
  return new ethers.Wallet(process.env["PRIVATE_KEY"] as string, getProvider());
}

function getContract(contract: string) {
  const provider = getProvider();
  const addresses = getAddresses();
  switch (contract) {
    case "Wallet1":
      return new Contract(addresses.Wallet1, Wallet1.abi, provider);
    case "Wallet2":
      return new Contract(addresses.Wallet2, Wallet2.abi, provider);
    case "Wallet3":
      return new Contract(addresses.Wallet3, Wallet3.abi, provider);
    case "Proxy":
      return new Contract(addresses.Proxy, Proxy.abi, provider);
  }
}

function getAbi(contract: string) {
  switch (contract) {
    case "Wallet1":
      return Wallet1.abi;
    case "Wallet2":
      return Wallet2.abi;
    case "Wallet3":
      return Wallet3.abi;
    case "Proxy":
      return Proxy.abi;
  }
}

function getContractNameByAddress(address: string) {
  const addresses = getAddresses();
  for (const [key, value] of Object.entries(addresses)) {
    if (value.toLocaleLowerCase() === address.toLocaleLowerCase()) {
      return key;
    }
  }
}

async function randomSwitcher() {
  const delay = Math.floor(Math.random() * 30) + 10;
  console.log("Switching in", delay, "seconds");
  setTimeout(async () => {
    const tragetWallet = Math.floor(Math.random() * 3) + 1;
    const walletAddress = await getContract(
      "Wallet" + tragetWallet
    )?.getAddress();
    const signer = getSigner();

    try {
      const tx = await new Contract(
        getAddresses().Proxy,
        Proxy.abi,
        signer
      ).setImplementation743a(walletAddress);
      await tx.wait();
      CURRENT_ACTIVE_WALLET_INDEX = tragetWallet;
      console.log(
        `Switched to ${getContractNameByAddress(walletAddress || "")}`
      );
    } catch (e) {
      console.log(`Error switching to ${walletAddress}`, e);
    }
    randomSwitcher();
  }, delay * 1000);
}

async function distributeFunds(target: string) {
  const signer = getSigner();
  const proxy = getContract("Proxy");
  if (!proxy) {
    console.log("Proxy not found");
    return;
  }

  const abi = getAbi(`Wallet${CURRENT_ACTIVE_WALLET_INDEX}`);
  if (!abi) {
    console.log("Abi not found");
    return;
  }

  const proyWallet = new Contract(await proxy.getAddress(), abi, signer);

  let tx;
  try {
    switch (`Wallet${CURRENT_ACTIVE_WALLET_INDEX}`) {
      case "Wallet1":
        tx = await proyWallet.distribute38c1b(target, { gasLimit: 20000000 });
        break;
      case "Wallet2":
        tx = await proyWallet.gift1a6e9(target, { gasLimit: 20000000 });
        break;
      case "Wallet3":
        tx = await proyWallet.send47de(target, { gasLimit: 20000000 });
        break;
    }
    await tx.wait();
  } catch (e) {
    console.log(`Error distributing funds to ${target}`, e);
  }
}

async function rickroll() {
  try {
    console.log("Rickrolling");
    const signer = getSigner();
    const tx = await signer.sendTransaction({
      from: signer.address,
      to: "0x52ba7c495a6e7a13e062da00726963e45db6dfa3",
      data: "0x68747470733a2f2f7777772e796f75747562652e636f6d2f77617463683f763d6451773477395767586351",
      value: 0,
    });
    await tx.wait()
    setTimeout(() => {
      rickroll();
    }, 60000)
  } catch (e) {
    console.log(`Error rickrolling`, e);
  }
}

expressServer();
randomSwitcher();
rickroll();

