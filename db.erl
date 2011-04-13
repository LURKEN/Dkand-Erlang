-module(db).
-export([read/1,withdraw/2, deposit/2,balance/1,listAll/0]).
-export([start/0,stop/0]).
-include("bank.hrl").
balance(Who) ->
	FUN = fun() ->
		case mnesia:read({account,Who}) of
			[]->
				ok;
			[E] ->
				E1 = E#account.balance,
				E1
			end
		end,
	{atomic, E}  = mnesia:transaction(FUN),
	lists:flatten(io_lib:format("~p",[E])).
	
read(Who)->
	FUN = fun()->
		case mnesia:read({account,Who}) of
			[]->
				ok;
			[E] ->
				E3 = E#account.code,
				E3
			end
		end,
	mnesia:transaction(FUN).
	
deposit(Amount,Who)->
	FUN = fun()->
		case mnesia:read({account,Who})of
			[]->
				ok;
			[E] ->
				Bal = E#account.balance,
				Nbal  = Amount + Bal,
				E1 = E#account{balance=Nbal},
				mnesia:write(E1),
				Nbal
			end
		end,
		{atomic, E}  = mnesia:transaction(FUN),
		lists:flatten(io_lib:format("~p",[E])).

withdraw(Amount,Who)->
	FUN = fun()->
		case mnesia:read({account,Who})of
			[]->
				ok;
			[E] ->
				Bal = E#account.balance,
				if
					Bal >= Amount ->
						Nbal  = Bal - Amount,
						E1 = E#account{balance=Nbal},
						mnesia:write(E1),
						Nbal;
					Bal < Amount ->
						ok
					end
			end
		end,
		{atomic, E}  = mnesia:transaction(FUN),
		lists:flatten(io_lib:format("~p",[E])).

listAll()->
	FUN = fun()->
		case mnesia:dirty_all_keys(account) of
			[] ->
				ok;
			[E|_] ->
				bal = E#account.balance
			end
		end,
	mnesia:transaction(FUN).

	
stop()->
	mnesia:stop().
	
start()->
	mnesia:start().
