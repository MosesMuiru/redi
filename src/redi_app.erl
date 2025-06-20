%%%-------------------------------------------------------------------
%% @doc redi public API
%% @end
%%%-------------------------------------------------------------------

-module(redi_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    redi_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
