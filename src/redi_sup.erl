%%%-------------------------------------------------------------------
%% @doc redi top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(redi_sup).

-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

-define(SERVER, ?MODULE).

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%% sup_flags() = #{strategy => strategy(),         % optional
%%                 intensity => non_neg_integer(), % optional
%%                 period => pos_integer()}        % optional
%% child_spec() = #{id => child_id(),       % mandatory
%%                  start => mfargs(),      % mandatory
%%                  restart => restart(),   % optional
%%                  shutdown => shutdown(), % optional
%%                  type => worker(),       % optional
%%                  modules => modules()}   % optional
init([]) ->
    SupFlags =
        #{strategy => one_for_all,
          intensity => 0,
          period => 1},
    ChildSpecs =
        [#{id => redis_client,
           start => {redis_client, start_link, [6379]},
           restart => permanent,
           shutdown => 4000,
           type => worker,
           modules => [redis_client]}],
    {ok, {SupFlags, ChildSpecs}}.

%% internal functions
