import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Tutor as Tutor

main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

type alias Model =
    { count : Int
    , leftTutor : Tutor.Model
    , rightTutor: Tutor.Model
    }

init : (Model, Cmd Msg)
init =
    let
        (tutorModel, tutorCmd) = Tutor.init
    in
        (Model 0 tutorModel tutorModel, Cmd.batch
          [ Cmd.map LeftTutor tutorCmd
          , Cmd.map RightTutor tutorCmd
          ])


type Msg
  = Increment
  | Decrement
  | LeftTutor Tutor.Msg
  | RightTutor Tutor.Msg


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Increment ->
            ({ model | count = model.count + 1 }, Cmd.none)

        Decrement ->
            ({ model | count = model.count - 1 }, Cmd.none)

        LeftTutor leftMsg ->
            let
                (leftModel, leftCmd) =
                    Tutor.update leftMsg model.leftTutor
            in
                ({ model | leftTutor = leftModel }, Cmd.map LeftTutor leftCmd)

        RightTutor rightMsg ->
            let
                (rightModel, rightCmd) =
                    Tutor.update rightMsg model.rightTutor
            in
                ({ model | rightTutor = rightModel }, Cmd.map RightTutor rightCmd)


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick Decrement ] [ text "-" ]
        , div [] [ text (toString model.count) ]
        , button [ onClick Increment ] [ text "+" ]
        , Html.map LeftTutor (Tutor.view model.leftTutor)
        , Html.map RightTutor (Tutor.view model.rightTutor)
        ]

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ Sub.map LeftTutor (Tutor.subscriptions model.leftTutor)
    , Sub.map RightTutor (Tutor.subscriptions model.rightTutor)
    ]
