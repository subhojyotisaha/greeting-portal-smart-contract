const main = async () => {
  const [owner, randomPerson] = await hre.ethers.getSigners();

  const greetingsContractFactory = await hre.ethers.getContractFactory(
    "GreetingsPortal"
  );
  const greetingsContract = await greetingsContractFactory.deploy({
    value: hre.ethers.utils.parseEther("0.1"),
  });
  await greetingsContract.deployed();
  console.log("Contract deployed at: ", greetingsContract.address);
  console.log("Contract deployed by:", owner.address);

  let greetingCount;
  greetingCount = await greetingsContract
    .getGreetingCount()
    .then((response) => {
      return response[0];
    });
  console.log(greetingCount.toNumber());

  let contractBalance = await hre.ethers.provider.getBalance(
    greetingsContract.address
  );
  console.log(
    "Contract balance:",
    hre.ethers.utils.formatEther(contractBalance)
  );

  const greetTxn = await greetingsContract.greet(
    "Hi, I am owner of this contract!"
  );
  await greetTxn.wait();

  const greetTxn2 = await greetingsContract
    .connect(randomPerson)
    .greet("Hi, nice contract!");
  await greetTxn2.wait();
  const greetTxn3 = await greetingsContract
    .connect(randomPerson)
    .greet("Hi, love this!");
  await greetTxn3.wait();

  contractBalance = await hre.ethers.provider.getBalance(
    greetingsContract.address
  );
  console.log(
    "Contract balance:",
    hre.ethers.utils.formatEther(contractBalance)
  );

  let allGreets = await greetingsContract.getAllGreets();
  console.log(allGreets);

  greetingCount = await greetingsContract
    .connect(randomPerson)
    .getGreetingCount();
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();
