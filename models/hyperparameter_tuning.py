# models/hyperparameter_tuning.py

from sklearn.model_selection import GridSearchCV
from sklearn.ensemble import RandomForestClassifier
import numpy as np

def hyperparameter_tuning(X_train, y_train):
    """
    Perform hyperparameter tuning using GridSearchCV to find the best hyperparameters.
    
    Parameters:
    - X_train: Training features.
    - y_train: Training labels.
    
    Returns:
    - Best model after tuning.
    """
    # Define the model and hyperparameters grid
    model = RandomForestClassifier(random_state=42)
    param_grid = {
        'n_estimators': [50, 100, 200],
        'max_depth': [None, 10, 20, 30],
        'min_samples_split': [2, 5, 10]
    }
    
    # Initialize GridSearchCV
    grid_search = GridSearchCV(estimator=model, param_grid=param_grid, cv=3, n_jobs=-1, verbose=2)
    
    # Fit the grid search to the training data
    grid_search.fit(X_train, y_train)
    
    # Get the best model
    best_model = grid_search.best_estimator_
    
    print(f"Best Parameters: {grid_search.best_params_}")
    
    return best_model
