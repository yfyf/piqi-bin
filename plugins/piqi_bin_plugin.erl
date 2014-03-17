-module(piqi_bin_plugin).

-export([
    'post_compile'/2
]).

%% ====================================================================
%% rebar plugin hooks
%% ====================================================================

'post_compile'(Config, _AppFile) ->
    verify_piqi_version(Config).

%% ====================================================================
%% Private parts
%% ====================================================================


verify_piqi_version(Config) ->
    AllReqPiqiVsns = rebar_config:get_all(Config, req_piqi_vsn),
    case AllReqPiqiVsns of
        [] ->
            ok;
        List ->
            ReqPiqiVsn = lists:last(AllReqPiqiVsns),
            VsnOld = os:cmd("piqi version"), %% returned by piqi =< 0.6.5
            VsnNew = os:cmd("piqi --version"), %% returned by piqi > 0.6.5
            StrVsn = case VsnOld of
                "0." ++ _ -> VsnOld;
                _ -> VsnNew
            end,
            Vsn = parse_vsn(StrVsn),
            compatible_vsns(Vsn, ReqPiqiVsn)
    end.

compatible_vsns(Vsn, []) ->
    ok;
compatible_vsns(Vsn, [{Cmp, ReqVsnStr}|ReqVsns]) ->
    ReqVsn = parse_vsn(ReqVsnStr),
    case compatible_vsn(Cmp, Vsn, ReqVsn) of
        true ->
            compatible_vsns(Vsn, ReqVsns);
        false ->
            rebar_utils:abort(
              "Piqi version ~p incompatible. Could not satisfy constraint ~p~n",
              [Vsn, {Cmp, ReqVsnStr}]
            )
    end.

cmp(X, Y) when X > Y ->
    gt;
cmp(X, X) ->
    eq;
cmp(X, Y) ->
    lt.

compatible_vsn(Cmp, [X], [Y]) when is_integer(X), is_integer(Y) ->
    cmp(X, Y) == Cmp;
compatible_vsn(Cmp, [X|Xs], [Y|Ys]) when is_integer(X), is_integer(Y) ->
    case cmp(X, Y) of
        eq ->
            compatible_vsn(Cmp, Xs, Ys);
        Cmp ->
            true;
        _ ->
            false
    end;
compatible_vsn(Cmp, [X|Xs], [Y|Ys]) when is_integer(X) ->
    true;
compatible_vsn(Cmp, [X|Xs], [Y|Ys]) ->
    cmp(X, Y) == Cmp;
compatible_vsn(Cmp, [], [_|_]) ->
    Cmp == lt;
compatible_vsn(Cmp, _, []) ->
    Cmp == gt.

parse_vsn(StringVsn) ->
     try
         Tokens = string:tokens(string:strip(StringVsn, right, $\n), ".-+"),
         lists:map(fun (Token) ->
                case string:to_integer(Token) of
                    {error, _} ->
                        Token;
                    {Int, []} ->
                        Int;
                    _ ->
                        Token
                end
            end,
            Tokens
        )
     catch
         _:_ ->
             rebar_utils:abort("Error parsing piqi version: ~p~n",
                               [StringVsn])
     end.
