-module(client).
-export([send/1,balance/1,deposit/2,withdraw/2]).

send(Message) ->
    {ok,Socket} = gen_tcp:connect("localhost",9999,[{active,false},{packet,0}]),
    gen_tcp:send(Socket,Message),
	recive(Socket),
    gen_tcp:close(Socket).
	
balance(Who) ->
	io:fwrite("Balance:\n"),
    {ok,Socket} = gen_tcp:connect("localhost",9999,[{active,false},{packet,0}]),
    
	gen_tcp:send(Socket,<<1>>),
	{ok,_} = gen_tcp:recv(Socket,0),%%Hej!
	
	gen_tcp:send(Socket,Who),
	recive(Socket),
	
    gen_tcp:close(Socket).
	
deposit(Who,Val) ->
	io:fwrite("deposit:\n"),
    {ok,Socket} = gen_tcp:connect("localhost",9999,[{active,false},{packet,0}]),
    
	gen_tcp:send(Socket,<<2>>),
	{ok,_} = gen_tcp:recv(Socket,0),%%Hej!
	
	gen_tcp:send(Socket,Who),
	recive(Socket),
	
	Val2 = lists:flatten(io_lib:format("~p", [Val])),
	
	gen_tcp:send(Socket,Val2),
	recive(Socket),
	
    gen_tcp:close(Socket).
	
withdraw(Who,Val) ->
	io:fwrite("withdraw\n"),
    {ok,Socket} = gen_tcp:connect("localhost",9999,[{active,false},{packet,0}]),
   
	gen_tcp:send(Socket,<<3>>),
	{ok,_} = gen_tcp:recv(Socket,0),%%Hej!
	
	gen_tcp:send(Socket,Who),
	{ok,_} = gen_tcp:recv(Socket,0),%%Hej!
	
	Val2 = lists:flatten(io_lib:format("~p", [Val])),
	
	gen_tcp:send(Socket,Val2),
	recive(Socket),
	
    gen_tcp:close(Socket).
	
recive(Socket) ->
	{ok,A} = gen_tcp:recv(Socket,0),
    io:fwrite(A++"\n").