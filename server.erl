-module(server).
-export([start/0]).
-import(db).

start() ->
	io:fwrite("Starting Server\n"),
	db:start(),
	io:fwrite("Starting Database\n"),
	listen().

listen() ->
	{ok, LSocket} = gen_tcp:listen(9999,[binary,{packet,0},{active,false},{reuseaddr, true}]),
	accept(LSocket).
	
accept(LSocket) ->
    {ok, Socket} = gen_tcp:accept(LSocket),
    spawn(fun() -> loop(Socket) end),
    accept(LSocket).
	
loop(Socket) ->
    case gen_tcp:recv(Socket, 0) of	%%Ta_emot_data
        {ok, Data} ->
			io:fwrite("\n"),
			io:fwrite(Data),	%%skriver_ut_data
			E= test(Data,Socket),
			E,
            loop(Socket);
        {error, closed} ->
            ok
    end.

test(<<1>>,Socket)->	%%Balance
	io:fwrite("Balance:"),
	
	gen_tcp:send(Socket, "Hej!"),
	{ok,Who} = gen_tcp:recv(Socket,0),
	
	Bal = db:balance(binary_to_list(Who)),
	io:fwrite("Balance: "++Bal++"\n"),
	gen_tcp:send(Socket, Bal);
	
test(<<2>>,Socket)->	%%InsertMoney
	io:fwrite("InsertMoney\n"),
	
	gen_tcp:send(Socket, "Vilken User:"),
	{ok,Who} = gen_tcp:recv(Socket,0),
	
	gen_tcp:send(Socket, "Hur mycket:"),
	{ok,Val} = gen_tcp:recv(Socket,0),
	
	Bal = db:deposit(list_to_integer(binary_to_list(Val)),binary_to_list(Who)),
	gen_tcp:send(Socket, Bal);
	
test(<<3>>,Socket)-> 	%%RemoveMoney
	io:fwrite("RemoveMoney\n"),
	
	gen_tcp:send(Socket, "Hej!"),
	{ok,Who} = gen_tcp:recv(Socket,0),
	
	gen_tcp:send(Socket, "Hej!"),
	{ok,Val} = gen_tcp:recv(Socket,0),
	
	Bal = db:withdraw(list_to_integer(binary_to_list(Val)),binary_to_list(Who)),
	gen_tcp:send(Socket, Bal);
test(<<4>>,Socket)->	%%logout
	io:fwrite("logout"),
	gen_tcp:send(Socket, "4"),
	close(Socket);
	
test(<<5>>,Socket)->	%%exit
	io:fwrite("5:"),
	gen_tcp:send(Socket, "5");
	
test(_,Socket) ->
	io:fwrite("Fel i kommando!"),
	gen_tcp:send(Socket, "Fel i kommando!").