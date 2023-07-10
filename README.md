# ctfmovement-3-solution

Solution to Movebit's [Aptos Move CTF](https://ctfmovement.movebit.xyz/challenges) [challenge 3](http://47.243.227.164:20002/web/)


## Description
This is a DEX challenge, try to empty either token. Follow the steps below to complete the challenge. The goal is calling the get_flag() function to trigger a Flag event, and submit the transaction hash to get the flag. You can reach the contract code here: https://github.com/movebit/ctfmovement-3.

## Success conditions 
> call the get_flag() function to successfully trigger an event.

`get_flag()` function is not access controlled. It is however gated by  `assert!(c1 == 0 || c2 == 0, 0)` statement, where `c1` and `c2` are defined as pools internal balances of `Coin1` and `Coin2` respectively. Should the assertion pass, it will emit a `Flag`  



## Code analysis 

### Security assesments
The issue is naive way of computing the price of the swap namely as ratio of coins' balances. Such method would be accurate in a condition of infinite liquidity, in other words it does not factor in the price slippage. Indeed the `get_flag()` assertion coditions checks if _At least one of the pools internal coin blances has been drained to 0_


### Exploit mechanism 
A simple sequence of swaps in alternating direction will allow to drain the pool completely or nearly completely (dust amount of one of the coins may remain, depending on the implementation).

### Mitigation 
The traditional AMMs use a constant product equation in which the product of both coin amounts has to remain invariant.  



## Exploit details

### Considerations
1. Pool's swapping functions (`swap_12` and `swap_21`) are not marked as `entry` so they can't be called directly from offchain. A contract needs to be written and published to make the calls.
2. Pool does not exopose publiccly callable functions returning the price nor the balances. Hece the following manual calculation of the swap amounts becomes necessary. (Note that, although `get_amounts` and `get_amouts_out` are `public`, thier first parameter is a reference to the `LiquidityPool` resource, rendering them inaccessible from outside of the contract )

The fastest way to pass the challenge is to swap with maximum available amount, bared the last swap witch has to swap smaller value in order to prevent a revert due to insufficient pool balance. The amount in the last swap needs to equal the pool balance of the coin we are swapping from in order to drain the 2nd coin's reserve completely.

| Direction | Amount in | Amount Out | POOL Coin1 | POOL Coin2 |	
|-----------|-----------|------------|------------|------------|
| c1 - > c2 | 5         | 5          | 55         | 45         |
| c2 - > c1 | 10        | 12         | 43         | 55         |
| c1 - > c2 | 12        | 15         | 55         | 40         |
| c2 - > c1 | 15        | 20         | 35         | 55         |
| c1 - > c2 | 20        | 31         | 55         | 24         |
| c2 - > c1 | 24        | 55         | 0          | 48         |

Note that using smaller swam amounts would allow for more efficient draining, up to leaving only a single coin of one of the types remaining in the pool




