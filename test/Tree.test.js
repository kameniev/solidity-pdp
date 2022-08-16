const { expect } = require("chai")
const { ethers } = require("hardhat")

describe("Tree", function() {
    let acc
    let tree
    const trueTransaction = "TX3"
    const fakeTransaction = "TX3f"
    const index = 2
    const root = "0xf02660d266c82b19ed6ebf39ef4c898c5ad5fa8944e2faab2c5bf2c9f3a81d49"
    const proof = ["0x8e52fa588bdaf33422fa2f2ba5f32d83c3ec755d25196f0f4f4605cbdc7cd2cc", "0xf056f9f0bb5fd7833fecc23f27ae82b0afc956b4dd4c8b85b48861d159893083"]

    beforeEach(async function() {
        [acc] = await ethers.getSigners()
        const Tree = await ethers.getContractFactory("Tree", acc)
        tree = await Tree.deploy()
        await tree.deployed()
    })

    it("should confirm transaction", async () => {
        await expect(
            await tree.verify(trueTransaction, index, root, proof)
        ).to.eq(true)
    })

    it("should decline transaction", async () => {
        await expect(
            await tree.verify(fakeTransaction, index, root, proof)
        ).to.eq(false)
    })

})