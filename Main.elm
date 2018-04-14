module Main exposing (main)

import Html exposing (Html, program, div, button, text, h1)
import Html.Events exposing (onClick)
import Json.Decode as Decode exposing (Decoder, string)
import Json.Decode.Pipeline exposing (..)
import Dict exposing (Dict)
import Activity exposing (..)


init activity =
    let
        ( initialState, cmd ) =
            activity.init
    in
        ( { activity = activity, activityState = initialState }, Cmd.map ActivityMsg cmd )


subscriptions model =
    model.activity.subscriptions model.activityState
        |> Sub.map ActivityMsg


main : Program Never Model Msg
main =
    program { init = init singleSelect, view = view, update = update, subscriptions = subscriptions }


typeDecoder : Decoder String
typeDecoder =
    Decode.field "type" string


registry : Dict String (Decoder (Html msg))
registry =
    Dict.fromList
        [ ( "num", (Decode.map (\int -> text ("The number was " ++ toString int)) (Decode.field "value" Decode.int)) )
        , ( "word", (Decode.succeed (text "Word up")) )
        ]


viewFromJson =
    let
        json =
            """{
                "type":"num",
                "value":16
                }"""
    in
        case Decode.decodeString typeDecoder json of
            Ok key ->
                case Dict.get key registry of
                    Nothing ->
                        text "womp womp"

                    Just decoder ->
                        case Decode.decodeString decoder json of
                            Ok html ->
                                html

                            Err errMsg ->
                                text errMsg

            Err errorMessage ->
                text errorMessage


view : Model -> Html.Html Msg
view model =
    div []
        [ h1 [] [ text "Questions" ]
        , model.activity.view model.activityState |> Html.map ActivityMsg
        ]


type Msg
    = SubmitAnswer
    | ActivityMsg Activity.Msg


type alias Model =
    { activityState : Activity.State, activity : Activity }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SubmitAnswer ->
            ( model, Cmd.none )

        ActivityMsg activityMsg ->
            let
                ( newState, cmd ) =
                    model.activity.update activityMsg model.activityState
            in
                ( { model | activityState = newState }, Cmd.map ActivityMsg cmd )
