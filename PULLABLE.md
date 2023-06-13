# Pullable Guide

["pull dependencies"](https://github.com/dfinity/sdk/blob/master/docs/concepts/pull-dependencies.md) provides a solution for canister local integration.

Service consumers only need the canister ID of a pullable canister. Then they can pull the dependency and test integration locally.

This guide helps service providers to make their canisters pullable.

## To be pullable or not?

Before getting into the guide, we need figure out whether the canister is suitable to be pullable.

In short, any canister **providing public service** at a **static canister ID** is good to be pullable.

If your canister is meant to be called only by yourself, it makes no sense to make it pullable.

If you publish canister wasm so that other developers can deploy their own instances, it's also meaningless to make it pullable. Because the canister ID of an instance is not static. To test integration locally, a user should deploy it directly. The asset canister provided by `dfx` is an typical example.

If a service canister also depends on other canisters, those dependencies must also be pullable. So before making change to your own project, please check if the dependencies have already been pullable. If not, please try to contact its developers and ask them to check this guide.

## Configuration in `dfx.json`

Define `pullable` of the canister in [`dfx.json`](./dfx.json):

```json
{
  "canisters": {
    "service": {
      "type": "motoko",
      "main": "src/pullable/main.mo",
      "pullable": {
        "dependencies": [],
        "wasm_url": "https://github.com/lwshang/pullable/releases/latest/download/service.wasm",
        "init_guide": "A natural number, e.g. 1"
      }
    }
  }
}
```

The wasm module of a pullable canister must be hosted via an URL so that service consumers can download it when pulling the dependency.

GitHub Releases might be a good option with no cost if the project is open source on GitHub. The URL schema is as below:

```
https://github.com/<USERNAME>/<REPONAME>/releases/latest/download/<FILENAME>
```

Check [this section](https://github.com/dfinity/sdk/blob/master/docs/concepts/pull-dependencies.md#service-provider-workflow) for more details of other fields.

## Deploy Routine

Service providers will need follow a deploy routine as below.

### 1. Deploy the canister to the mainnet

```sh
> dfx deploy --network ic
```

### 2. Git tag and GitHub Release

```sh
> git tag 0.1.0
> git push --tags
```

Then follow [this guide](https://docs.github.com/en/repositories/releasing-projects-on-github/managing-releases-in-a-repository#creating-a-release) to create a release.

### 3. Attach the wasm to release assets

[Edit the release](https://docs.github.com/en/repositories/releasing-projects-on-github/managing-releases-in-a-repository#editing-a-release) and attach the deployed wasm as a release asset.

The deployed wasm is at

```
.dfx/ic/canisters/<CANISTER_NAME>/<CANISTER_NAME>.wasm
```

In this project, it will be:


```
.dfx/ic/canisters/service/service.wasm
```

## Automate the Routine in CI

[This CI configuration](.github/workflows/release.yml) demonstrates how to use GitHub Action to automate the deploy routine.

Then the workflow will be like:

1. Push a git tag and wait for the GitHub release to complete
2. Download the canister wasm from the release assets, e.g.
   ```sh
   > wget https://github.com/lwshang/pullable/releases/latest/download/service.wasm
   ```
3. Install (upgrade) the canister using the downloaded wasm, e.g.
   ```sh
   > dfx canister --network ic install service --wasm service.wasm --argument '(1 : nat)' --mode upgrade
   ```
