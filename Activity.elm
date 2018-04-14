module Activity exposing (State, Msg, singleSelect, Activity)

import Html exposing (Html, text)
import Json.Decode as Decode exposing (Decoder, string)
import Json.Encode as Encode


type State
    = SingleSelect
    | MultiSelect
    | Custom Decode.Value


type Msg
    = SingleSelectMsg
    | MultiSelectMsg
    | CustomMsg Decode.Value


type alias Activity =
    { stateToJson : State -> Decode.Value
    , init : ( State, Cmd Msg )
    , view : State -> Html Msg
    , update : Msg -> State -> ( State, Cmd Msg )
    , subscriptions : State -> Sub Msg
    }


singleSelect =
    { stateToJson = (\state -> Encode.string "It worked")
    , init = ( SingleSelect, Cmd.none )
    , view = (\state -> text "Single Select")
    , update =
        (\msg state ->
            case msg of
                SingleSelectMsg ->
                    -- TODO: Implement SingleSelect
                    ( state, Cmd.none )

                _ ->
                    ( state, Cmd.none )
        )
    , subscriptions = \state -> Sub.none
    }
