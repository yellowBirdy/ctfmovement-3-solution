# ctfmovement-3-solution

https://ctfmovement.movebit.xyz/challenges
http://47.243.227.164:20002/web/

## Description
This is a DEX challenge, try to empty either token. Follow the steps below to complete the challenge. The goal is calling the get_flag() function to trigger a Flag event, and submit the transaction hash to get the flag. You can reach the contract code here: https://github.com/movebit/ctfmovement-3.

## Goal 
> call the get_flag() function to successfully trigger an event.


Function is not access controlled. It is however gated by  `assert!(c1 == 0 || c2 == 0, 0)` statement, where `c1` and `c2` are defined as pools internal balances of `Coin1` and `Coin2` respectively. 
Should the assertion pass, it will emit a `Flag` event. In other words, to pass the challenge:
*At least one of the pools internal coin blances need to be drained to 0*


## Code analysis 

### Security assesments
The issue is naive way of computing the price of the swap namely as ratio of coins' balances. Such method would be accurate in a condition of infinite liquidity, in other words it does not factor in the price slippage. 

### Exploit mechanism 
A simple sequence of swaps in alternating direction will allow to drain the pool completely or nearly completely (dust amount of one of the coins may remain, depending on the implementation).


### Mitigation 
The traditional AMMs use a constant product equation in which the product of both coin amounts has to remain invariant.  



## Exploit details
