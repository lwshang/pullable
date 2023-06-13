import service "canister:service";

actor {
    public func double_service() : async Nat {
        let res = 2 * (await service.get());
        return res;
    };
};
