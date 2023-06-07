import pullable "canister:pullable";

actor {
    public func pullable_times_2() : async Nat {
        let res = 2 * (await pullable.get());
        return res;
    };
};
