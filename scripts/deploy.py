from brownie import Voting
from web3 import Web3
from scripts.helpful_scripts import get_account


import yaml
import json
import os
import shutil


election_name = "Test Election"

def deploy():
    account = get_account()
    if len(Voting) <=0:
        voting = Voting.deploy( election_name, {"from":account})
    else:
        voting = Voting[len(Voting)-1]

    update_front_end()

def update_front_end():
    # Send the build folder
    copy_folders_to_front_end("./build", "./front_end/src/chain-info")

    # Sending the front end our config in JSON format
    with open("brownie-config.yaml", "r") as brownie_config:
        config_dict = yaml.load(brownie_config, Loader=yaml.FullLoader)
        with open("./front_end/src/brownie-config.json", "w") as brownie_config_json:
            json.dump(config_dict, brownie_config_json)
    print("Front end updated!")


def copy_folders_to_front_end(src, dest):
    if os.path.exists(dest):
        shutil.rmtree(dest)
    shutil.copytree(src, dest)

def main():
    deploy()