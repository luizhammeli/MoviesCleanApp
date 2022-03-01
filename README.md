# MoviesCleanApp

![](https://github.com/luizhammeli/MoviesCleanApp/workflows/CI-iOS/badge.svg)

MoviesCleanApp its a very simple study project using Clean Architecture concepts with MPV as UI anchitectural pattern. This project uses the TMDB api to show some currentily movies.

## Story: Customer requests to see their image feed

**Narrative #1):**

As an online user
I want the app to automatically load the latest movies in theaters
So I can always be updated

Project structure

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

- Improve the project features (Ex: Add some detail screen)
- Improve the UI/UX
- Add pagination

## Obs:
- The UI tests was added in the main module as a integration tests between the Main, UI and Presentation layers.
