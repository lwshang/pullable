# Pullable

Demo the ["pull dependencies"](https://github.com/dfinity/sdk/blob/master/docs/concepts/pull-dependencies.md#pull-dependencies) workflow provided by [`dfx`](https://github.com/dfinity/sdk).

## How to pull

The [example](./example/) project demonstrates how does an application canister pull its dependency from mainnet and integrate with it locally.

1. Declare the pull dependency in [`dfx.json`](./example/dfx.json)

```json
{
  "canisters": {
    "pullable": {
      "type": "pull",
      "id": "ig5e5-aqaaa-aaaan-qdxya-cai"
    }
  },
}
```

2. Pull from mainnet

```sh
> dfx deps pull
Fetching dependencies of canister ig5e5-aqaaa-aaaan-qdxya-cai...
Found 1 dependencies:
ig5e5-aqaaa-aaaan-qdxya-cai
Pulling canister ig5e5-aqaaa-aaaan-qdxya-cai...
```

3. Config the init argument

```sh
> dfx deps init
WARN: The following canister(s) require an init argument. Please run `dfx deps init <NAME/PRINCIPAL>` to set them individually:
ig5e5-aqaaa-aaaan-qdxya-cai (pullable)
> dfx deps init pullable
Error: Canister ig5e5-aqaaa-aaaan-qdxya-cai (pullable) requires an init argument. The following info might be helpful:
init => A natural number, e.g. 1
candid:args => (nat)
> dfx deps init pullable --argument 1
```

> You can run the last command directly. The commands above shows how does a developer figure out the required init argument.

4. Deploy on a local replica

```sh
> dfx start --clean --background
> dfx deps deploy
Creating canister: ig5e5-aqaaa-aaaan-qdxya-cai (pullable)
Installing canister: ig5e5-aqaaa-aaaan-qdxya-cai (pullable)
```

5. Import the dependency and make inter-canister call ([source code](./example/src/app/main.mo))

```sh
> dfx deploy app
> dfx canister call app pullable_times_2
(2 : nat)
```

## How to make a canister pullable?

This repository is also a reference for service providers.

Check [PULLABLE.md](./PULLABLE.md) for a step by step instruction.
