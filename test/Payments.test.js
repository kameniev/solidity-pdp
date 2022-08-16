const { expect } = require("chai")
const { ethers } = require("hardhat")

describe("Payments", function() {
    let acc1, acc2
    let payments

    beforeEach(async function() {
        [acc1, acc2] = await ethers.getSigners()
        const Payments = await ethers.getContractFactory("Payments", acc1)
        payments = await Payments.deploy()
        await payments.deployed()
    })

    it("should be deployed", async () => {
        expect(payments.address).to.be.properAddress
    })

    it("should have 0 ether by default", async () => {
        const balance = await payments.currentBalance()
        expect(balance).to.eq(0)
    })

    it("should be possible to send funds", async () => {
        const value = 100
        const msg = "success!"
        const tx = await payments.connect(acc2).pay(msg, { value })
        await expect(() => tx).to.changeEtherBalances([acc2, payments], [-value, value])
        await tx.wait()

        const newPayment = await payments.getPayments(acc2.address, 0)
        //console.log(newPayment)
        expect(newPayment.message).to.eq(msg)
        expect(newPayment.amount).to.eq(value)
        expect(newPayment.from).to.eq(acc2.address)
    })
})