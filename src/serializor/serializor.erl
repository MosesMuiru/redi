-module(serializor).

-export([hello_world/0, serialize/1]).

%% here i am to create a serializro
%%
-spec hello_world() -> string().
hello_world() ->
    "Hello world".

-spec serialize(list()) -> string().
serialize([]) ->
    "$-1\r\n";
serialize(Commands) ->
    Length = length(Commands),
    case Length of
        0 ->
            "$-1\r\n";
        1 ->
            [Command] = Commands,
            lists:flatten(
                io_lib:format("*~p\r\n$~p\r\n~s\r\n", [Length, length(Command), Commands]));
        _ ->
            [Head | Tail] = Commands,
            TheCommand =
                lists:flatten(
                    io_lib:format("*~p\r\n$~p\r\n~s\r\n", [Length, length(Head), Head])),

            [Serial] =
                lists:map(fun(Command) -> io_lib:format("$~p\r\n~s\r\n", [length(Command), Command])
                          end,
                          Tail),
            io:format("the command ~p~n", [Serial]),

            TheCommand ++ lists:flatten(Serial)
    end.
