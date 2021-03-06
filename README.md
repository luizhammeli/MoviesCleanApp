# MoviesCleanApp

![](https://github.com/luizhammeli/MoviesCleanApp/workflows/CI-iOS/badge.svg)

MoviesCleanApp is a very simple study project using Clean Architecture concepts with MPV as an UI anchitectural pattern. This project uses the TMDB api to show some current movies.

## Story: Customer requests to see some in theater movies

**Narrative:**

As an online user
I want the app to automatically load the latest movies in theaters.
So I can always be updated

## Use Cases

### Load Movies From Remote Use Case

#### Data:
- URL

#### Primary course (happy path):
1. Execute "Load Movies" command with above data.
2. System downloads data from the URL.
3. System validates downloaded data.
4. System creates movie feed from valid data.
5. System delivers the movies list.

#### No connectivity or Invalid data – error course (sad path):
1. System delivers generic error.

## Project structure

In order to make easy reason about it the project was organised into six modules:

**Structure (Modules):**

- Domain
- Data
- Infrastructure
- Presentation
- Main

## Getting Started
Build and run the Main module to execute the app in the simulator.

## Improvements:
- Improve the project features (Ex: Add some detail screen using some Router/Coordinator in the navigation flow)
- Improve the UI/UX
- Add pagination
- Improve the error course, handling different types of errors
- Cancel the request task when cell is not visible (In Progress), to avoid unncessary request.
- Add some UI tests to validate UI flows that is not trivial simulate with Unit Test. Ex: UIAlertController presentation

## Obs:
- The UI tests were added in the main module as integration tests between the Main, UI and Presentation layers.
- The project is just using the default URLSession cache policy, as a next feature we can think about a better custom policy rules using some local databse as Coredata.
- The Decorators and Proxy patterns was added mainly as way to not leaking composition details to other layers components like Use Cases or Presenters.
