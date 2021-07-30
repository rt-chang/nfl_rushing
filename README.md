# NFL Rushing Stats

### Data
The data is seeded from `priv/repo/rushing.json`. All records have the following attributes:
* `Player` (Player's name)
* `Team` (Player's team abbreviation)
* `Pos` (Player's postion)
* `Att/G` (Rushing Attempts Per Game Average)
* `Att` (Rushing Attempts)
* `Yds` (Total Rushing Yards)
* `Avg` (Rushing Average Yards Per Attempt)
* `Yds/G` (Rushing Yards Per Game)
* `TD` (Total Rushing Touchdowns)
* `Lng` (Longest Rush -- a `T` represents a touchdown occurred)
* `1st` (Rushing First Downs)
* `1st%` (Rushing First Down Percentage)
* `20+` (Rushing 20+ Yards Each)
* `40+` (Rushing 40+ Yards Each)
* `FUM` (Rushing Fumbles)

### Installation and running this solution
1. Clone this repo with `git clone https://github.com/rt-chang/nfl_rushing.git` on to your local machine
2. Install Docker if you do not already have it (https://docs.docker.com/engine/install/). Ensure Docker is running.
3. Navigate to the root of the project folder
4. Run `docker-compose build` to build the images
5. Run `docker-compose run phoenix mix ecto.setup` to create and seed the database
6. Run `docker-compose up`
7. Once that is successfully started, navigate to `http://localhost:4000` in your browser to view the app
