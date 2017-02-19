# Project 1 - W1_Movies

**W1_Movies** is a movies app using the [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: **10** hours spent in total

## User Stories

The following **required** functionality is completed:

- [X] User can view a list of movies currently playing in theaters. Poster images load asynchronously.
- [X] User can view movie details by tapping on a cell.
- [X] User sees loading state while waiting for the API.
- [X] User sees an error message when there is a network error.
- [X] User can pull to refresh the movie list.

The following **optional** features are implemented:

- [X] Add a tab bar for **Now Playing** and **Top Rated** movies.
- [X] Implement segmented control to switch between list view and grid view.
- [X] Add a search bar.
- [X] All images fade in.
- [X] For the large poster, load the low-res image first, switch to high-res when complete.
- [X] Customize the highlight and selection effect of the cell.
- [X] Customize the navigation bar.

The following **additional** features are implemented:

- [X] Add a tab bar for **Popular** and **Upcoming** movies.
- [X] Add cancel button for search bar
- [X] Remember search value when back to Movies List from Movie Details View 

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='https://github.com/ttpthao/W1_Movies/blob/master/Movies.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

- I got an error message 'No such module AFNetworking' when import it to MoviesViewController although I already installed AFNetworking. I must retry 3 or 4 times then the problem have resolved.
- When I start to implement the error message when there is a network error, I do not know how to do it. Based on discussion in #questions group on slack, I did it.

## License

    Copyright 2017 Thao Tran

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
