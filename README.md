# NFL Quarterback Performance Prediction
This repository contains the code and resources for a project aimed at predicting NFL quarterback performance metrics using advanced statistical and machine learning techniques. The project leverages comprehensive datasets from the nflverse ecosystem and integrates them into a robust predictive framework designed to benefit sports bettors and analysts.

## Project Overview
The primary goal of this project is to forecast key quarterback metrics such as passing yards, touchdowns, and interceptions. These projections are tailored for applications in sports betting, particularly player prop bets. The project also includes a Shiny application for users to interact with model outputs and explore implied probabilities based on betting odds.

## Features
### Predictive Models
The project employs a multi-method modeling approach:

Linear Regression: For capturing linear relationships with backward variable selection.
Elastic Net Regression: Combines Ridge and Lasso penalties to handle multicollinearity and perform feature selection.
Random Forests: Captures non-linear interactions between predictors, though with computational limitations for large datasets.
## Shiny Application
The interactive Shiny app provides:

Projected Quarterback Statistics: A reactable table displaying model-derived projections for metrics such as passing attempts, completions, rushing yards, and touchdowns. The table can be filtered by player, team, or week.
Implied Probability Calculator: Users can input American odds (positive or negative) to calculate implied probabilities, aiding in betting decision-making.
Key Predictors
Defensive metrics such as completions allowed and interceptions.
Rolling averages of player performance (e.g., passing yards, rushing touchdowns).
Contextual game data including weather, surface type, and opponent characteristics.
## Data Sources
This project uses data from nflverse, accessed via the nflreadr R package. The dataset includes:

Player gamelogs and statistics.
Play-by-play data enriched with defensive and contextual game-level metrics.
Advanced analytics such as Expected Points Added (EPA) and QBR.
Results
The models demonstrated strong predictive capabilities:

Linear and Elastic Net Models: Achieved high R-squared and low RMSE for metrics like passing yards and completions.
Defensive Metrics: Consistently ranked among the top predictors, highlighting the importance of opponent tendencies.
Limitations: Low variance in metrics such as touchdowns and interceptions constrained model performance. Dimensionality reduction was crucial for handling high-dimensional data in random forest models.
## Future Directions
Future iterations of this project aim to:

Incorporate play-level data and defensive coverage tendencies for enhanced granularity.
Explore ensemble modeling approaches to combine the strengths of multiple algorithms.
Extend predictions to other positions and team-level metrics.

License
This project is licensed under the MIT License. See the LICENSE file for details.
