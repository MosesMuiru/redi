-module(redis_client).

% should connect to port 6379
% gen server that connects to this port
-behaviour(gen_server).

-export([start_link/1, query/1, request/1, start_recieve/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2]).

start_link(RedisPort) ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, RedisPort, []).

query(Message) ->
    gen_server:cast(?MODULE, {query, Message}).

request(Message) ->
    gen_server:call(?MODULE, {request, Message}).

init(RedisPort) ->
    {ok, Sock} =
        gen_tcp:connect("localhost",
                        RedisPort,
                        [binary, {packet, 0}, {active, false}, {reuseaddr, true}]),
    spawn(fun() -> start_recieve(Sock) end),

    %% after doing this i should be able to recieve data being sent
    %% spawn the recieve function and the response sent to be received on
    {ok, Sock}.

handle_call({request, Message}, _From, State) ->
    io:format("The message state ~p~n", [State]),
    Serial = serializor:serialize(Message),

    io:format("The serial ~p~n", [Serial]),

    ok = gen_tcp:send(State, Serial),

    % thee serial is sent to the sockete
    io:format("The message ~p~n, -- call", [Serial]),

    {reply, State, State}.

handle_cast({query, Message}, State) ->
    {noreply, State}.

handle_info({message_listener, Message}, State) ->
    {noreply, State}.

%% receive process
start_recieve(Socket) ->
    case gen_tcp:recv(Socket, 0) of
        {ok, Data} ->
            io:format("Received: ~p~n", [Data]),
            %% send the data the gen_serverkk
            Data,
            start_recieve(Socket);
        {error, closed} ->
            io:format("Client closed connection~n"),
            ok;
        {error, Reason} ->
            io:format("Socket error: ~p~n", [Reason]),
            ok
    end.
