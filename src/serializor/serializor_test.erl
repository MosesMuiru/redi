-module(serializor_test).

-include_lib("eunit/include/eunit.hrl").

hello_world_test() ->
    ?assertEqual("Hello world", serializor:hello_world()).

% if you pass a command it should be converted to resp protocal
% pass an empty string
serialize_test() ->
    ?assertEqual("$-1\r\n", serializor:serialize([])),
    ?assertEqual("*1\r\n$4\r\nping\r\n", serializor:serialize(["ping"])),
    ?assertEqual("*2\r\n$3\r\nget\r\n$3\r\nkey\r\n", serializor:serialize(["get", "key"])),
    ?assertEqual("*2\r\n$4\r\necho\r\n$11\r\nhello world\r\n",
                 serializor:serialize(["echo", "hello world"])).

unserialize_test( ) 0 -> ?assertEqual( "$-1\r\n" , serializor : serialize( [ ] ) ) ,
