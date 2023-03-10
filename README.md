# Alfagift iOS Developer Candidate Take-Home Test

This project is a mobile native application that shows movies using API from https://www.themoviedb.org/documentation/api/. 

## User Stories

1. **Main Screen** - Displays a grid of movie posters, either by listing or discovering them.
2. **Movie Info Screen** - Opens a new screen when a user clicks on a movie, showing the primary information about the movie.
3. **Movie Info Screen** - Displays user reviews for a movie.
4. **Movie Info Screen** - Shows the YouTube trailer for the movie.
5. **Main Screen** - Implements endless scrolling on a list of movies.
6. **Error Handling** - Covers positive and negative cases such as internet errors, etc.

## Architecture

The project was developed using the Model-View-ViewModel (MVVM) architecture pattern. The main components of the architecture are:

- **Model**: represents the data and the business logic of the application.
- **View**: represents the user interface of the application.
- **ViewModel**: acts as a bridge between the View and the Model, it exposes the data to the View, receives the user actions, and communicates with the Model.

## Dependencies

- **RxSwift**: used for reactive programming.
- **RxCocoa**: provides Cocoa-specific capabilities for RxSwift.
- **Moya**: used for networking.
- **Kingfisher**: used for image displaying and caching.
- **YouTubePlayer-Swift**: used for embedding and playing YouTube videos.
- **SnapKit**: used for layouting.
- **SkeletonView**: used for skeleton view animation when loading the image.

## Running the project

1. Clone the repository.
2. Install the dependencies using CocoaPods by running `pod install` on the command line.
3. Open `TheMovieIMDB.xcworkspace` and run the project on a simulator or a physical device.

## Unit Tests

The project has some unit tests for the `MovieMainViewModel` and `MovieInfoViewModel` using XCTest. The tests cover both success and failure cases for the `discoverMovies`, `searchVideo`, and `getMovieReviews` methods. The coverage for both tests are 100%

## Author

Renzo Adriano Alvaroshan

## License

This project is licensed under the MIT License - see the LICENSE.md file for details.
