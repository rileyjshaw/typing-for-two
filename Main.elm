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
    { leftTutor : Tutor.Model
    , rightTutor: Tutor.Model
    }



type Msg
  = LeftTutor Tutor.Msg
  | RightTutor Tutor.Msg


init : (Model, Cmd Msg)
init =
    let
        (tutorModel, tutorCmd) = Tutor.init
    in
        (Model tutorModel tutorModel, Cmd.batch
          [ Cmd.map LeftTutor tutorCmd
          , Cmd.map RightTutor tutorCmd
          ])


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
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
        [ Html.map LeftTutor (Tutor.view model.leftTutor)
        , Html.map RightTutor (Tutor.view model.rightTutor)
        ]

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ Sub.map LeftTutor (Tutor.subscriptions model.leftTutor)
    , Sub.map RightTutor (Tutor.subscriptions model.rightTutor)
    ]
