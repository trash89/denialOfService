from brownie import accounts, KingOfEther, Attack
from web3 import Web3


def main():
    ke = KingOfEther.deploy({"from": accounts[0]})
    print(f"KingOfEther deployed at {ke}")

    print_balances()
    print("Sending 1 ether from a[1]")
    tx = ke.claimThrone({"from": accounts[1], "value": "1 ether"})
    tx.wait(1)

    print_balances()
    print("Sending 2 ether from a[2]")
    tx = ke.claimThrone({"from": accounts[2], "value": "2 ether"})
    tx.wait(1)

    print_balances()
    att = Attack.deploy(ke.address, {"from": accounts[3]})
    print(f"Attack deployed at {att}")

    print("Attacking with 3 ether from a[3]")
    tx = att.attack({"from": accounts[3], "value": "3 ether"})
    tx.wait(1)
    print_balances()

    print("Trying to become new king by sending 4 ether from a[4] ...")
    tx = ke.claimThrone({"from": accounts[4], "value": "4 ether"})
    tx.wait(1)
    print_balances()

    # tx = ke.claimThrone({"from": accounts[5], "value": "5 ether"})
    # tx.wait(1)
    # print_balances()


def print_balances():
    a1 = Web3.fromWei(accounts[1].balance(), "ether")
    a2 = Web3.fromWei(accounts[2].balance(), "ether")
    a3 = Web3.fromWei(accounts[3].balance(), "ether")
    a4 = Web3.fromWei(accounts[4].balance(), "ether")
    a5 = Web3.fromWei(accounts[5].balance(), "ether")
    bal = Web3.fromWei(KingOfEther[-1].bal(), "ether")
    balance = Web3.fromWei(KingOfEther[-1].balance(), "ether")
    print(f"A[1]: {a1}, A[2]: {a2}, A[3]: {a3}, A[4]: {a4}, A[5]: {a5}")
    print(
        f"KingOfEther.bal: {bal}, KingOfEther.balance(): {balance}")
